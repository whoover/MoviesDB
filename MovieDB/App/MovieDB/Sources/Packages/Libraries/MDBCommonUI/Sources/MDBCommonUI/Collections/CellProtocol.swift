//
//  CellProtocol.swift
//  MDBCommonUI
//
//

import Combine

/// Cell protocol. Already conformed next types: `UITableViewCell`, `UICollectionReusableView`, `UITableViewHeaderFooterView`.
public protocol CellProtocol: NibLoadableProtocol {
  /// Cell's identifier.
  static var identifier: String { get }
}

/// Protocol for cell that can be configured.
public protocol ConfigurableCellProtocol: AnyObject {
  /// Current index path of cell.
  var indexPath: IndexPath { get }

  /// Method to configure cell with model for specified index path.
  func configure(_ cellModel: CellModelProtocol,
                 _ indexPath: IndexPath)
}

/// Extension to `CellProtocol` that returns cell identifier (by default equal to it's `nibName`).
public extension CellProtocol where Self: UIView {
  static var identifier: String {
    nibName
  }
}

/// Represents `CellAction` enum for `ActionableCellProtocol` type.
public enum CellAction {
  case switchAction(Bool, indexPath: IndexPath)
}

/// Represents cell protocol with possible actions (like `UIButton` event, `UISwitch` etc.)
public protocol ActionableCellProtocol {
  /// Cell's action publiser.
  func setup(actionSubject: PassthroughSubject<CellAction, Never>?)
}

extension UITableViewCell: CellProtocol {}
extension UICollectionReusableView: CellProtocol {}
extension UITableViewHeaderFooterView: CellProtocol {}
