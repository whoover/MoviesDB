//
//  MainFlowOption.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//
//

import Foundation
import MDBCommonUI
import MDBModels

public enum MainFlowOption: DeepLinkOptionProtocol {
  case moviesList
  case movieDetails(MovieDetailsOption)

  case end
}

public struct MovieDetailsOption: DeepLinkOptionProtocol {
  let model: MovieRuntimeModel
}
