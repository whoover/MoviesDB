//
//  UITableView+AnyCollectionProtocol.swift
//  MDBCommonUI
//
//

import UIKit

/// Extension to `AnyCollectionProtocol` for `UITableView`.
extension UITableView: AnyCollectionProtocol {
  public func registerCell(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
    register(cellClass, forCellReuseIdentifier: identifier)
  }

  public func registerCell(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
    register(nib, forCellReuseIdentifier: identifier)
  }

  public func dequeueCell(_ cellClass: CellProtocol.Type, _ indexPath: IndexPath) -> CellProtocol {
    dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath)
  }

  public func dequeueCell(_ cellModel: CellModelProtocol, _ indexPath: IndexPath) -> CellProtocol {
    dequeueCell(type(of: cellModel).cellClass, indexPath)
  }

  public func registerWithNib<T: UITableViewCell>(cellType: T.Type) {
    let bundle = cellType.bundle
    let nib = UINib(nibName: cellType.identifier, bundle: bundle)
    register(nib, forCellReuseIdentifier: cellType.identifier)
  }

  public func dequeue<T: UITableViewCell>(cell: T.Type) -> T {
    guard let reusableCell = dequeueReusableCell(withIdentifier: cell.identifier) as? T else {
      fatalError("Can't reuse cell: \(cell.identifier)")
    }
    return reusableCell
  }

  public func registerHeaderViewWithNib<T: UITableViewHeaderFooterView>(viewType: T.Type) {
    let bundle = viewType.bundle
    let nib = UINib(nibName: viewType.identifier, bundle: bundle)
    register(nib, forHeaderFooterViewReuseIdentifier: viewType.identifier)
  }

  public func dequeueHeaderView<T: UITableViewHeaderFooterView>(view: T.Type) -> T {
    guard let reusableView = dequeueReusableHeaderFooterView(withIdentifier: view.identifier) as? T else {
      fatalError("Can't reuse header view: \(view.identifier)")
    }
    return reusableView
  }
}
