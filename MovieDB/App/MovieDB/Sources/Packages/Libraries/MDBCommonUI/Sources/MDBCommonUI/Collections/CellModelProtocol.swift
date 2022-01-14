//
//  CellModel.swift
//  MDBCommonUI
//
//

import Combine
import CoreGraphics

/// Cell model protocol.
public protocol CellModelProtocol {
  /// Static accessor to cell type.
  static var cellClass: CellProtocol.Type { get }
  /// Static accessor to cell height.
  static var cellHeight: CGFloat { get }
  /// Static accessor to cell width.
  static var cellWidth: CGFloat { get }
}

/// Cell model protocol's default values extension.
public extension CellModelProtocol {
  /// Cell height for all cells of some type.
  static var cellHeight: CGFloat {
    44.0
  }

  /// Cell width for all cells of some type.
  static var cellWidth: CGFloat {
    0
  }
}

/// Protocol to elements that have accessability identifiers.
public protocol AccessabilityElementProtocol {
  /// Accessability identifier.
  var accessabilityIdentifier: String? { get set }
}

/// Protocol cells that can be moved.
public protocol IndividualMovableProtocol {
  var canBeMoved: Bool { get set }
}

/// Protocol cells that have invidual height (if model conforms to this protocol, `static var cellHeight: CGFloat` will be ignored ).
public protocol IndividualHeightProtocol {
  /// Cell height
  var individualHeight: CGFloat { get set }
}

/// Protocol to cell that has separator.
public protocol ViewWithSeparatorModelProtocol {
  /// Indicates if cell should show separator
  var showSeparator: Bool { get set }
}
