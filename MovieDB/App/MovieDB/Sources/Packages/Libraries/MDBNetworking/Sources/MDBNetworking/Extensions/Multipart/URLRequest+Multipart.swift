//
//  URLRequest+Multipart.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

public typealias MultipartParameters = [String: Any]

extension URLRequest {
  mutating func multipartRequestWith(
    values: [MultipartValueContainer],
    parameters: MultipartParameters = [:]
  ) {
    let boundary = String.boundaryString
    setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    let body = generateBodyWith(parameters: parameters, values: values, boundary: boundary)
    httpBody = body
  }

  private func generateBodyWith(
    parameters: MultipartParameters,
    values: [MultipartValueContainer],
    boundary: String
  ) -> Data {
    let lineBreak = "\r\n"
    var body = Data()

    for (key, value) in parameters {
      if let arrayValue = value as? [Any] {
        body.append(generateArrayBody(array: arrayValue, key: key, boundary: boundary))
      } else {
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
        body.append("\(value)\(lineBreak)")
      }
    }

    for value in values {
      body.append("--\(boundary + lineBreak)")
      let bodyData = "Content-Disposition: form-data; " +
        "name=\"\(value.valueKey.rawValue)\"; filename=\"\(value.fileName)\"\(lineBreak)"
      body.append(bodyData)
      body.append("Content-Type: \(value.mimeType + lineBreak + lineBreak)")
      body.append(value.data)
      body.append(lineBreak)
    }

    body.append("--\(boundary)--\(lineBreak)")

    return body
  }

  private func generateArrayBody(array: [Any], key: String, boundary: String) -> String {
    var bodyString = ""
    let lineBreak = "\r\n"
    for value in array {
      bodyString.append("--\(boundary + lineBreak)")
      bodyString.append("Content-Disposition: form-data; name=\"\(key)[]\"\(lineBreak + lineBreak)")
      bodyString.append("\(value)\(lineBreak)")
    }
    return bodyString
  }
}
