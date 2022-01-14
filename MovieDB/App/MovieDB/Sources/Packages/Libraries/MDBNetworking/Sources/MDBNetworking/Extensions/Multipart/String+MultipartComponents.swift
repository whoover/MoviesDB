//
//  String+MultipartComponents.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

extension String {
  var mediaType: String {
    components(separatedBy: ".").last ?? ""
  }

  static var boundaryString: String {
    uuidString.lowercased()
  }

  static var uuidString: String {
    UUID().uuidString
  }
}
