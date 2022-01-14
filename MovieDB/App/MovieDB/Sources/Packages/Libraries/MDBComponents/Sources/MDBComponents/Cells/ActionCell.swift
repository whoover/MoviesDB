//
//  ActionCell.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBCommonUI
import UIKit

public final class ActionCell: UITableViewCell {
  public var indexPath: IndexPath = .init()
  private let leftLabel = UILabel()
  private let arrowImageView = UIImageView()
  private let actionLabel = UILabel()
  private let separator = UIView()
  private var actionLabelRightConstraint: NSLayoutConstraint?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupSubviews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func setupSubviews() {
    backgroundColor = .clear

    leftLabel.add(to: contentView).do {
      $0.centerYToSuperview()
      $0.leftToSuperview(offset: 16)
      $0.font = .systemFont(ofSize: 16, weight: .regular)
    }

    arrowImageView.add(to: contentView).do {
      $0.centerYToSuperview()
      $0.rightToSuperview(offset: -16)
    }

    actionLabel.add(to: contentView).do {
      $0.centerYToSuperview()
      actionLabelRightConstraint = $0.rightToLeft(of: arrowImageView, offset: -8)
    }

    separator.add(to: self).do {
      $0.height(1.0)
      $0.bottomToSuperview()
      $0.leftToSuperview(offset: 16)
      $0.rightToSuperview(offset: -16)
    }
  }
}

extension ActionCell: ConfigurableCellProtocol {
  public func configure(_ cellModel: CellModelProtocol,
                        _ indexPath: IndexPath)
  {
    guard let model = cellModel as? ActionCellModelProtocol else {
      return
    }

    self.indexPath = indexPath

    leftLabel.text = model.title
    leftLabel.textColor = model.titleColor
    separator.backgroundColor = model.separatorColor
    arrowImageView.image = model.arrowImage
    arrowImageView.tintColor = model.arrowColor
    if arrowImageView.isHidden != model.isArrowHidden {
      arrowImageView.isHidden = model.isArrowHidden
      actionLabelRightConstraint?.isActive = false
      if arrowImageView.isHidden {
        actionLabelRightConstraint = actionLabel.trailingToSuperview(offset: 24)
      } else {
        actionLabelRightConstraint = actionLabel.rightToLeft(of: arrowImageView, offset: -16)
      }
    }

    actionLabel.text = model.actionTitle
    actionLabel.textColor = model.actionColor
    selectionStyle = model.selectionStyle
  }
}
