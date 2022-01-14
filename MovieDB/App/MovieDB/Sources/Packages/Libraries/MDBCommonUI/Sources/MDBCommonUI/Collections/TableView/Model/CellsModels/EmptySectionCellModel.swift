//
//  EmptySectionCellModelProtocol.swift
//  MDBCommonUI
//
//

import UIKit

/// Represents cell model for `EmptySectionCell`
public struct EmptySectionCellModel: CellModelProtocol, IndividualHeightProtocol {
  /// cell backgroundColor
  public var backgroundColor: UIColor

  /// cell height
  public var individualHeight: CGFloat

  public init(height: CGFloat,
              backgroundColor: UIColor = .clear)
  {
    individualHeight = height
    self.backgroundColor = backgroundColor
  }
}

/// Extension for cell class
public extension EmptySectionCellModel {
  static var cellClass: CellProtocol.Type {
    EmptySectionCell.self
  }
}
