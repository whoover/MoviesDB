//
//  Decimal+Extensions.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import Foundation

public extension Decimal {
  /// Convert value to Int64
  var int64Value: Int64 {
    (self as NSDecimalNumber).int64Value
  }

  /// Convert value to Double
  var doubleValue: Double {
    NSDecimalNumber(decimal: self).doubleValue
  }

  /// Create hex from Decimal and return hex string
  /// - Parameter evenLength: true if the string should be even length
  /// - Returns: hex string
  func hexString(evenLength _: Bool = true) -> String {
    let hex = representationOf(base: 16)

    let isEvenLength = hex.count % 2 == 0

    return isEvenLength ? hex : "0" + hex
  }

  /// Create represantation of Decimal in some base and return string
  /// - Parameter base: Base or radix represents  system of numeration
  /// - Returns: String representation in given base
  func representationOf(base: Decimal) -> String {
    var buffer: [Int] = []
    var number = self

    while number > 0 {
      buffer.append((number.truncatingRemainder(dividingBy: base) as NSDecimalNumber).intValue)
      number = number.integerDivisionBy(base)
    }

    return buffer
      .reversed()
      .map { String($0, radix: (base as NSDecimalNumber).intValue) }
      .joined()
  }

  /// Round value according to round mode
  /// - Parameter mode: Rounding mode
  /// - Returns: Return rounded value
  func rounded(mode: NSDecimalNumber.RoundingMode) -> Decimal {
    var this = self
    var result = Decimal()
    NSDecimalRound(&result, &this, 0, mode)

    return result
  }

  /// Integer division - division in which fractional part is discarded
  /// - Parameter operand: Quantity on which operation to be done
  /// - Returns: Devided integer
  func integerDivisionBy(_ operand: Decimal) -> Decimal {
    let result = (self / operand)
    return result.rounded(mode: result < 0 ? .up : .down)
  }

  /// Truncate reminder (fractional part)
  /// - Parameter operand: Quantity on which operation to be done
  /// - Returns: Trunacated value
  func truncatingRemainder(dividingBy operand: Decimal) -> Decimal {
    self - integerDivisionBy(operand) * operand
  }
}
