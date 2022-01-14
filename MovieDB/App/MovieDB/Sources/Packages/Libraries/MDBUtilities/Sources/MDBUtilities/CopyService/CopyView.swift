//
//  CopyView.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import UIKit

public final class CopyView: UIView {
  private let contentView = UIView()
  private let titleLabel = UILabel()

  private var topConstraint: NSLayoutConstraint?

  private var copiedText: String = "Copied"

  private var timer: Timer?

  private var keyWindow: UIWindow? {
    UIApplication.shared.windows.first { $0.isKeyWindow }
  }

  private var statusBarHeight: CGFloat {
    keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
  }

  private var contentViewHeight: CGFloat {
    44
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    backgroundColor = .clear

    contentView.add(to: self).do {
      $0.layer.cornerRadius = 8
      $0.layer.masksToBounds = true
      $0.backgroundColor = .green
      $0.height(contentViewHeight)

      topConstraint = $0.topToSuperview(offset: -contentViewHeight)
      $0.leadingToSuperview(offset: 16)
      $0.trailingToSuperview(offset: 16)
    }

    titleLabel.add(to: contentView).do {
      $0.edgesToSuperview(insets: .init(top: 0, left: 16, bottom: 0, right: 16))
      $0.numberOfLines = 2
      $0.textAlignment = .center
    }

    height(contentViewHeight * 2)
  }

  private func showAlert() {
    guard superview == nil else {
      return
    }

    keyWindow?.addSubview(self)

    topToSuperview()
    leadingToSuperview()
    trailingToSuperview()

    layoutIfNeeded()

    topConstraint?.constant = statusBarHeight
    UIView.animate(withDuration: 0.3, animations: {
      self.layoutIfNeeded()
    })

    timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] _ in
      self?.removeAlert()
    })
  }

  private func removeAlert() {
    timer?.invalidate()
    timer = nil

    topConstraint?.constant = -contentViewHeight
    removeFromSuperview()
  }

  public func showAlertWith(fieldName: String) {
    removeAlert()

    let fieldName = NSAttributedString(
      string: fieldName,
      attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
    )
    let space = NSAttributedString(string: " ")
    let copied = NSAttributedString(
      string: copiedText,
      attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]
    )

    let attributedText = NSMutableAttributedString()

    attributedText.append(fieldName)
    attributedText.append(space)
    attributedText.append(copied)

    titleLabel.attributedText = attributedText

    showAlert()
  }
}

public extension CopyView {
  func setup(theme: CopyViewColorsThemeProtocol) {
    contentView.backgroundColor = theme.background
    titleLabel.textColor = theme.text
  }
}

extension CopyView: LocalizableProtocol {
  public func localize(with l10n: L10n.Type) {
//    copiedText = l10n.Localizable.Copy.copied
  }
}
