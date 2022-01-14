//
//  DateFormatter+HourTimeFormat.swift
//  MDBCommon
//
//

/// Custom DateFormatter methods
public extension DateFormatter {
  class DateFormatterLocator: DateFormatterLocatorProtocol {
    public init() {}
  }

  /**
         This function indicates if user uses 24 hours time format.

         ### Usage Example: ###
         ````
         DateFormatter.isUses24HourTime()
         ````
   */
  static func isUses24HourTime(_ dateFormatterLocator: DateFormatterLocatorProtocol = DateFormatterLocator()) -> Bool {
    let formatter = dateFormatterLocator.dateFormatter()
    formatter.locale = .current

    let dateString = formatter.string(from: Date())
    let amRange = dateString.range(of: formatter.amSymbol)
    let pmRange = dateString.range(of: formatter.pmSymbol)

    return amRange == nil && pmRange == nil
  }
}
