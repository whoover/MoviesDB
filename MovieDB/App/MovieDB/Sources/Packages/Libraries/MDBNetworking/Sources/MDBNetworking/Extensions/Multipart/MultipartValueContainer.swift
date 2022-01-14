//
//  MultipartValueContainer.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public enum MultipartValueKey: String {
  case file
}

public struct MultipartValueContainer {
  let valueKey: MultipartValueKey
  let fileName: String
  let mimeType: String
  let data: Data

  public init(
    valueKey: MultipartValueKey,
    fileName: String,
    mimeType: String,
    data: Data
  ) {
    self.valueKey = valueKey
    self.fileName = fileName
    self.mimeType = mimeType
    self.data = data
  }
}
