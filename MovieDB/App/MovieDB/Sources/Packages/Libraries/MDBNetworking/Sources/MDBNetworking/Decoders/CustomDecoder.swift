//
//  CustomDecoder.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public protocol CustomDecoder: TopLevelDecoder {
  associatedtype Decoder: CustomDecoder
  static func create() -> Decoder
}
