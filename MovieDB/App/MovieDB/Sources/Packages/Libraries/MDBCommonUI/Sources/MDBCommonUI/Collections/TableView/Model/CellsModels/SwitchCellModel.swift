//
//  SwitchCellModel.swift
//  MDBCommonUI
//
//

import Combine

/// Represents cell model for `SwitchCell`
public class SwitchCellModel: CellModelProtocol {
  /// `@Published` switch state
  @Published public var switchState: Bool = false
  /// cell title
  public var title: String = ""
  /// cell backgroundColor
  public var backgroundColor: UIColor = .white

  private var subscriptions = Set<AnyCancellable>()

  public init() {}
}

/// Extension for cell class
public extension SwitchCellModel {
  static var cellClass: CellProtocol.Type {
    SwitchTableViewCell.self
  }
}
