//
//  DailyLimitsRequest.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import MDBModels

public final class MoviesListRequest: GetHttpRequest<
  MoviesListResponse,
  JSONDecoder
>, HTTPRequestProtocol {
  public typealias RuntimeModelType = MovieRuntimeModel

  override public var path: String {
    "4/list/\(page)"
  }

  override public var headers: [String: String] {
    super.headers + ["charset": "utf-8"]
  }

  override public var route: String {
    urlRoute.stringRepresentation()
  }

  override public var urlParameters: URLParameters {
    [
      "api_key": apiKey
    ]
  }

  private let page: Int
  private let apiKey: String

  public init(page: Int, apiKey: String) {
    self.page = page
    self.apiKey = apiKey
  }
}
