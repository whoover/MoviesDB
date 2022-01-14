//
//  BaseViewControllerProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public protocol BaseViewControllerProtocol: UIViewController {
  var gradientView: GradientView { get }
  var bottomImageView: UIImageView { get }
  var bottomImageViewHeightConstraint: NSLayoutConstraint? { get set }
}

public extension BaseViewControllerProtocol {
  func setupBottomImageViewAndGradient() {
    gradientView.add(to: view).do {
      $0.edgesToSuperview(excluding: [.top, .bottom])
      $0.topToSuperview(offset: 0)
      $0.bottomToSuperview(offset: 0)
    }

    bottomImageView.add(to: view).do {
      $0.edgesToSuperview(excluding: .top)
      bottomImageViewHeightConstraint = $0.height(0)

      $0.contentMode = .scaleAspectFit
    }
  }

  func setupBottomImage(_ image: UIImage) {
    bottomImageView.image = image
    bottomImageViewHeightConstraint?.constant = view.frame.width / image.size.width * image.size.height
  }
}
