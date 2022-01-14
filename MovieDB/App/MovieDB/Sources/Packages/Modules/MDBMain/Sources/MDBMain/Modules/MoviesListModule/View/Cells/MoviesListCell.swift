//
//  MoviesListCell.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import MDBCommonUI
import MDBComponents

final class MoviesListCell: UITableViewCell {
  private let movieImageView = ImageViewWithLoadingIndicator()
  private let movieNameLabel = UILabel()
  private let movieDescriptionLabel = UILabel()
  var indexPath: IndexPath = .init()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSubviews()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    movieImageView.setup(image: nil)
    movieImageView.start()

    super.prepareForReuse()
  }

  private func setupSubviews() {
    movieImageView.add(to: contentView).do {
      $0.topToSuperview(offset: 4)
      $0.bottomToSuperview(offset: -4)
      $0.leadingToSuperview(offset: 4)
      $0.aspectRatio(0.67)
    }

    movieNameLabel.add(to: contentView).do {
      $0.leadingToTrailing(of: movieImageView, offset: 8)
      $0.trailingToSuperview(offset: 24)
      $0.topToSuperview(offset: 4)
      $0.numberOfLines = 0
      $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }

    movieDescriptionLabel.add(to: contentView).do {
      $0.leading(to: movieNameLabel)
      $0.trailing(to: movieNameLabel)
      $0.topToBottom(of: movieNameLabel, offset: 8)
      $0.font = .systemFont(ofSize: 12)
      $0.numberOfLines = 3
    }
  }
}

extension MoviesListCell: ConfigurableCellProtocol {
  func configure(_ cellModel: CellModelProtocol, _ indexPath: IndexPath) {
    guard let cellModel = cellModel as? MoviesListCellModel else {
      return
    }
    self.indexPath = indexPath
    movieNameLabel.text = cellModel.model.title
    movieDescriptionLabel.text = cellModel.model.overview
    movieImageView.setup(image: cellModel.image)
    if cellModel.image != nil {
      movieImageView.stop()
    }
  }
}
