//
//  MoviesListCoordinator.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import MDBCommonUI

/// Represents MoviesList module coordinator.
public protocol MoviesListCoordinatorProtocol: CoordinatorProtocol,
  MoviesListRoutingHandlingProtocol {}

public class MoviesListCoordinator: BaseCoordinator<MoviesListCoordinatorExitRoutingProtocol>,
  MoviesListCoordinatorProtocol
{
  private let builder: MoviesListCoordinatorBuilder

  public init(builder: MoviesListCoordinatorBuilder) {
    self.builder = builder
    super.init()
  }

  override public func start(with option: DeepLinkOptionProtocol?,
                             setupBlock: CoordinatorSetupBlock?)
  {
    guard let toPresent = builder.moduleMoviesList(output: nil, routingHandler: self).toPresent() else {
      return
    }

    router.setViewController(toPresent)
    setupBlock?(toPresent)
  }
}

/// Extension to pass routing to parent flow coordinator.
extension MoviesListCoordinator: MoviesListRoutingHandlingProtocol {
  public func performRoute(ouputModel: ModuleOutputModelProtocol) {
    coordinationExitPoint?.performRoute(self, ouputModel: ouputModel)
  }
}
