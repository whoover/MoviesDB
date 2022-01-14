//
//  ConnectionConfigurationProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public protocol ConnectionConfigurationProtocol {
  var workQueue: DispatchQueue { get }
  var resultQueue: DispatchQueue { get }
}
