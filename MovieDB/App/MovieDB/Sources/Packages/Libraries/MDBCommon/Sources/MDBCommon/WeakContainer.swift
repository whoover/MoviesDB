public class WeakContainer<T> {
  private weak var _value: AnyObject?
  public var value: T? {
    get { _value as? T }
    set { _value = newValue as AnyObject }
  }

  public init(value: T) {
    _value = value as AnyObject
  }
}

extension Array where Element: WeakContainer<Any> {
  mutating func reap() {
    self = filter { $0.value != nil }
  }
}
