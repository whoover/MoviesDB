//
//  TouchRecognizer.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

open class TouchRecognizer: UIGestureRecognizer {
  open var callback: () -> Void
  open var ignoreViews: [UIView]?
  open var canPreventOtherGestureRecognizers: Bool = true
  /// enable touches on view which is firstResponder
  open var ignoreFirstResponder: Bool = false

  public init(callback: @escaping () -> Void, ignoreViews views: [UIView]?) {
    self.callback = callback
    ignoreViews = views

    super.init(target: nil, action: nil)
    addTarget(self, action: #selector(TouchRecognizer.touchRecongized(_:)))
  }

  override init(target: Any?, action: Selector?) {
    callback = {}
    super.init(target: target, action: action)
  }

  @objc
  func touchRecongized(_: UIGestureRecognizer) {
    callback()
  }

  override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)

    guard let touch = touches.first else {
      return
    }

    if ignoreFirstResponder, touch.view?.isFirstResponder == true {
      return
    }

    let controls: [UIControl] = view?.findAll() ?? []
    for view in (ignoreViews ?? []) + controls {
      if view.bounds.contains(touch.location(in: view)) {
        state = .failed
        return
      }
    }

    state = .recognized
  }

  override open func canPrevent(_: UIGestureRecognizer) -> Bool {
    canPreventOtherGestureRecognizers
  }
}
