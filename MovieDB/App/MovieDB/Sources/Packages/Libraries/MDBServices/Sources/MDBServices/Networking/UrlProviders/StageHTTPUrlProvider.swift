//
//  StageHTTPUrlProvider.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBNetworking
import MDBUtilities

public struct PreProdHTTPUrlProvider: BaseUrlProvider {
  public var version: String {
    ""
  }

  public var port: Int? {
    nil
  }

  public var scheme: String {
    "https"
  }

  public var host: String {
    NetworkEnvironment.production.baseUrl
  }

  public init() {}
}

public struct StageHTTPUrlProvider: BaseUrlProvider {
  public var version: String {
    ""
  }

  public var port: Int? {
    guard let environment = environment else {
      return nil
    }
    switch environment {
    case .prod:
      return nil
    default:
      return nil
    }
  }

  public var scheme: String {
    "https"
  }

  public var host: String {
    NetworkEnvironment.environmentForScheme(
      appScheme,
      environment: environment ?? .debug
    ).baseUrl
  }

  private let appScheme: AppScheme
  private var environment: MovieDBEnvironment?
  private var subscriptions = Set<AnyCancellable>()

  public init(
    appScheme: AppScheme,
    environment: MovieDBEnvironment?
  ) {
    self.appScheme = appScheme
    self.environment = environment
  }
}
