//
//  CopyService.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Combine
import UIKit

public protocol CopyServiceProtocol {
  func copyToClipboard(fieldName: String, value: String)
}

public final class CopyService: CopyServiceProtocol {
  private let copyView = CopyView()

  private let localizer: LocalizerProtocol
  private let themesManager: ThemeManagerProtocol

  private var subscriptions: Set<AnyCancellable> = []

  public init(themesManager: ThemeManagerProtocol, localizer: LocalizerProtocol) {
    self.themesManager = themesManager
    self.localizer = localizer

    subscribeOnThemePublisher()
    localizeView()
  }

  private func subscribeOnThemePublisher() {
    themesManager.themePublisher
      .sink { [weak self] theme in
        let colors = theme.colors.components.copyView

        self?.copyView.setup(theme: colors)
      }
      .store(in: &subscriptions)
  }

  private func localizeView() {
    copyView.localize(with: localizer.l10n)
  }

  public func copyToClipboard(fieldName: String, value: String) {
    copyView.showAlertWith(fieldName: fieldName)

    let generator = UIImpactFeedbackGenerator(style: .soft)
    generator.impactOccurred()

    UIPasteboard.general.string = value
  }
}
