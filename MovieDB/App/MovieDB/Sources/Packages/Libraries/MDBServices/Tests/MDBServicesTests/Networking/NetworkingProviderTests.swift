//
//  NetworkingProviderTests.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import AAServices
@testable import AAServicesMocks
@testable import MDBUtilities
@testable import MDBUtilitiesMocks
import XCTest

final class NetworkingProviderTests: XCTestCase {
  func testNetworkingProvider() {
    let schemes = AppScheme.allCases
    let environments = MovieDBEnvironment.allCases
    let bundleSettingsService = BundleSettingsServiceProtocolMock()

    for scheme in schemes {
      let provider = NetworkingProvider(appScheme: scheme,
                                        bundleSettingsService: bundleSettingsService)

      for env in environments {
        bundleSettingsService.environmentSubject.send(env)

        switch env {
        case .prod, .stage, .debug, .preProd:
          switch scheme {
          case .uiTests:
            XCTAssertTrue(provider.networkingService is NetworkingStubService)
          case .release, .stage, .debug, .preProd:
            XCTAssertFalse(provider.networkingService is NetworkingStubService)
          }
        }
      }
    }
  }
}
