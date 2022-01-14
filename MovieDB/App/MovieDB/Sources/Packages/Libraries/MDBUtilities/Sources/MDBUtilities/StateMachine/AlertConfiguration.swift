//
//  AlertConfiguration.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

/// AlertConfiguration that represents separated layer from UIKit
public struct AlertConfiguration {
  public typealias AlertCompletion = () -> Void

  public var title: String?
  public var message: String
  public var actions: [AlertActionModel]
  public var completion: AlertCompletion?

  public init(
    title: String? = nil,
    message: String,
    actions: [AlertActionModel],
    completion: AlertCompletion? = nil
  ) {
    self.message = message
    self.actions = actions
    self.completion = completion
    self.title = title
  }

  public mutating func addActionModel(
    title: String?,
    style: AlertActionModel.Style,
    actionHandler: AlertActionHandler? = nil
  ) {
    let action = AlertActionModel(title: title, style: style, handler: actionHandler)
    actions.append(action)
  }
}

extension AlertConfiguration: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(title)
    hasher.combine(message)
  }

  public static func == (lhs: AlertConfiguration, rhs: AlertConfiguration) -> Bool {
    lhs.hashValue == rhs.hashValue
  }
}

public typealias AlertActionHandler = () -> Void

/// Alert action model
public struct AlertActionModel {
  public enum Style {
    case `default`
    case cancel
  }

  public let title: String?
  public let style: Style
  public var handler: AlertActionHandler?
  private var isEnabledSubject = CurrentValueSubject<Bool, Never>(true)
  public var isEnabledPublisher: AnyPublisher<Bool, Never> {
    isEnabledSubject.eraseToAnyPublisher()
  }

  public var isEnabled: Bool {
    get {
      isEnabledSubject.value
    }
    set {
      if isEnabledSubject.value != newValue {
        isEnabledSubject.value = newValue
      }
    }
  }

  public init(
    title: String?,
    style: Style,
    handler: AlertActionHandler? = nil,
    isEnabled: Bool = true
  ) {
    self.title = title
    self.style = style
    self.handler = handler
    self.isEnabled = isEnabled
  }

  public mutating func setEnabled(_ enabled: Bool) {
    isEnabled = enabled
  }
}

extension AlertActionModel: ExpressibleByStringLiteral {
  /// `AlertActionModel` simple init with `String` literal.
  ///
  /// `AlertActionModel.Style` is`default` style.
  /// `AlertActionHandler` is nil.
  /// `isEnabled` is true.
  public init(stringLiteral value: String) {
    self.init(title: value, style: .default)
  }
}
