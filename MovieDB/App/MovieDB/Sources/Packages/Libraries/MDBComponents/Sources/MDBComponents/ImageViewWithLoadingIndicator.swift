//
//  ImageViewWithLoadingIndicator.swift
//
//
//  Created by Artem Belenkov on 08.01.2022
//

import UIKit

/// Represents image with activity indicator
public class ImageViewWithLoadingIndicator: UIView {
  public let loadingIndicator = UIActivityIndicatorView()
  public let imageView = UIImageView()

  public init() {
    super.init(frame: .zero)
    setupSubviews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupSubviews()
  }

  private func setupSubviews() {
    imageView.add(to: self).do {
      $0.edgesToSuperview()
    }

    loadingIndicator.add(to: imageView).do {
      $0.centerInSuperview()
      $0.hidesWhenStopped = true
    }
  }

  /// Setup loading indicator color
  public func setup(indicatorColor: UIColor) {
    loadingIndicator.color = indicatorColor
  }

  /// Setup image to imageView
  public func setup(image: UIImage?) {
    imageView.image = image
  }

  /// Start loading indicator
  public func start() {
    loadingIndicator.startAnimating()
  }

  /// Stop loading indicator
  public func stop() {
    loadingIndicator.stopAnimating()
  }
}
