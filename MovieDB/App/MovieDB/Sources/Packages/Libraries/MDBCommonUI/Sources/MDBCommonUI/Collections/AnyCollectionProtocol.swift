//
//  AnyCollectionProtocol.swift
//  MDBCommonUI
//
//

/// Protocol that represents any collection type. `UITableView`, `UICollectionView` are already conformed to.
public protocol AnyCollectionProtocol {
  /// Registers the array of cell classes.
  func registerCellClasses(_ cellClasses: [CellProtocol.Type])
  /// Registers single cell class.
  func registerCellClass(_ cellClass: CellProtocol.Type)
  /// Custom dequeue method with Cell type.
  func dequeueCell(_ cellClass: CellProtocol.Type, _ indexPath: IndexPath) -> CellProtocol
  /// Custom dequeue method with Cell model.
  func dequeueCell(_ cellModel: CellModelProtocol, _ indexPath: IndexPath) -> CellProtocol

  /// Native methods of tableView and collectionView.
  func registerCell(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String)
  func registerCell(_ nib: UINib?, forCellReuseIdentifier identifier: String)
}

/// Extension for `AnyCollectionProtocol` with methods realizations.
public extension AnyCollectionProtocol {
  func registerCellClasses(_ cellClasses: [CellProtocol.Type]) {
    cellClasses.forEach { registerCellClass($0) }
  }

  func registerCellClass(_ cellClass: CellProtocol.Type) {
    registerCell(cellClass, forCellReuseIdentifier: cellClass.identifier)
  }
}
