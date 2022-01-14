//
//  UIViewController+Additions.swift
//
//
//

import SwiftUI

/// Extension to `UIViewController` to simplify adding child controllers.
public extension UIViewController {
  /// Method to add child controller to specified view and set custom constraints.
  func addChildController(_ viewController: UIViewController,
                          _ constraintsBlock: (_ view: UIView) -> Void)
  {
    addChildController(viewController, view, constraintsBlock)
  }

  /// Method to add child controller to specified view and set custom constraints.
  func addChildController(_ viewController: UIViewController,
                          _ toView: UIView,
                          _ constraintsBlock: (_ view: UIView) -> Void)
  {
    let previouslyAdded = children.contains(viewController)
    if previouslyAdded {
      viewController.beginAppearanceTransition(true, animated: true)
    }

    viewController.willMove(toParent: self)

    addChild(viewController)
    toView.addSubview(viewController.view)
    constraintsBlock(viewController.view)

    viewController.didMove(toParent: self)

    if previouslyAdded {
      viewController.endAppearanceTransition()
    }
  }

  /// Returns last child controller in controllers chain.
  func lastChild() -> UIViewController {
    guard let lastChildController = children.last else {
      return self
    }
    return lastChildController.lastChild()
  }
}

public extension UIViewController {
  /// Indicates if `UIViewController` is presented modally.
  var isModal: Bool {
    if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
      return false
    } else if presentingViewController != nil {
      return true
    } else if navigationController != nil,
              navigationController?.presentingViewController?.presentedViewController == navigationController
    {
      return true
    } else if tabBarController?.presentingViewController is UITabBarController {
      return true
    } else {
      return false
    }
  }
}

/// Extension to `UIViewController` to show submodules.
public extension UIViewController {
  func removeSubmoduleFromParent() {
    removeFromParent()
    view.removeFromSuperview()
  }

  func showSubmodule(_ presentable: PresentableProtocol,
                     _ container: UIView,
                     _ setupBlock: ((UIView) -> Void)? = nil)
  {
    guard let viewControllerToPresent = presentable.toPresent() else {
      return
    }

    addChildController(viewControllerToPresent, container) { view in
      if let setupBlock = setupBlock {
        setupBlock(view)
      } else {
        view.edgesToSuperview()
      }
    }
  }

  func showSubmodule(_ presentable: PresentableProtocol,
                     _ containerController: UIViewController,
                     _ setupBlock: ((UIView) -> Void)? = nil)
  {
    guard let viewControllerToPresent = presentable.toPresent() else {
      return
    }
    containerController.addChildController(viewControllerToPresent) { view in
      if let setupBlock = setupBlock {
        setupBlock(view)
      } else {
        view.edgesToSuperview()
      }
    }
  }
}

/// Extensiton for `UIViewController`
public extension UIViewController {
  /// Makes navigation bar clear color
  func makeClearNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(
      UIImage(), for: .default
    )
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
  }

  func setTitleWithLeftAlign(label: UILabel) {
    let button = UIBarButtonItem(customView: label)
    navigationItem.leftBarButtonItem = button
  }

  func setAppTitleColorIfNeeded(_ color: UIColor = .white) {
    guard let navigationController = navigationController else {
      return
    }

    navigationController.navigationBar.barStyle = .default

    var textAttributes = navigationController.navigationBar.titleTextAttributes ?? [:]
    textAttributes[NSAttributedString.Key.foregroundColor] = color
    navigationController.navigationBar.titleTextAttributes = textAttributes
  }
}

/// Extensiton for `UIViewController`
public extension UIViewController {
  /// Add a SwiftUI `View` as a child to current `ViewController`.
  ///
  /// - Parameters:
  ///   - swiftUIContent: The SwiftUI `View` to add as a child.
  ///   - constraints: `Array<NSLayoutConstraint>` of swiftUIContent.
  func addSwiftUIView<Content: SwiftUI.View>(
    _ swiftUIContent: Content,
    constraintsHandler: ((UIView) -> [NSLayoutConstraint])? = nil
  ) {
    let hostingController = UIHostingController(rootView: swiftUIContent)
    hostingController.view.backgroundColor = .clear

    addChildController(hostingController) { [unowned self] content in
      content.translatesAutoresizingMaskIntoConstraints = false

      if let constraints = constraintsHandler?(content) {
        self.view.addConstraints(constraints)
      } else {
        self.view.addConstraints([
          content.topAnchor.constraint(equalTo: self.view.topAnchor),
          content.leftAnchor.constraint(equalTo: self.view.leftAnchor),
          content.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
          content.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
      }
    }
  }
}

extension UIViewController {
  /// Add tap gesture on view. Hide keyboard when tapped on controller view's
  public func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc
  func dismissKeyboard() {
    view.endEditing(true)
  }
}

public extension UIViewController {
  func topMostViewController() -> UIViewController {
    if let presented = presentedViewController {
      return presented.topMostViewController()
    }

    if let navigation = self as? UINavigationController {
      return navigation.visibleViewController?.topMostViewController() ?? navigation
    }

    if let tab = self as? UITabBarController {
      return tab.selectedViewController?.topMostViewController() ?? tab
    }

    return self
  }
}

/// Navigation Items
public extension UIViewController {
  enum NavigationItemsType {
    case leftBarButtonItem(UIBarButtonItem)
    case leftBarButtonItems([UIBarButtonItem])
    case rightBarButtonItem(UIBarButtonItem)
    case rightBarButtonItems([UIBarButtonItem])
  }

  private var navigationBarAccessibilityIdentifier: String {
    "navigationBarAccessibilityIdentifier"
  }

  func addToNavigation(type: NavigationItemsType) {
    let navBar: UINavigationBar

    if
      let navigationBar = navigationController?.navigationBar ??
      view.subviews
      .first(
        where: {
          $0.accessibilityIdentifier == navigationBarAccessibilityIdentifier
        }
      ) as? UINavigationBar
    {
      navBar = navigationBar
    } else {
      navBar = UINavigationBar()
      navBar.add(to: view).do {
        $0.edgesToSuperview(
          excluding: .bottom,
          usingSafeArea: true
        )
        $0.height(44)

        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true
      }
    }

    let navItem = navBar.items?.last ?? UINavigationItem()

    switch type {
    case let .leftBarButtonItem(item):
      navItem.leftBarButtonItem = item
    case let .leftBarButtonItems(items):
      navItem.leftBarButtonItems = items
    case let .rightBarButtonItem(item):
      navItem.rightBarButtonItem = item
    case let .rightBarButtonItems(items):
      navItem.rightBarButtonItems = items
    }

    guard
      let items = navBar.items,
      !items.isEmpty
    else {
      navBar.items = [navItem]

      return
    }

    if !items.contains(navItem) {
      navBar.pushItem(navItem, animated: false)
    }
  }

  /// Setup navigation back button title for next screen in navigation controller stack
  func setupBackButton(title: String?) {
    navigationItem.backButtonTitle = title
  }

  /// Setup navigation bar tint color, default tint value from navigation bar appearance
  /// - Parameter color: color of navigation bar, default - appearance color
  func setupNavigationBarTint(color: UIColor? = UINavigationBar.appearance().tintColor) {
    navigationController?.navigationBar.tintColor = color
  }
}
