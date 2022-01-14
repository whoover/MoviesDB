import MDBCommonUI
import MDBUtilities
import UIKit

/// Enum with accessibility identifier for AlertRoutableProtocol
public enum AlertRoutableAccessibilityIdentifier: String, CaseIterable {
  case alertControllerAlertView = "alert-controller_alert_view"
  case alertControllerAlertWithTextFieldView = "alert-controller_alert-with-text-field_view"
}

/// AlertRoutableProtocol to show alerts from objects conformed to it
public protocol AlertRoutableProtocol: PresentableProtocol {
  typealias AlertTextFieldHandler = (UITextField) -> Void

  /// Shows alert with configuration
  func showAlert(config: AlertConfiguration)
  /// Shows alert with textfield
  func showAlertWithTextField(configuration: TextFieldAlertConfiguration)
}

// MARK: - Custom Alert

public extension AlertRoutableProtocol where Self: UIViewController {
  func showAlert(config: AlertConfiguration) {
    guard let source = toPresent() else {
      return
    }

    let alertController = UIAlertController(
      title: config.title,
      message: config.message,
      preferredStyle: .alert
    )

    config.actions.map { actionModel in
      let alertStyle: UIAlertAction.Style
      switch actionModel.style {
      case .default:
        alertStyle = .default
      case .cancel:
        alertStyle = .cancel
      }

      return UIAlertAction(
        title: actionModel.title,
        style: alertStyle,
        handler: { _ in
          actionModel.handler?()
          config.completion?()
        }
      )
    }.forEach {
      alertController.addAction($0)
    }

    alertController.view.accessibilityIdentifier
      = AlertRoutableAccessibilityIdentifier.alertControllerAlertView.rawValue
    source.present(alertController, animated: false)
  }

  func showAlertIfNotPresentedBefore(config: AlertConfiguration) {
    guard let source = lastPresentedController() else {
      return
    }

    if let viewAccessibilityIdentifier = source.view.accessibilityIdentifier,
       let alertCase = AlertRoutableAccessibilityIdentifier(rawValue: viewAccessibilityIdentifier),
       AlertRoutableAccessibilityIdentifier.allCases.contains(alertCase)
    {
      return
    }

    showAlert(config: config)
  }
}

// MARK: - TextField Alert

public extension AlertRoutableProtocol {
  func showAlertWithTextField(configuration: TextFieldAlertConfiguration) {
    guard let source = lastPresentedController() else {
      return
    }
    let alertController = UIAlertController(title: configuration.title,
                                            message: configuration.message,
                                            preferredStyle: .alert)
    alertController.view.accessibilityIdentifier
      = AlertRoutableAccessibilityIdentifier.alertControllerAlertWithTextFieldView.rawValue
    alertController.addTextField { textField in
      textField.placeholder = configuration.placeholder
    }

    let completeAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alertController] _ in
      if let textField = alertController?.textFields?.first {
        configuration.handler(textField)
      }
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
      configuration.cancelHandler?()
    })

    alertController.addAction(completeAction)
    alertController.addAction(cancelAction)

    source.present(alertController, animated: true, completion: nil)
  }
}
