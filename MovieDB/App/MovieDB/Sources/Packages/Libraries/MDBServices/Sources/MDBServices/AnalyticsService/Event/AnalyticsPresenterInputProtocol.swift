//
//  AnalyticsPresenterInputProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public protocol AnalyticsPresenterInputProtocol {
  var screenName: String? { get }
  var coordinatorPath: String? { get }
}
