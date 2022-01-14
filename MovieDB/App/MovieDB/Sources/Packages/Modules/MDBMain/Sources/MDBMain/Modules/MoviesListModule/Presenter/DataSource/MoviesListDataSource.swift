//
//  MoviesListDataSource.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBCommonUI
import MDBModels

public final class MoviesListDataSource<T: TableViewSectionModelProtocol>: TableViewDataSourceModelProtocol {
  public var sections: [T] = [T()]
}

extension MoviesListDataSource {
  func movieModel(indexPath: IndexPath) -> MovieRuntimeModel? {
    guard let model = sections[0].cells[safe: indexPath.row] as? MoviesListCellModel else {
      return nil
    }

    return model.model
  }

  func resetList() {
    sections[0].cells = []
  }
}

public final class MoviesListSection<T: CellModelProtocol>: TableViewSectionModelProtocol {
  public var cells: [T] = []

  public init() {}
}

public final class MoviesListCellModel: CellModelProtocol {
  public static var cellClass: CellProtocol.Type {
    MoviesListCell.self
  }

  public static var cellHeight: CGFloat {
    100
  }

  let model: MovieRuntimeModel
  var image: UIImage?

  init(model: MovieRuntimeModel) {
    self.model = model
  }
}
