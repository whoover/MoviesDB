//
//  MainFlowExitRoutingHandlerProtocol.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import Foundation
import MDBCommonUI

public protocol MainFlowRoutingExitHandler: FlowExitPointProtocol {
  func performRoute(_ coordinator: CoordinatorProtocol, outputModel: ModuleOutputModelProtocol)
}
