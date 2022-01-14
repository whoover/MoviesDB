//
//  ActionValueProtocol.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public protocol ActionValueProtocol {}

extension String: ActionValueProtocol {}
extension Dictionary: ActionValueProtocol {}
