//
//  NetworkingProvider.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import MDBConstants
import MDBNetworking
import MDBUtilities

/// @mockable
public protocol NetworkingProviderProtocol {
  var networkingService: NetworkingServiceProtocol { get }
}

public final class NetworkingProvider: NetworkingProviderProtocol {
  enum NetworkingType {
    case normal
    case stub
  }

  private let appScheme: AppScheme
  private var subscriptions = Set<AnyCancellable>()
  private var environment: MovieDBEnvironment?

  private var currentNetworkingType: NetworkingType?
  private let bundleSettingsService: BundleSettingsServiceProtocol
  private let applicationStateHandlerService: ApplicationStateHandlerServiceProtocol

  private var _networkingService: NetworkingServiceProtocol?
  public var networkingService: NetworkingServiceProtocol {
    guard let networkingService = _networkingService else {
      let newNetworkingService = networking(networkingType)
      _networkingService = newNetworkingService
      return newNetworkingService
    }

    let networkingType = networkingType
    if currentNetworkingType != networkingType {
      currentNetworkingType = networkingType
      let networkingService = networking(networkingType)
      _networkingService = networkingService
      return networkingService
    }

    return networkingService
  }

  public init(
    appScheme: AppScheme,
    bundleSettingsService: BundleSettingsServiceProtocol,
    applicationStateHandlerService: ApplicationStateHandlerServiceProtocol
  ) {
    self.appScheme = appScheme
    self.bundleSettingsService = bundleSettingsService
    self.applicationStateHandlerService = applicationStateHandlerService
    bundleSettingsService.environment.sink { [unowned self] environment in
      self.environment = environment
    }.store(in: &subscriptions)
    currentNetworkingType = networkingType
  }

  private var networkingType: NetworkingType {
    networkTypeFromScheme
  }

  private var networkTypeFromScheme: NetworkingType {
    switch appScheme {
    case .release, .debug:
      return .normal
    case .uiTests:
      return .stub
    }
  }

  private var httpUrlProvider: BaseUrlProvider {
    switch appScheme {
    case .release:
      return PreProdHTTPUrlProvider()
    case .debug, .uiTests:
      return StageHTTPUrlProvider(
        appScheme: appScheme,
        environment: environment
      )
    }
  }

  private func networking(_ type: NetworkingType) -> NetworkingServiceProtocol {
    switch type {
    case .normal:
      let ignoreSecurityCheck: Bool
      switch appScheme {
      case .uiTests, .debug:
        ignoreSecurityCheck = true
      case .release:
        ignoreSecurityCheck = false
      }
      return NetworkingService(
        httpService: HTTPDefaultService(
          publicKeyValidator: PublicKeyDefaultValidator(hashes: [""])
        ),
        httpUrlProvider: httpUrlProvider,
        ignoreSecurityCheck: ignoreSecurityCheck
      )
    case .stub:
      return NetworkingStubService()
    }
  }
}
