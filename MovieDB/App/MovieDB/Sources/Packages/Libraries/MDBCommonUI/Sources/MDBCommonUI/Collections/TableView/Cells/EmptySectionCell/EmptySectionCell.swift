//
//  EmptySectionCell.swift
//  MDBCommonUI
//
//

/// Represents empty section cell
public class EmptySectionCell: UITableViewCell, ConfigurableCellProtocol {
  public private(set) var indexPath: IndexPath = .init(index: 0)

  public func configure(_ cellModel: CellModelProtocol, _ indexPath: IndexPath) {
    guard let model = cellModel as? EmptySectionCellModel else {
      return
    }

    self.indexPath = indexPath
    backgroundColor = model.backgroundColor
  }
}
