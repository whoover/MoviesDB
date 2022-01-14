//
//  SwitchTableViewCell.swift
//  MDBCommonUI
//
//

import Combine
import UIKit

/// Represents cell with `UISwitch`
public class SwitchTableViewCell: UITableViewCell, ConfigurableCellProtocol, ActionableCellProtocol {
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var switchButton: UISwitch!

  public private(set) var indexPath: IndexPath = .init(index: 0)
  private var subscriptions: Set<AnyCancellable> = []

  private var actionSubject: PassthroughSubject<CellAction, Never>?
  /// Switch action publisher to track state changing
  public var actionPublisher: AnyPublisher<CellAction, Never>? {
    actionSubject?.eraseToAnyPublisher()
  }

  override public func awakeFromNib() {
    super.awakeFromNib()
    showsReorderControl = false
    selectionStyle = .none
  }

  override public func prepareForReuse() {
    subscriptions.forEach { $0.cancel() }
    subscriptions.removeAll()
    super.prepareForReuse()
  }

  public func configure(_ cellModel: CellModelProtocol,
                        _ indexPath: IndexPath)
  {
    guard let model = cellModel as? SwitchCellModel else {
      return
    }

    self.indexPath = indexPath
    titleLabel.text = model.title
    backgroundColor = model.backgroundColor

    model.$switchState
      .sink(receiveValue: { [weak self] value in
        self?.switchButton.isOn = value
      })
      .store(in: &subscriptions)
  }

  public func setup(actionSubject: PassthroughSubject<CellAction, Never>?) {
    self.actionSubject = actionSubject
  }

  @objc
  private func didChangeSwitch() {
    actionSubject?.send(CellAction.switchAction(switchButton.isOn, indexPath: indexPath))
  }
}
