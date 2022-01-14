import Foundation
import Network

public enum MDBConstants {
  public enum UserDefaultsKeys {
    public enum AppInteractor: String {
      case hasLoggedInBeforeKey
      case isFirstAppRun
    }

    public enum BundleSettings: String {
      case environment
    }

    public enum UserPreferences: String {
      case notificationsEnabled
      case analyticsEnabled
    }
  }

  public enum NotificationInfo {
    public static let badgeKey = "badge"
  }

  public static let ApiKey = "0f75bad2ed91f089fa5828fb0679512d"

  public enum Keychain: String {
    case service = "com.whoover.movie-db.keychainService"
    case group = "com.whoover.movie-db.keychainGroup"
  }

  public enum DateFormats {
    public static let format24h = "YYYY.MM.dd HH:mm"
    public static let formatA = "YYYY.MM.dd HH:mm a"
  }

  public enum UpdateApp {
    public static func testFlight() -> URL? {
      URL(string: "https://testflight.apple.com/v1/app/???")
    }

    public static func appStore() -> URL? {
      URL(string: "https://apps.apple.com/app/???")
    }
  }
}
