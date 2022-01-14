//
//  MainFlowCoordinator.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import MDBCommonUI

public typealias MainFlowExitPoints =
  MoviesListCoordinatorExitRoutingProtocol &
  MovieDetailsCoordinatorExitRoutingProtocol

/// Represents Main flow coordinator.
public protocol MainFlowCoordinatorProtocol: CoordinatorProtocol {}

public class MainFlowCoordinator: BaseFlowCoordinator<MainFlowRoutingExitHandler>,
  MainFlowCoordinatorProtocol
{
  private let routingCalculator: MainFlowRoutingCalculatorProtocol
  private let interactor: MainFlowInteractorProtocol
  private let builder: MainFlowCoordinatorBuilder

  public init(builder: MainFlowCoordinatorBuilder) {
    interactor = builder.interactor
    routingCalculator = builder.routingCalculator(routingConfigsProviderProtocol: interactor)
    self.builder = builder
    super.init()
  }

  override public func start(with option: DeepLinkOptionProtocol?,
                             setupBlock: CoordinatorSetupBlock?)
  {
    let route = routingCalculator.directRoute(option as? MainFlowOption)
    performRouting(route, setupBlock: setupBlock)
  }

  private func performRouting(_ route: MainFlowOption, setupBlock: CoordinatorSetupBlock?) {
    switch route {
    case .moviesList:
      embedMoviesList(flowSetupBlock: setupBlock)
    case let .movieDetails(option):
      startMoviesDetailsFlow(option: option)
    case .end:
      break
    }
  }

  private func embedMoviesList(flowSetupBlock: CoordinatorSetupBlock?) {
    let coordinator = builder.moviesListCoordinator(exitPoint: self)
    addChild(coordinator)
    coordinator.start { [weak self] result in
      guard let toPresent = result.toPresent() else {
        return
      }

      let navigation = BaseNavigation(rootViewController: toPresent)
      self?.router.setViewController(navigation)
      flowSetupBlock?(navigation)
    }
  }

  private func startMoviesDetailsFlow(option: DeepLinkOptionProtocol) {
    let coordinator = builder.movieDetailsCoordinator(exitPoint: self)
    addChild(coordinator)
    coordinator.start(with: option) { [weak self] in
      guard let toPresent = $0.toPresent() else {
        return
      }

      self?.router.push(toPresent, completion: nil)
    }
  }
}

// MARK: MainFlowExitPoints

extension MainFlowCoordinator: MainFlowExitPoints {
  public func performRoute(_ coordinator: CoordinatorProtocol, ouputModel: ModuleOutputModelProtocol) {
    let option = routingCalculator.createOption(from: ouputModel)
    performRouting(
      routingCalculator.directRoute(option),
      setupBlock: nil
    )
  }
}
