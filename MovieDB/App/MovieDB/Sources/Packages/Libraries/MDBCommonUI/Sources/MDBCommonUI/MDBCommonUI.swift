@_exported import Combine
@_exported import MDBCommon
@_exported import TinyConstraints
@_exported import UIKit

public var isIpad: Bool {
  UIDevice.current.userInterfaceIdiom == .pad
}
