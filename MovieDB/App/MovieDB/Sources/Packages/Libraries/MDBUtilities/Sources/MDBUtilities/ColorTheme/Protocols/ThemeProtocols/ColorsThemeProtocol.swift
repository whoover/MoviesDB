//
//  ColorsThemeProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBCommonUI
import SwiftUI
import UIKit

// MARK: - Colors

/// @mockable
public protocol ColorsThemeProtocol {
  var main: MainColorsThemeProtocol { get }
  var components: ComponentsColorsThemeProtocol { get }
}
