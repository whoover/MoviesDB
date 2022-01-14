//
//  TimeInterval+Additions.swift
//  MDBCommon
//
//

/// Custom TimeInterval methods
public extension TimeInterval {
  /// Returns turple with hours, minutes, seconds in current timeinterval.
  var secondsToHoursMinutesSeconds: (Int, Int, Int) {
    let intValue = Int(self)
    return (intValue / 3600, (intValue % 3600) / 60, (intValue % 3600) % 60)
  }

  /**
        Custom string representation of time interval.
        - Parameters:
           - seconds : seconds.

        ### Usage Example: ###
        ````
        let result = TimeInterval.timeFormattedToMinutes(1800)
        ````

        ### Expected result: ###
        ````
        [1: 42, 2: 2, 3: 3]
        ````
   */
  static func timeFormattedToHMS(_ seconds: TimeInterval) -> String {
    let time = seconds.secondsToHoursMinutesSeconds
    return "\(timeText(from: time.0)):\(timeText(from: time.1)):\(timeText(from: time.2))"
  }

  static func timeFormattedToMS(_ seconds: TimeInterval) -> String {
    let time = seconds.secondsToHoursMinutesSeconds
    return "\(timeText(from: time.1)):\(timeText(from: time.2))"
  }

  private static func timeText(from number: Int) -> String {
    number < 10 ? "0\(number)" : "\(number)"
  }
}
