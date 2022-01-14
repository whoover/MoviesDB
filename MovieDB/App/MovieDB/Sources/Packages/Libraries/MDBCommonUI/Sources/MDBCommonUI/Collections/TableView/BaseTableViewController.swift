//
//  BaseTableViewController.swift
//  MDBCommonUI
//
//

import UIKit

/// Enum that contains table view actions
public enum TableViewAction {
  case prefetchRowsAt(indexPaths: [IndexPath])
  case didMoveCell(from: IndexPath, toIndex: IndexPath)
  case didSelectCell(indexPath: IndexPath)
  case willDisplayCell(UITableViewCell, indexPath: IndexPath)
  case willDisplayHeaderView(UIView, section: Int)
  case willEndDisplayCell(indexPath: IndexPath, cell: UITableViewCell)
  case prepare(cell: UITableViewCell, indexPath: IndexPath)
}

public enum ScrollViewAction {
  case willBeginDragging(UIScrollView)
  case didScroll(UIScrollView)
  case willEndDragging(UIScrollView, velocity: CGPoint)
  case didEndDragging(UIScrollView, decelerate: Bool)
  case didEndDecelerating(UIScrollView)
}

/// Class that represents base table view controller implementation
@objcMembers
open class BaseTableViewController<
  DataSource: TableViewDataSourceModelProtocol
>: UIViewController,
  UITableViewDelegate,
  UITableViewDataSource,
  UITableViewDataSourcePrefetching
{
  private var tableView = UITableView()

  /// Table view data source model. Updates `cellsToRegister` on `didSet`.
  public var dataSourceModel: DataSource? {
    didSet {
      cellsToRegister.removeAll()
      cellsToRegister.append(contentsOf: dataSourceModel?.uniqueCellClasses() ?? [])
      tableView.registerCellClasses(cellsToRegister)
    }
  }

  public var refreshControl: UIRefreshControl? {
    get {
      tableView.refreshControl
    } set {
      tableView.refreshControl = newValue
    }
  }

  private let cellActionSubject = PassthroughSubject<CellAction, Never>()
  /// Publisher that subscribed to all `ActionableCell` cells in table view (`CellAction`).
  public var cellActionPublisher: AnyPublisher<CellAction, Never> {
    cellActionSubject.eraseToAnyPublisher()
  }

  private let tableActionSubject = PassthroughSubject<TableViewAction, Never>()
  /// Publisher that subscribed to all table view actions (`TableViewAction`).
  public var tableActionPublisher: AnyPublisher<TableViewAction, Never> {
    tableActionSubject.eraseToAnyPublisher()
  }

  private let scrollActionSubject = PassthroughSubject<ScrollViewAction, Never>()
  public var scrollActionPublisher: AnyPublisher<ScrollViewAction, Never> {
    scrollActionSubject.eraseToAnyPublisher()
  }

  private var statusBarStyle: UIStatusBarStyle = .default
  override open var preferredStatusBarStyle: UIStatusBarStyle {
    statusBarStyle
  }

  private var subscriptions = Set<AnyCancellable>()
  private var cellsToRegister: [CellProtocol.Type] = []

  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

    tableView.add(to: view).do {
      $0.delegate = self
      $0.dataSource = self
      $0.prefetchDataSource = self
      $0.registerCellClasses(cellsToRegister)
      $0.edgesToSuperview()
    }
  }

  public func setupPreferredStatusBarStyle(_ value: UIStatusBarStyle) {
    statusBarStyle = value
  }

  /// Method to additional setup some settings to tableView from outside of controller.
  public func setupTableView(_ setupBlock: (_ tableView: UITableView) -> Void) {
    setupBlock(tableView)
  }

  /// Reloads tableView data.
  public func reloadData() {
    tableView.reloadData()
  }

  public func reloadCell(at indexPath: IndexPath) {
    if let visibleIndexPath = tableView.indexPathsForVisibleRows?.first(where: { $0 == indexPath }) {
      UIView.performWithoutAnimation {
        tableView.reloadRows(at: [visibleIndexPath], with: .none)
      }
    }
  }

  public func insertCells(indexPaths: [IndexPath]) {
    tableView.performBatchUpdates {
      tableView.insertRows(at: indexPaths, with: .fade)
    }
  }

  /// Returns cell for row at index path.
  public func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
    tableView.cellForRow(at: indexPath)
  }

  public func cellModelFor(indexPath: IndexPath) -> CellModelProtocol? {
    dataSourceModel?.sections[indexPath.section].cells[indexPath.row]
  }

  /// Returns indexPath for cell.
  public func indexPath(for cell: UITableViewCell) -> IndexPath? {
    tableView.indexPath(for: cell)
  }

  /// Moves row from one index path to another.
  public func moveRow(at indexPath: IndexPath, toIndexPath: IndexPath) {
    dataSourceModel?.move(indexPath, toIndexPath)
    tableView.beginUpdates()
    tableView.moveRow(at: indexPath, to: toIndexPath)
    tableView.endUpdates()
    tableView.reloadSections([toIndexPath.section], with: .none)
  }

  /// `BaseTableViewController`'s extension for `UITableViewDelegate`, `UITableViewDataSource`.
  // It's not possible to add methods of objc members to extension.
  open func numberOfSections(in _: UITableView) -> Int {
    dataSourceModel?.sections.count ?? 0
  }

  public func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let section = dataSourceModel?.sections[section] else {
      return 0
    }
    return (section as? IndividualHeightProtocol)?.individualHeight ?? type(of: section).headerHeight
  }

  open func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
    (dataSourceModel?.sections[section] as? CustomHeaderSectionModelProtocol)?.header as? String
  }

  open func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = (dataSourceModel?.sections[section] as? CustomHeaderSectionModelProtocol)?.header as? UIView
    headerView?.accessibilityIdentifier = "base-table_header-\(section)_view"
    return headerView
  }

  open func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSourceModel?.sections[section].cells.count ?? 0
  }

  open func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let cellModel = dataSourceModel?.sections[indexPath.section].cells[indexPath.row] else {
      return 0.0
    }
    return (cellModel as? IndividualHeightProtocol)?.individualHeight ?? type(of: cellModel).cellHeight
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cellModel = dataSourceModel?.sections[indexPath.section].cells[indexPath.row],
          let cell = tableView.dequeueCell(type(of: cellModel).cellClass, indexPath) as? UITableViewCell
    else {
      return UITableViewCell()
    }

    (cell as? ConfigurableCellProtocol)?.configure(cellModel, indexPath)
    (cell as? ActionableCellProtocol)?.setup(actionSubject: cellActionSubject)

    if let accessaibilityElementModel = cellModel as? AccessabilityElementProtocol {
      cell.accessibilityIdentifier = accessaibilityElementModel.accessabilityIdentifier
    }

    return cell
  }

  open func tableView(
    _: UITableView,
    editingStyleForRowAt _: IndexPath
  ) -> UITableViewCell.EditingStyle {
    guard let dataSourceModel = dataSourceModel else {
      return .none
    }
    return type(of: dataSourceModel).editingStyle
  }

  open func tableView(_: UITableView, shouldIndentWhileEditingRowAt _: IndexPath) -> Bool {
    guard let dataSourceModel = dataSourceModel else {
      return false
    }
    return type(of: dataSourceModel).shouldIndentWhileEditing
  }

  open func tableView(_: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    guard let dataSourceModel = dataSourceModel else {
      return false
    }
    guard let individualMovableModel = (dataSourceModel.sections[indexPath.section]
      .cells[indexPath.row] as? IndividualMovableProtocol)
    else {
      return type(of: dataSourceModel).canMoveCells
    }

    return individualMovableModel.canBeMoved
  }

  public func tableView(_: UITableView,
                        targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                        toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath
  {
    guard let movingAcceptSectionModel = dataSourceModel?.sections[proposedDestinationIndexPath.section]
      as? MovingAcceptSectionModelProtocol,
      movingAcceptSectionModel.acceptInsertMovingCells
    else {
      return sourceIndexPath
    }

    guard !movingAcceptSectionModel.notAcceptedIndexes.contains(proposedDestinationIndexPath.row) else {
      return sourceIndexPath
    }

    return proposedDestinationIndexPath
  }

  public func tableView(_: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    tableActionSubject.send(.prefetchRowsAt(indexPaths: indexPaths))
  }

  public func tableView(_: UITableView,
                        moveRowAt sourceIndexPath: IndexPath,
                        to destinationIndexPath: IndexPath)
  {
    dataSourceModel?.move(sourceIndexPath, destinationIndexPath)
    tableActionSubject.send(.didMoveCell(from: sourceIndexPath, toIndex: destinationIndexPath))
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    guard let cell = tableView.cellForRow(at: indexPath),
          !(cell is ActionableCellProtocol)
    else {
      return
    }

    tableActionSubject.send(.didSelectCell(indexPath: indexPath))
  }

  public func tableView(_: UITableView,
                        willDisplay cell: UITableViewCell,
                        forRowAt indexPath: IndexPath)
  {
    tableActionSubject.send(.willDisplayCell(cell, indexPath: indexPath))
  }

  public func tableView(_: UITableView,
                        willDisplayHeaderView view: UIView,
                        forSection section: Int)
  {
    tableActionSubject.send(.willDisplayHeaderView(view, section: section))
  }

  public func tableView(_: UITableView,
                        didEndDisplaying cell: UITableViewCell,
                        forRowAt indexPath: IndexPath)
  {
    tableActionSubject.send(.willEndDisplayCell(indexPath: indexPath, cell: cell))
  }

  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    scrollActionSubject.send(.willBeginDragging(scrollView))
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    scrollActionSubject.send(.didScroll(scrollView))
  }

  public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                        withVelocity velocity: CGPoint,
                                        targetContentOffset _: UnsafeMutablePointer<CGPoint>)
  {
    scrollActionSubject.send(.willEndDragging(scrollView, velocity: velocity))
  }

  public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    scrollActionSubject.send(.didEndDragging(scrollView, decelerate: decelerate))
  }

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    scrollActionSubject.send(.didEndDecelerating(scrollView))
  }
}
