//
//  DailyLimitsResponseResponseModel.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBDataLayer
import MDBModels
import MDBNetworking

public struct MoviesListResponse: BaseResponseProtocol {
  public let results: [Result]
  public let totalPages: Int

  public struct Result: Decodable {
    public let adult: Bool
    public let id: Int
    public let title: String
    public let overview: String
    public let popularity: Double
    public let posterPath: String
    public let releaseDate: String
    public let voteAverage: Double
    public let voteCount: Int
  }
}
