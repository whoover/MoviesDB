//
//  CountryRuntimeModel.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBDataLayer

public struct MovieRuntimeModel: Equatable {
  public let adult: Bool
  public let id: Int
  public let title: String
  public let overview: String
  public let popularity: Double
  public let posterPath: String
  public let releaseDate: Date?
  public let voteAverage: Double
  public let voteCount: Int

  public init(
    adult: Bool,
    id: Int,
    title: String,
    overview: String,
    popularity: Double,
    posterPath: String,
    releaseDate: Date?,
    voteAverage: Double,
    voteCount: Int
  ) {
    self.adult = adult
    self.id = id
    self.title = title
    self.overview = overview
    self.popularity = popularity
    self.posterPath = posterPath
    self.releaseDate = releaseDate
    self.voteAverage = voteAverage
    self.voteCount = voteCount
  }
}

extension MovieRuntimeModel: RunTimeModelProtocol {
  public static func storableType() -> StorableProtocol.Type {
    MovieStorableModel.self
  }

  public func convertToStorable() -> StorableProtocol {
    MovieStorableModel(
      adult: adult,
      id: id,
      title: title,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      releaseDate: releaseDate?.timeIntervalSince1970,
      voteAverage: voteAverage,
      voteCount: voteCount
    )
  }
}
