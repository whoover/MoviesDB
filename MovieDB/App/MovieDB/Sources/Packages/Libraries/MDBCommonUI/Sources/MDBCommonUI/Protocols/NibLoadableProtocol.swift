//
//  NibLoadableProtocol.swift
//
//
//

public protocol NibLoadableProtocol: AnyObject {
  static var nib: UINib { get }
  static var nibName: String { get }
  static var bundle: Bundle { get }

  static func loadFromNib() -> Self?
}

public extension NibLoadableProtocol {
  static var nibName: String {
    String(describing: self)
  }

  static var nib: UINib {
    UINib(nibName: nibName, bundle: bundle)
  }

  static var bundle: Bundle {
    #if SWIFT_PACKAGE
      return Bundle.module
    #else
      Bundle(for: Self.self)
    #endif
  }
}

public extension NibLoadableProtocol where Self: UIView {
  static func loadFromNib() -> Self? {
    nib.instantiate(withOwner: nil, options: nil).first as? Self
  }

  func loadNib(bundle: Bundle) {
    bundle.loadNibNamed(Self.nibName, owner: self, options: nil)
  }
}

public extension NibLoadableProtocol where Self: UIViewController {
  @discardableResult
  static func loadFromNib() -> Self? {
    self.init(nibName: nibName, bundle: bundle)
  }
}

public protocol UniqNibLoadableProtocol: AnyObject {
  static var uniqNibName: String { get }
  static var uniqNib: UINib { get }
}

extension UIView: NibLoadableProtocol {}
extension UIViewController: NibLoadableProtocol {}
