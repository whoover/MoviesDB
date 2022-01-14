//
//  MovieDetailsCoordinator.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import MDBCommonUI

/// Represents MovieDetails module coordinator.
public protocol MovieDetailsCoordinatorProtocol: CoordinatorProtocol,
  MovieDetailsRoutingHandlingProtocol {}

public class MovieDetailsCoordinator: BaseCoordinator<MovieDetailsCoordinatorExitRoutingProtocol>,
  MovieDetailsCoordinatorProtocol
{
  private let builder: MovieDetailsCoordinatorBuilder

  public init(builder: MovieDetailsCoordinatorBuilder) {
    self.builder = builder
    super.init()
  }

  override public func start(with option: DeepLinkOptionProtocol?,
                             setupBlock: CoordinatorSetupBlock?)
  {
    guard let option = option as? MovieDetailsOption else {
      return
    }

    let module = builder.moduleMovieDetails(output: nil, routingHandler: self)
    module.input.setup(movieModel: option.model)

    guard let toPresent = module.toPresent() else {
      return
    }

    router.setViewController(toPresent)
    setupBlock?(toPresent)
  }
}

/// Extension to pass routing to parent flow coordinator.
extension MovieDetailsCoordinator: MovieDetailsRoutingHandlingProtocol {
  public func performRoute(ouputModel: ModuleOutputModelProtocol) {
    coordinationExitPoint?.performRoute(self, ouputModel: ouputModel)
  }
}
