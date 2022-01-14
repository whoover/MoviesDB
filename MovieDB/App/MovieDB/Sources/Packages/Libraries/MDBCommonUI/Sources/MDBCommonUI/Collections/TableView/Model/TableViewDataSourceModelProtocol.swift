//
//  TableViewDataSource.swift
//  MDBCommonUI
//
//

import UIKit

/// Represents table view datasource model
public protocol TableViewDataSourceModelProtocol {
  associatedtype Section: TableViewSectionModelProtocol

  /// Table view's editing style. `none` by default.
  static var editingStyle: UITableViewCell.EditingStyle { get }
  /// Table view's shouldIndentWhileEditing setting. `false` by default.
  static var shouldIndentWhileEditing: Bool { get }
  /// Indicates if cell can be moved inside table. `false` by default.
  static var canMoveCells: Bool { get }

  /// Array with sections models
  var sections: [Section] { get set }
}

/// `TableViewDataSourceModelProtocol` extension for default values
public extension TableViewDataSourceModelProtocol {
  static var editingStyle: UITableViewCell.EditingStyle {
    .none
  }

  static var shouldIndentWhileEditing: Bool {
    false
  }

  static var canMoveCells: Bool {
    false
  }

  /// Returns unique cell classes in all sections
  func uniqueCellClasses() -> [CellProtocol.Type] {
    sections
      .flatMap(\.cells)
      .map { type(of: $0).cellClass }
      .reduce([]) {
        var containsClass = false
        for cellClass in $0 {
          if String(describing: cellClass) == String(describing: $1) {
            containsClass = true
            break
          }
        }
        return containsClass ? $0 : $0 + [$1]
      }
  }

  /// Move cell model from one index path to another
  mutating func move(_ fromIndexPath: IndexPath, _ toIndexPath: IndexPath) {
    let model = sections[fromIndexPath.section].cells[fromIndexPath.row]
    sections[fromIndexPath.section].cells.remove(at: fromIndexPath.row)
    sections[toIndexPath.section].cells.insert(model, at: toIndexPath.row)
  }
}

/// Represents table view section model
public protocol TableViewSectionModelProtocol {
  associatedtype Cell: CellModelProtocol
  /// Header height
  static var headerHeight: CGFloat { get }

  /// Cells models array
  var cells: [Cell] { get set }

  init()
}

/// Represents table view section model that accept moving cells
public protocol MovingAcceptSectionModelProtocol {
  /// Property that indicates in section accept imsert moving cells
  var acceptInsertMovingCells: Bool { get set }
  /// Array with indexes there moving is not accepted
  var notAcceptedIndexes: [Int] { get }
}

/// Represents custom header section model
public protocol CustomHeaderSectionModelProtocol {
  /// Header of section
  var header: SectionHeader { get set }
}

public protocol CustomHeaderSectionModelGenericProtocol: CustomHeaderSectionModelProtocol {
  /// Generic header
  associatedtype Header: SectionHeader
  /// Property with section header model
  var genericHeader: Header { get set }
}

public extension CustomHeaderSectionModelGenericProtocol {
  /// Default header implementation for generic protocol.
  var header: SectionHeader {
    get { genericHeader }
    set {
      if let value = newValue as? Header {
        genericHeader = value
      }
    }
  }
}

public extension TableViewSectionModelProtocol {
  /// Default header height
  static var headerHeight: CGFloat {
    0
  }
}

/// Section header protocol (String, UIView are conformed)
public protocol SectionHeader {}
extension String: SectionHeader {}
extension UIView: SectionHeader {}
