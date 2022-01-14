//
//  ColorThemeManager.swift
//  MDBCommonUI
//
//

import MDBCommon

/// @mockable
public protocol ThemeManagerProtocol {
  var currentMode: ModeTypeProtocol { get set }
  var currentColor: ColorTypeProtocol { get set }

  var themePublisher: AnyPublisher<ThemeProtocol, Never> { get }
  var currentTheme: ThemeProtocol { get }
}

public final class ThemeManager: ThemeManagerProtocol {
  private enum ColorThemeConstants {
    static let kModeKey = "kModeKey"
    static let kColorKey = "kColorKey"
  }

  public var currentColor: ColorTypeProtocol {
    didSet {
      themeStorage.currentColor = currentColor
      theme = currentMode.factoryType().create(currentColor)
    }
  }

  public var currentMode: ModeTypeProtocol {
    didSet {
      themeStorage.currentMode = currentMode
      theme = currentMode.factoryType().create(currentColor)
    }
  }

  public var themePublisher: AnyPublisher<ThemeProtocol, Never> {
    $theme.eraseToAnyPublisher()
  }

  public var currentTheme: ThemeProtocol {
    theme
  }

  private var themeStorage: ThemeStorageProtocol
  @Published private var theme: ThemeProtocol

  public init(themeStorage: ThemeStorageProtocol,
              defaultColor: ColorTypeProtocol,
              defaultMode: ModeTypeProtocol)
  {
    self.themeStorage = themeStorage
    currentColor = themeStorage.currentColor ?? defaultColor
    currentMode = themeStorage.currentMode ?? defaultMode
    theme = currentMode.factoryType().create(currentColor)
  }
}
