//
//  DebugViewControllerProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public protocol DebugViewControllerProtocol: UIViewController {}

public extension DebugViewControllerProtocol {
  func setupDebugNextScreenButtonIfNedded(_ tapHandler: (() -> Void)?) {
    #if DEBUG
      DebugButton(tapHandler: tapHandler).add(to: view).do {
        $0.setTitle("GO NEXT", for: .normal)
        $0.centerXToSuperview()
        $0.bottomToSuperview(offset: -10)
      }
    #endif
  }
}

class DebugButton: UIButton {
  private var tapHandler: (() -> Void)?

  init(tapHandler: (() -> Void)?) {
    self.tapHandler = tapHandler
    super.init(frame: .zero)

    addTarget(self,
              action: #selector(actionHandler),
              for: .touchUpInside)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc
  private func actionHandler() {
    tapHandler?()
  }
}
