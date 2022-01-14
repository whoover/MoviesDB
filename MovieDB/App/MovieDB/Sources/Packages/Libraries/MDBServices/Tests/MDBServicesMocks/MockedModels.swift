////
////  MockedModels.swift
////
////
//  Created by Artem Belenkov on 08.01.2022.
////
//
//// MARK: - ReceiveSmsOtpParameters
//
// @testable import MDBModels
//
// extension ReceiveSmsOtpParameters: MockModelReturnableProtocol {
//  public static func mock() -> ReceiveSmsOtpParameters {
//    ReceiveSmsOtpParameters(
//      phoneCountryId: 0,
//      phone: "phone"
//    )
//  }
// }
//
//// MARK: - SignInWithEmailRequestModel
//
// extension SignInWithEmailRequestModel: MockModelReturnableProtocol {
//  public static func mock() -> SignInWithEmailRequestModel {
//    SignInWithEmailRequestModel(
//      email: "email",
//      password: "password"
//    )
//  }
// }
//
//// MARK: - SignInWithPhoneRequestModel
//
// extension SignInWithPhoneRequestModel: MockModelReturnableProtocol {
//  public static func mock() -> SignInWithPhoneRequestModel {
//    SignInWithPhoneRequestModel(
//      phone: "phone",
//      phoneCountryId: 0,
//      password: "password"
//    )
//  }
// }
//
//// MARK: - SignUpRequestModel
//
// extension SignUpRequestModel: MockModelReturnableProtocol {
//  public static func mock() -> SignUpRequestModel {
//    SignUpRequestModel(
//      name: "name",
//      email: "email",
//      countryId: 0,
//      phone: "phone",
//      phoneCountryId: 0,
//      password: "password",
//      passwordConfirmation: "password",
//      agreed: true,
//      receiveUpdates: true
//    )
//  }
// }
//

// MARK: - CountryResponseModel

extension CountryResponseModel: MockModelReturnableProtocol {
  public static func mock() -> CountryResponseModel {
    CountryResponseModel(
      countryId: 0,
      name: "Ukraine",
      alpha2: "UA",
      countryCode: 380,
      flag: "http://storage/public/img/flags/ua.png",
      isForResidence: true
    )
  }
}

extension SignUpPhoneResponseModel: MockModelReturnableProtocol {
  public static func mock() -> SignUpPhoneResponseModel {
    SignUpPhoneResponseModel(
      session: "test-session",
      codeLength: 6,
      codeLifetime: 60
    )
  }
}

//
//// MARK: - ReceiveSmsOtpResponseModel
//
// extension ReceiveSmsOtpResponseModel: MockModelReturnableProtocol {
//  public static func mock() -> ReceiveSmsOtpResponseModel {
//    ReceiveSmsOtpResponseModel(
//      codeLength: 4,
//      codeLifetime: 120
//    )
//  }
// }
//
//// MARK: - TokenModel
//
// extension SignInWithEmailResponseModel: MockModelReturnableProtocol {
//  public static func mock() -> SignInWithEmailResponseModel {
//    SignInWithEmailResponseModel(
//      accessToken: "accessToken",
//      tokenType: "tokenType",
//      expiresIn: 7400
//    )
//  }
// }
//
// extension SignInWithPhoneResponseModel: MockModelReturnableProtocol {
//  public static func mock() -> SignInWithPhoneResponseModel {
//    SignInWithPhoneResponseModel(
//      accessToken: "accessToken",
//      tokenType: "tokenType",
//      expiresIn: 7400
//    )
//  }
// }
//
//// MARK: - UserIdentifiableModel
//
// extension SignUpResponseModel: MockModelReturnableProtocol {
//  public static func mock() -> SignUpResponseModel {
//    SignUpResponseModel(
//      userId: 0,
//      accessToken: "accessToken",
//      tokenType: "tokenType",
//      expiresIn: 7400
//    )
//  }
// }
//
//// MARK: - CurrentUserResponseModel
//
// extension CurrentUserResponseModel: MockModelReturnableProtocol {
//  public static func mock() -> CurrentUserResponseModel {
//    CurrentUserResponseModel(
//      userId: 0,
//      publicCustomerId: "publicCustomerId",
//      name: "name"
//    )
//  }
// }
//
//// MARK: - ReceiveEmailOTPRequestModel
//
// extension ReceiveEmailOTPRequestModel: MockModelReturnableProtocol {
//  public static func mock() -> ReceiveEmailOTPRequestModel {
//    ReceiveEmailOTPRequestModel(email: "email")
//  }
// }
//
//// MARK: - ResetPasswordRequestModel
//
// extension ResetPasswordRequestModel: MockModelReturnableProtocol {
//  public static func mock() -> ResetPasswordRequestModel {
//    ResetPasswordRequestModel(
//      token: "token",
//      password: "password",
//      passwordConfirmation: "password"
//    )
//  }
// }
//
//// MARK: - VerifyEmailOtpParameters
//
// extension VerifyEmailOtpParameters: MockModelReturnableProtocol {
//  public static func mock() -> VerifyEmailOtpParameters {
//    VerifyEmailOtpParameters(
//      code: "code",
//      email: "email"
//    )
//  }
// }
//
//// MARK: - VerifyPhoneOtpParameters
//
// extension VerifyPhoneOtpParameters: MockModelReturnableProtocol {
//  public static func mock() -> VerifyPhoneOtpParameters {
//    VerifyPhoneOtpParameters(
//      code: "code",
//      phoneCountryId: 0,
//      phone: "phone"
//    )
//  }
// }
//
//// MARK: - ResetTokenModel
//
// extension ResetTokenModel: MockModelReturnableProtocol {
//  public static func mock() -> ResetTokenModel {
//    ResetTokenModel(token: "token")
//  }
// }
//
//// MARK: - KYCStoreVerificationIdRequestModel
//
// extension KYCStoreVerificationIdRequestModel: MockModelReturnableProtocol {
//  public static func mock() -> KYCStoreVerificationIdRequestModel {
//    KYCStoreVerificationIdRequestModel(verificationId: "verificationId")
//  }
// }
//
//// MARK: - KYCFormIdModel
//
// extension KYCFormIdModel: MockModelReturnableProtocol {
//  public static func mock() -> KYCFormIdModel {
//    KYCFormIdModel(formId: "formId")
//  }
// }
//
//// MARK: - KYCVerificationModel
//
// extension KYCVerificationModel: MockModelReturnableProtocol {
//  public static func mock() -> KYCVerificationModel {
//    KYCVerificationModel(
//      verificationId: "verificationId",
//      verified: false,
//      status: .unused
//    )
//  }
// }
