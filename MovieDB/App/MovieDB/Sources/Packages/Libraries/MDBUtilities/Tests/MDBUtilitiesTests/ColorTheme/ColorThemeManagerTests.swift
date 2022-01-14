@testable import MDBUtilities
@testable import MDBUtilitiesMocks
import XCTest

func themeWithColor(_ color: UIColor) -> ThemeProtocolMock {
  let introFirstColorsTheme = IntroColorsThemeProtocolMock()
  introFirstColorsTheme.title = color

  let imagesFirstTheme = ImagesThemeProtocolMock()

  let colorsFirstTheme = ColorsThemeProtocolMock()
  colorsFirstTheme.intro = introFirstColorsTheme

  return ThemeProtocolMock(
    images: imagesFirstTheme,
    colors: colorsFirstTheme
  )
}

final class TestFirstColorThemeFactoryProtocol: ColorThemeFactoryProtocol {
  static func create(_ color: ColorTypeProtocol) -> ThemeProtocol {
    switch color {
    case _ as BlueColorTypeProtocolMock:
      return themeWithColor(.red)
    case _ as OrangeColorTypeProtocolMock:
      return themeWithColor(.blue)
    default:
      return themeWithColor(.black)
    }
  }
}

final class TestSecondColorThemeFactoryProtocol: ColorThemeFactoryProtocol {
  static func create(_ color: ColorTypeProtocol) -> ThemeProtocol {
    switch color {
    case _ as BlueColorTypeProtocolMock:
      return themeWithColor(.yellow)
    case _ as OrangeColorTypeProtocolMock:
      return themeWithColor(.green)
    default:
      return themeWithColor(.black)
    }
  }
}

final class BlueColorTypeProtocolMock: ColorTypeProtocolMock {}

final class OrangeColorTypeProtocolMock: ColorTypeProtocolMock {}

final class LightModeTypeProtocolMock: ModeTypeProtocolMock {}

final class DarkModeTypeProtocolMock: ModeTypeProtocolMock {}

final class ColorThemeManagerTests: XCTestCase {
  var testFirstThemeType: ModeTypeProtocolMock!
  var testSecondThemeType: ModeTypeProtocolMock!
  var testColorThemeStorage: ThemeStorageProtocolMock!
  var subscriptions = Set<AnyCancellable>()

  override func setUp() {
    super.setUp()

    testFirstThemeType = LightModeTypeProtocolMock()
    testFirstThemeType.factoryTypeHandler = {
      TestFirstColorThemeFactoryProtocol.self
    }

    testSecondThemeType = DarkModeTypeProtocolMock()
    testSecondThemeType.factoryTypeHandler = {
      TestSecondColorThemeFactoryProtocol.self
    }

    testColorThemeStorage = ThemeStorageProtocolMock()
    testColorThemeStorage.currentColor = BlueColorTypeProtocolMock()
    testColorThemeStorage.currentMode = testFirstThemeType
  }

  override func tearDown() {
    subscriptions.removeAll()

    testColorThemeStorage = nil

    testSecondThemeType = nil

    testFirstThemeType = nil

    super.tearDown()
  }

  func testChangingColor() {
    let themeManager = ThemeManager(
      themeStorage: testColorThemeStorage,
      defaultColor: BlueColorTypeProtocolMock(),
      defaultMode: testFirstThemeType
    )

    var testColorValues = [
      UIColor.red,
      UIColor.blue
    ]

    themeManager.themePublisher.sink { theme in
      let rightColorValue = testColorValues.first
      testColorValues.removeFirst()

      XCTAssertEqual(theme.colors.intro.title, rightColorValue)
    }.store(in: &subscriptions)

    XCTAssertEqual(themeManager.currentTheme.colors.intro.title, .red)
    themeManager.currentColor = OrangeColorTypeProtocolMock()
  }

  func testChangingTheme() {
    let themeManager = ThemeManager(
      themeStorage: testColorThemeStorage,
      defaultColor: BlueColorTypeProtocolMock(),
      defaultMode: testFirstThemeType
    )

    var testColorValues = [
      UIColor.red,
      UIColor.yellow,
      UIColor.green
    ]

    themeManager.themePublisher.sink { theme in
      let rightColorValue = testColorValues.first
      testColorValues.removeFirst()

      XCTAssertEqual(theme.colors.intro.title, rightColorValue)
    }.store(in: &subscriptions)

    XCTAssertEqual(themeManager.currentTheme.colors.intro.title, .red)
    themeManager.currentMode = testSecondThemeType
    themeManager.currentColor = OrangeColorTypeProtocolMock()
  }
}
