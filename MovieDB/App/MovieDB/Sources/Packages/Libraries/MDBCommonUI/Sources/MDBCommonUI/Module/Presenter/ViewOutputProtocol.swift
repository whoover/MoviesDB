//
//  ViewOutputProtocol.swift
//  MDBCommonUI
//
//

import UIKit

public protocol ViewOutputProtocol: AnyObject {
  func viewDidLoad()

  func didGoBack()
  func didClose()
}
