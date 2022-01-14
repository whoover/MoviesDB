//
//  LabelCell.swift
//  MDBCommonUI
//
//

/// Represents cell with label
open class LabelCell: UITableViewCell, ConfigurableCellProtocol {
  private enum SizesAndOffsets {
    static let leftOffset: CGFloat = 16.0
  }

  public let titleLabel = UILabel()

  public private(set) var indexPath: IndexPath = .init(index: 0)

  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupLabel()
  }

  @available(*, unavailable)
  public required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func configure(_ cellModel: CellModelProtocol, _ indexPath: IndexPath) {
    guard let model = cellModel as? LabelCellModel else {
      return
    }

    self.indexPath = indexPath
    titleLabel.text = model.title
    titleLabel.textColor = model.textColor
    backgroundColor = model.backgroundColor
  }

  private func setupLabel() {
    contentView.addSubview(titleLabel)
    titleLabel.leftToSuperview(offset: SizesAndOffsets.leftOffset)
    titleLabel.rightToSuperview(relation: .equalOrGreater)
    titleLabel.centerYToSuperview()
  }
}

extension LabelCell: AccessabilityConfigurableProtocol {
  public func configurateAccessability() {
    titleLabel.accessibilityIdentifier = "label-cell_title_lable"
  }
}
