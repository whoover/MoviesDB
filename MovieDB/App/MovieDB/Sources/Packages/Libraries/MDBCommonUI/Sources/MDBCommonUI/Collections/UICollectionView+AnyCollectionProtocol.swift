//
//  UICollectionView+AnyCollectionProtocol.swift
//  MDBCommonUI
//
//

import UIKit

/// Extension to `AnyCollectionProtocol` for `UICollectionView`.
extension UICollectionView: AnyCollectionProtocol {
  public func dequeueCell(_ cellClass: CellProtocol.Type, _ indexPath: IndexPath) -> CellProtocol {
    dequeueReusableCell(withReuseIdentifier: cellClass.identifier, for: indexPath)
  }

  public func registerCell(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
    register(cellClass, forCellWithReuseIdentifier: identifier)
  }

  public func registerCell(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
    register(nib, forCellWithReuseIdentifier: identifier)
  }

  public func dequeueCell(_ cellModel: CellModelProtocol, _ indexPath: IndexPath) -> CellProtocol {
    dequeueCell(type(of: cellModel).cellClass, indexPath)
  }

  public func registerWithNib<T: UICollectionViewCell>(cellType: T.Type) {
    let bundle = cellType.bundle
    let nib = UINib(nibName: cellType.identifier, bundle: bundle)
    register(nib, forCellWithReuseIdentifier: cellType.identifier)
  }

  public func dequeue<T: UICollectionViewCell>(cell: T.Type, for indexPath: IndexPath) -> T {
    guard let reusableCell = dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as? T else {
      fatalError("Can't reuse cell: \(cell.identifier)")
    }
    return reusableCell
  }
}
