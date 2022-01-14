//
//  MovieDB.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//

import Combine
import MDBServices
import UIKit

/// Typealias for lauch options dictionary.
typealias ApplicationOptions = [UIApplication.LaunchOptionsKey: Any]

/// Protocol that represents application abstraction. It handles all `UIApplicationDelegate` method calls.
protocol ApplicationProtocol {
  func willFinishLaunching(_ application: UIApplication,
                           with options: ApplicationOptions?) -> Bool
  func didFinishLaunching(_ application: UIApplication,
                          with options: ApplicationOptions?) -> Bool

  func didBecomeActive(_ application: UIApplication)
  func willResignActive(_ application: UIApplication)
  func didEnterBackground(_ application: UIApplication)
  func willTerminate(_ application: UIApplication)

  func openURL(_ application: UIApplication,
               url: URL,
               options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool

  func didRegisterForRemoteNotifications(_ application: UIApplication,
                                         with tokenData: Data)
  func didFailToRegisterForRemoteNotifications(_ application: UIApplication,
                                               error: Error)

  func performAction(_ application: UIApplication,
                     shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void)

  func continueUserActivity(_ application: UIApplication,
                            userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  )

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any]
  )
}

/// MovieDB class that represents the main implementation of `ApplicationProtocol`.
class MovieDB: ApplicationProtocol {
  /// appCoordinator to coordinate to needed screen using deep links.
  private let appCoordinator: AppCoordinatorProtocol
  /// property to handle app state update from AppDelegate.
  private let appStateHandler: AppStateHandlerProtocol

  private var subscriptions = Set<AnyCancellable>()

  /// Init with `AppBuilder` DI, that has access to all instances needed as properties.
  init(appBuilder: AppBuilder) {
    appCoordinator = appBuilder.appCoordinator
    appStateHandler = appBuilder.appStateHandler
  }

  // MARK: AppDelegate methods handling

  func willFinishLaunching(_ application: UIApplication,
                           with options: ApplicationOptions?) -> Bool
  {
    true
  }

  func didFinishLaunching(_ application: UIApplication,
                          with options: ApplicationOptions?) -> Bool
  {
    appStateHandler.initialSetup(completion: { notificationsEnabled in
      if notificationsEnabled {}
    })

    appCoordinator.initialSetup()
    appCoordinator.start()
    return true
  }

  func didBecomeActive(_ application: UIApplication) {}

  func willResignActive(_ application: UIApplication) {}

  func didEnterBackground(_ application: UIApplication) {}

  func willTerminate(_ application: UIApplication) {}

  func openURL(_ application: UIApplication,
               url: URL,
               options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool
  {
    guard let option = DeepLinks.create(from: url) else {
      return true
    }

    appCoordinator.handle(option: option)

    return true
  }

  func didRegisterForRemoteNotifications(_ application: UIApplication,
                                         with tokenData: Data)
  {}

  func didFailToRegisterForRemoteNotifications(_ application: UIApplication,
                                               error: Error) {}

  func performAction(_ application: UIApplication,
                     shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {}

  func continueUserActivity(_ application: UIApplication,
                            userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
  {
    true
  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {}

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any]
  ) {}
}
