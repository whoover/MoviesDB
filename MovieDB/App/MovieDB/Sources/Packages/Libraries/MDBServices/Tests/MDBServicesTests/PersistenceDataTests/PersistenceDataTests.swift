// @testable import MDBModels
// @testable import MDBModelsMocks
// @testable import AAServicesMocks
// import XCTest
//
// final class PersistenceDataTests: XCTestCase {
//  var realmURL: URL {
//    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//      .first!
//      .appendingPathComponent("tests", isDirectory: true)
//
//    if !FileManager.default.fileExists(atPath: url.path) {
//      try! FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
//    }
//    return url
//      .appendingPathComponent("realmTests", isDirectory: true)
//  }
//
//  var key: Data {
//    var keyData = Data()
//    let dataArray: StrideTo<UInt8> = stride(from: UInt8(0), to: UInt8(64), by: 1)
//    dataArray.forEach {
//      keyData.append($0)
//    }
//
//    return keyData
//  }
//
//  private let service: PersistenceDataInteractorProtocol = DatabaseService()
//  var subscriptions = Set<AnyCancellable>()
//
//  override func setUp() {
//    super.setUp()
//
//    (service as! DatabaseService).setup(version: 1, encryptionKey: key, realmURL: realmURL)
//      .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
//      .store(in: &subscriptions)
//
//    let model = CountryResponseModel.mock().createRuntimeModel()
//    _ = (service as! DatabaseService).addOrUpdate(object: model)
//  }
//
//  override func tearDown() {
//    subscriptions = []
//    _ = (service as! DatabaseService).removeAll()
//
//    super.tearDown()
//  }
//
//  func testCountry() {
//    (service as! DatabaseService)
//      .getAll(of: CountryRuntimeModel.self)
//      .sink(
//        receiveCompletion: { _ in },
//        receiveValue: { models in
//          print(models)
//        }
//      )
//      .store(in: &subscriptions)
//  }
// }
