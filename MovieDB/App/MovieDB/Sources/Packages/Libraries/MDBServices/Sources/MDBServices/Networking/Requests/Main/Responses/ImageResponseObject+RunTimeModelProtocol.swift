//
//  ImageResponseObject.swift
//
//
//  Created by Artem Belenkov on 20.05.2021.
//

import Foundation
import MDBDataLayer

extension ImageResponseObject: RunTimeModelProtocol {
  public static func storableType() -> StorableProtocol.Type {
    EmptyStorable.self
  }

  public func convertToStorable() -> StorableProtocol {
    EmptyStorable(runtimeModel: self)
  }
}
