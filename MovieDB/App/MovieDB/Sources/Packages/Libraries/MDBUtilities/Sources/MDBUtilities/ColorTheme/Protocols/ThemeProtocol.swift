//
//  ThemeProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import SwiftUI
import UIKit

/// @mockable
public protocol ThemeProtocol {
  var images: ImagesThemeProtocol { get }
  var colors: ColorsThemeProtocol { get }
}
