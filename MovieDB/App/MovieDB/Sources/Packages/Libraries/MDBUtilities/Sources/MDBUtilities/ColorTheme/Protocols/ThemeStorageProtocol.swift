//
//  ThemeStorageProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

/// @mockable
public protocol ThemeStorageProtocol {
  var currentColor: ColorTypeProtocol? { get set }
  var currentMode: ModeTypeProtocol? { get set }
}

extension UserDefaults: ThemeStorageProtocol {
  public static let kCurrentColorKey = "kCurrentColorKey"
  public static let kCurrentModeKey = "kCurrentModeKey"

  public var currentColor: ColorTypeProtocol? {
    get {
      object(forKey: type(of: self).kCurrentColorKey) as? ColorTypeProtocol
    }
    set {
      set(newValue, forKey: type(of: self).kCurrentColorKey)
    }
  }

  public var currentMode: ModeTypeProtocol? {
    get {
      object(forKey: type(of: self).kCurrentModeKey) as? ModeTypeProtocol
    }
    set {
      set(newValue, forKey: type(of: self).kCurrentModeKey)
    }
  }
}
