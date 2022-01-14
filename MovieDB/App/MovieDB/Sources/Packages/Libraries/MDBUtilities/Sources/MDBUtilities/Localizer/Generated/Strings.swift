// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum ActivityIndicator {
    /// Loading
    public static let onLoadingTitle = L10n.tr("localizable", "activityIndicator.onLoadingTitle")
  }

  public enum Button {
    /// Back
    public static let back = L10n.tr("localizable", "button.back")
    /// Cancel
    public static let cancel = L10n.tr("localizable", "button.cancel")
    /// OK
    public static let ok = L10n.tr("localizable", "button.ok")
    /// Try Again
    public static let tryAgain = L10n.tr("localizable", "button.tryAgain")
  }

  public enum Copy {
    /// Copied
    public static let copied = L10n.tr("localizable", "copy.copied")
  }

  public enum Error {
    /// Something went wrong
    public static let common = L10n.tr("localizable", "error.common")
    /// No internet connection
    public static let internet = L10n.tr("localizable", "error.internet")
  }

  public enum Indexation {
    /// Movies
    public static let description = L10n.tr("localizable", "indexation.description")
  }

  public enum Main {
    public enum Movies {
      public enum List {
        /// Movies List
        public static let title = L10n.tr("localizable", "main.movies.list.title")
      }
    }
  }
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = Bundle.main.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
