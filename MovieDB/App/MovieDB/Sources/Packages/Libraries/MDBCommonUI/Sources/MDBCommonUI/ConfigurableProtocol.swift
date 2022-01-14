//
//  ConfigurableProtocol.swift
//  MDBCommonUI
//
//

/// InterfaceConfigurationProtocol represents object that holds all configurations.
public protocol InterfaceConfigurationProtocol {
//    var colors: ThemeColorsProtocol { get }
//    var fonts: FontStylesProtocol { get }
//    var localization: LocalizationManagerProtocol { get }
}

public protocol ConfigurableProtocol {
  var configurator: InterfaceConfigurationProtocol? { get }

  func configure()
}

public extension ConfigurableProtocol {
  func configure() {
    (self as? LocalizationConfigurableProtocol)?.configurateLocalization()
    (self as? FontConfigurableProtocol)?.configurateFonts()
    (self as? ColorConfigurableProtocol)?.configurateColors()
    (self as? AccessabilityConfigurableProtocol)?.configurateAccessability()
    (self as? AppearanceConfigurableProtocol)?.configurateAppearance()
  }
}

public protocol LocalizationConfigurableProtocol {
  func configurateLocalization()
}

public protocol FontConfigurableProtocol {
  func configurateFonts()
}

public protocol ColorConfigurableProtocol {
  func configurateColors()
}

public protocol AccessabilityConfigurableProtocol {
  func configurateAccessability()
}

public protocol AppearanceConfigurableProtocol {
  func configurateAppearance()
}
