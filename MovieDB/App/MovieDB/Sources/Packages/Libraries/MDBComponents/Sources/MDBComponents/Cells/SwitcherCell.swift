//
//  SwitcherCell.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBCommonUI
import UIKit

public final class SwitcherCell: UITableViewCell, ActionableCellProtocol {
  public var indexPath: IndexPath = .init()
  private let leftLabel = UILabel()
  private let switcher = UISwitch()
  private let button = UIButton()
  private let separator = UIView()

  private var subscriptions: Set<AnyCancellable> = []
  private var publisher: AnyPublisher<CellAction, Never>?

  /// Switch action publisher to track state changing
  private var actionSubject: PassthroughSubject<CellAction, Never>?
  public var actionPublisher: AnyPublisher<CellAction, Never>? {
    actionSubject?.eraseToAnyPublisher()
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func prepareForReuse() {
    subscriptions.forEach { $0.cancel() }
    subscriptions.removeAll()
    super.prepareForReuse()
  }

  private func setupSubviews() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    selectionStyle = .none

    leftLabel.add(to: contentView).do {
      $0.centerYToSuperview()
      $0.leftToSuperview(offset: 16)
      $0.font = .systemFont(ofSize: 16, weight: .regular)
    }

    switcher.add(to: contentView).do {
      $0.centerYToSuperview()
      $0.rightToSuperview(offset: -24)
    }

    button.add(to: contentView).do {
      $0.edges(to: switcher, excluding: [.top, .bottom])
      $0.topToSuperview()
      $0.bottomToSuperview()
      $0.addTarget(self, action: #selector(didChangeSwitch), for: .touchUpInside)
    }

    separator.add(to: self).do {
      $0.height(1.0)
      $0.bottomToSuperview()
      $0.leftToSuperview(offset: 16)
      $0.rightToSuperview(offset: -16)
    }
  }

  @objc
  private func didChangeSwitch() {
    actionSubject?.send(CellAction.switchAction(!switcher.isOn, indexPath: indexPath))
  }

  public func setup(actionSubject: PassthroughSubject<CellAction, Never>?) {
    self.actionSubject = actionSubject
  }
}

// MARK: - ConfigurableCellProtocol

extension SwitcherCell: ConfigurableCellProtocol {
  public func configure(_ cellModel: CellModelProtocol, _ indexPath: IndexPath) {
    guard let model = cellModel as? SwitchCellModelProtocol else {
      return
    }

    self.indexPath = indexPath
    leftLabel.text = model.title
    leftLabel.textColor = model.titleColor
    separator.backgroundColor = model.separatorColor
    switcher.onTintColor = model.onTint
    switcher.thumbTintColor = model.thumbTint
    model.isOnPublisher
      .sink(receiveValue: { [weak self] value in
        self?.switcher.isOn = value
      })
      .store(in: &subscriptions)
  }
}
