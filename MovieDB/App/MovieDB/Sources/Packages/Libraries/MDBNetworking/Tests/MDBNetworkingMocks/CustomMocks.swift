//
//  CustomMocks.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
@_exported import MDBNetworking

public final class TestRequest: GetHttpRequest<
  ContainerSequenceModel<TestResponseModel>,
  JSONDecoder
> {
  override public var path: String {
    "country"
  }

  override public var route: String {
    "common"
  }
}

public struct TestResponseModel: BaseResponseProtocol {
  public let name: String
}
