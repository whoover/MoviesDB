//
//  PublicKeyDefaultValidator.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

import CryptoKit
import MDBConstants

public final class PublicKeyDefaultValidator: PublicKeyValidatorProtocol {
  private let hashes: [String]

  /// ASN1 header for our public key to re-create the subject public key info
  private let rsa2048Asn1Header: [UInt8] = []

  public init(hashes: [String]) {
    self.hashes = hashes
  }

  public func validate(serverTrust: SecTrust, domain: String?) -> Bool {
    if let domain = domain, !domain.isEmpty {
      let policies = NSMutableArray()
      policies.add(SecPolicyCreateSSL(true, domain as CFString))
      SecTrustSetPolicies(serverTrust, policies)
    }

    guard SecTrustEvaluateWithError(serverTrust, nil) else {
      return false
    }

    for i in 0 ..< SecTrustGetCertificateCount(serverTrust) {
      guard
        let certificate = SecTrustGetCertificateAtIndex(serverTrust, i),
        let publicKey = SecCertificateCopyKey(certificate),
        let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, nil)
      else {
        continue
      }

      let keyHash = hashFrom(data: (publicKeyData as NSData) as Data)
      if hashes.contains(keyHash) {
        return true
      }
    }

    return false
  }

  private func hashFrom(data: Data) -> String {
    var keyWithHeader = Data(rsa2048Asn1Header)
    keyWithHeader.append(data)
    return Data(SHA256.hash(data: keyWithHeader)).base64EncodedString()
  }
}
