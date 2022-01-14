//
//  RootDIComponent+Dependencies.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//

import Firebase
import Foundation
import MDBDataLayer
import MDBServices
import MDBUtilities

// MARK: Dependencies

extension RootDIComponent {
  /// Gives access to shared analytics service in children components.
  var analyticsService: AnalyticsServiceProtocol {
    shared { AnalyticsService(servicesTypes: [firebaseServiceType]) }
  }
}

extension RootDIComponent {
  /// Gives access to shared userDefaults service in children components. `UserDefaults.standart` by default.
  var userDefaults: UserDefaultsProtocol {
    UserDefaults.standard
  }
}

extension RootDIComponent {
  /// Gives access to shared theme storage service in children components. `UserDefaults.standart` by default.
  var themeStorage: ThemeStorageProtocol {
    UserDefaults.standard
  }
}

extension RootDIComponent {
  /// Gives access to shared bundle settings service in children components.
  var bundleSettingsService: BundleSettingsServiceProtocol {
    shared { BundleSettingsService(userDefaults: userDefaults, schemeService: schemeService) }
  }
}

extension RootDIComponent {
  /// Gives access to shared theme manager in children components.
  var themeManager: ThemeManagerProtocol {
    shared {
      ThemeManager(themeStorage: themeStorage,
                   defaultColor: ColorType.standard,
                   defaultMode: ModeType.light)
    }
  }
}

extension RootDIComponent {
  var saveImagesService: ImageSaveServiceProtocol {
    shared {
      ImageSaveService()
    }
  }
}

extension RootDIComponent {
  var copyService: CopyServiceProtocol {
    shared {
      CopyService(themesManager: themeManager, localizer: localizer)
    }
  }
}

extension RootDIComponent {
  /// Gives access to shared localizer in children components.
  var localizer: LocalizerProtocol {
    shared {
      Localizer(userDefaults: userDefaults)
    }
  }
}

extension RootDIComponent {
  /// Gives access to shared database service in children components.
  var databaseService: DatabaseServiceProtocol {
    shared { DatabaseService() }
  }
}

extension RootDIComponent {
  /// Gives access to shared networking provider in children components.
  var networkingProvider: NetworkingProviderProtocol {
    shared {
      NetworkingProvider(
        appScheme: schemeService.currentScheme,
        bundleSettingsService: bundleSettingsService,
        applicationStateHandlerService: applicationStateHandlerService
      )
    }
  }
}

extension RootDIComponent {
  /// Gives access to shared scheme service in children components.
  var schemeService: SchemeServiceProtocol {
    shared {
      var service = SchemeService()
      #if DEBUG
        service.currentScheme = .debug
      #elseif UITESTS
        service.currentScheme = .uiTests
      #else
        service.currentScheme = .release
      #endif

      return service
    }
  }
}

extension RootDIComponent {
  /// Gives access to shared scheme service in children components.
  var firebaseServiceType: FirebaseProtocol.Type {
    FirebaseApp.self
  }
}

extension RootDIComponent {
  var indexationService: IndexationServiceProtocol {
    IndexationService(userDefautls: userDefaults)
  }
}

extension RootDIComponent {
  var applicationStateHandlerService: ApplicationStateHandlerServiceProtocol {
    ApplicationStateHandlerService()
  }
}
