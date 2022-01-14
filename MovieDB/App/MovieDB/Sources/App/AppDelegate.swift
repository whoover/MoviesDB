//
//  AppDelegate.swift
//  MovieDB
//
//  Created by Artem Belenkov on 08.01.2022
//

@_exported import MDBCommon
@_exported import UIKit

/// AppDelegate.
class AppDelegate: UIResponder, UIApplicationDelegate {
  /// MovieDB instance.
  private lazy var movieDB: ApplicationProtocol = {
    registerProviderFactories()
    return RootDIComponent().movieDB
  }()

  // MARK: UIApplicationDelegate methods

  func application(_ application: UIApplication,
                   willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil)
    -> Bool
  {
    movieDB.willFinishLaunching(application, with: launchOptions)
  }

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  {
    movieDB.didFinishLaunching(application, with: launchOptions)
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    movieDB.didBecomeActive(application)
  }

  func applicationWillResignActive(_ application: UIApplication) {
    movieDB.willResignActive(application)
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    movieDB.didEnterBackground(application)
  }

  func applicationWillTerminate(_ application: UIApplication) {
    movieDB.willTerminate(application)
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    movieDB.openURL(app, url: url, options: options)
  }

  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
  {
    movieDB.didRegisterForRemoteNotifications(application, with: deviceToken)
  }

  func application(_ application: UIApplication,
                   didFailToRegisterForRemoteNotificationsWithError error: Error)
  {
    movieDB.didFailToRegisterForRemoteNotifications(application, error: error)
  }

  func application(_ application: UIApplication,
                   performActionFor shortcutItem: UIApplicationShortcutItem,
                   completionHandler: @escaping (Bool) -> Void)
  {
    movieDB.performAction(application,
                          shortcutItem: shortcutItem,
                          completionHandler: completionHandler)
  }

  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void)
    -> Bool
  {
    movieDB.continueUserActivity(application,
                                 userActivity: userActivity,
                                 restorationHandler: restorationHandler)
  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    movieDB.application(
      application,
      didReceiveRemoteNotification: userInfo,
      fetchCompletionHandler: completionHandler
    )
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    movieDB.application(application, didReceiveRemoteNotification: userInfo)
  }
}
