//
//  CountryStorableModel.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation
import MDBDataLayer
import RealmSwift

public final class MovieStorableModel: Object, StorableProtocol {
  @Persisted var adult: Bool = false
  @Persisted var title: String = ""
  @Persisted var overview: String = ""
  @Persisted var popularity: Double = 0.0
  @Persisted var id: Int = 0
  @Persisted var posterPath: String = ""
  @Persisted var voteAverage: Double = 0.0
  @Persisted var voteCount: Int = 0
  @Persisted var releaseDate: TimeInterval?

  override init() {
    super.init()
  }

  public convenience init(
    adult: Bool,
    id: Int,
    title: String,
    overview: String,
    popularity: Double,
    posterPath: String,
    releaseDate: TimeInterval?,
    voteAverage: Double,
    voteCount: Int
  ) {
    self.init()
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

  public func createRuntimeModel() -> RunTimeModelProtocol {
    var newReleaseDate: Date?
    if let releaseDate = releaseDate {
      newReleaseDate = Date(timeIntervalSince1970: releaseDate)
    }

    return MovieRuntimeModel(
      adult: adult,
      id: id,
      title: title,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      releaseDate: newReleaseDate,
      voteAverage: voteAverage,
      voteCount: voteCount
    )
  }

  override public class func primaryKey() -> String? {
    "id"
  }
}
