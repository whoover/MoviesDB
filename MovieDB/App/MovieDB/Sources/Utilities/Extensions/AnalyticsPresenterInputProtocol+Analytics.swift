//
//  AnalyticsPresenterInputProtocol+Analytics.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBCommonUI
import MDBServices

public extension AnalyticsPresenterInputProtocol where Self: PresenterProtocol {
  var screenName: String? {
    guard let view = view else {
      return nil
    }

    return String(describing: view)
  }

  var coordinatorPath: String? {
    (view as? AnalyticsViewInputProtocol)?.coordinatorPath
  }
}
