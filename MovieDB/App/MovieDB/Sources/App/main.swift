//
//  main.swift
//  MovieDB
//
//

import UIKit

/// File that represents iOS app entry point.

/// Fake app delegate to use during tests.
class FakeAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  {
    if window == nil {
      window = UIWindow(frame: CGRect.zero)
    }
    window?.rootViewController = UIViewController()
    return true
  }
}

/// If target doesn't have XCTestCase class it meens that it's not a test target.d
let isRunningTests = NSClassFromString("XCTestCase") != nil

if isRunningTests {
  _ = UIApplicationMain(CommandLine.argc,
                        CommandLine.unsafeArgv,
                        NSStringFromClass(UIApplication.self),
                        NSStringFromClass(FakeAppDelegate.self))
} else {
  _ = UIApplicationMain(CommandLine.argc,
                        CommandLine.unsafeArgv,
                        NSStringFromClass(UIApplication.self),
                        NSStringFromClass(AppDelegate.self))
}
