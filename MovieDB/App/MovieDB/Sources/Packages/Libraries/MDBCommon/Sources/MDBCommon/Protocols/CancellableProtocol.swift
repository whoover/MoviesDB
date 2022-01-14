//
//  CancellableProtocol.swift
//  MDBCommon
//
//

/// Cancelable protocol
public protocol CancelableProtocol {
  var isCancelled: Bool { get }

  func cancel()
}

extension DispatchWorkItem: CancelableProtocol {}
