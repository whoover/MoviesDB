//
//  DateFormatterCache.swift
//  MDBCommon
//
//

/// DateFormatter extensions
public extension DateFormatter {
  private static var cache: [String: DateFormatter] = [:]

  /**
         This function return date formatter from cache or create new one if not exists with given format.

         ### Usage Example: ###
         ````
         DateFormatter.formatter(withFormat: "HH:mm:ss")
         ````
   */
  @objc
  static func formatter(withFormat format: String) -> DateFormatter {
    if let dateFormatter = DateFormatter.cache[format] {
      return dateFormatter
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    DateFormatter.cache[format] = dateFormatter
    return dateFormatter
  }
}
