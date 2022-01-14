import UIKit

public protocol PresenterProtocol {
  associatedtype View
  associatedtype Output

  var view: View? { get set }
  var moduleOutput: Output? { get set }
}
