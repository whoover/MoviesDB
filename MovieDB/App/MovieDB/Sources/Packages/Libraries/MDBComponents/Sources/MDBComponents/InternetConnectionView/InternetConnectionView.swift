//
//  InternetConnectionView.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import MDBUtilities
import UIKit

public class InternetConnectionView: UIView {
  private let label = UILabel()

  public init() {
    var frame = UIScreen.main.bounds
    frame.size.height = 72
    super.init(frame: frame)
    setupSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupSubviews() {
    backgroundColor = .red
    translatesAutoresizingMaskIntoConstraints = false
    label.add(to: self).do {
      $0.edgesToSuperview(excluding: [.top, .bottom])
      $0.bottomToSuperview(offset: -10)
      $0.numberOfLines = 0
      $0.font = .systemFont(ofSize: 14)
      $0.textAlignment = .center
    }

    height(72)
  }

  public func setup(theme: NetworkingAlertProtocol) {
    backgroundColor = theme.background
    label.textColor = theme.text
  }

  public func setupText(_ text: String) {
    label.text = text
  }
}
