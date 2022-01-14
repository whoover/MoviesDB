//
//  CustomErrorHandler+Extensions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBNetworking

public extension CustomErrorHolder where Decoder.Input == Data {
  func checkIfDataHasError(_ data: Data) -> Error? {
    do {
      let errorModel = try decoder.decode(type(of: self).validationErrorType, from: data)
      return ServerRequestError.serverResponse(errorModel)
    } catch {
      return nil
    }
  }
}
