//
//  ActionCellModel.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBCommonUI

public protocol ActionCellModelProtocol: BaseCellModelProtocol {
  var arrowImage: UIImage? { get set }
  var arrowColor: UIColor? { get set }
  var actionTitle: String? { get set }
  var actionColor: UIColor? { get set }
  var isArrowHidden: Bool { get set }
}
