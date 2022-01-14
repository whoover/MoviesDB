//
//  InteractorProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public protocol InteractorProtocol {
  associatedtype PresenterInput

  var presenter: PresenterInput? { get set }
}
