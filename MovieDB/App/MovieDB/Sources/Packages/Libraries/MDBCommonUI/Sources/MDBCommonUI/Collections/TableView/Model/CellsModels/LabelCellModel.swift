//
//  LabelCellModelProtocol.swift
//  MDBCommonUI
//
//

import UIKit

/// Represents cell model for `LabelCell`
public struct LabelCellModel: CellModelProtocol {
  /// cell title
  var title: String
  /// cell textColor
  var textColor: UIColor?
  /// cell backgroundColor
  var backgroundColor: UIColor
}

/// Extension for cell class
public extension LabelCellModel {
  static var cellClass: CellProtocol.Type {
    LabelCell.self
  }
}
