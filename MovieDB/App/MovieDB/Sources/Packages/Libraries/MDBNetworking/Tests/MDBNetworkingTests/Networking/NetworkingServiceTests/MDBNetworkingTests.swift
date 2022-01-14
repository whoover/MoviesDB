@testable import MDBNetworking
@testable import MDBNetworkingMocks
import XCTest

final class MDBNetworkingTests: XCTestCase {
  var httpService: HTTPServiceProtocolMock!
  var testObject: NetworkingService!
  var subscriptions = Set<AnyCancellable>()

  override func tearDown() {
    subscriptions = []
    testObject = nil
    socketService = nil
    httpService = nil

    super.tearDown()
  }

  override func setUp() {
    super.setUp()

    httpService = HTTPServiceProtocolMock()

    testObject = NetworkingService(
      httpService: httpService,
      socketService: socketService,
      httpUrlProvider: TestProvider(),
      socketUrlProvider: TestProvider(),
      ignoreSecurityCheck: true
    )
  }

  func testGetCountries() {
    let request = TestRequest()
    let exceptation = XCTestExpectation(description: #function)

    httpService.httpTaskWithHandler = { _, _ in
      let publisher = Just("{\"data\":[{\"name\":\"country\"}]}".data(using: .utf8)!)
      return publisher.setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    testObject
      .httpTaskWith(request: request, configurationType: .default)
      .sink(
        receiveCompletion: { completion in
          switch completion {
          case .finished:
            XCTAssertTrue(
              Thread.current.isMainThread,
              "Thread should be main"
            )
          case let .failure(error):
            XCTFail(
              "Should be complete without any error, actual error description \(error.localizedDescription)"
            )
          }

          exceptation.fulfill()
        },
        receiveValue: { container in
          XCTAssertTrue(
            container.data.first?.name == "country"
          )
        }
      )
      .store(in: &subscriptions)

    wait(for: [exceptation], timeout: 2)
  }

  func test401() {
    let request = TestRequest()
    let exceptation = XCTestExpectation(description: #function)

    httpService.httpTaskWithHandler = { _, _ in
      let publisher: AnyPublisher<Data, Error> = Fail(error: NetworkingError.http(.unathorized)).eraseToAnyPublisher()
      return publisher
    }

    testObject
      .httpTaskWith(request: request, configurationType: .default)
      .sink(
        receiveCompletion: { completion in
          XCTAssertTrue(
            Thread.current.isMainThread,
            "Thread should be main"
          )

          switch completion {
          case .finished:
            XCTFail(
              "Should be unathorized"
            )
          case let .failure(error):
            if let error = error as? NetworkingError {
              switch error {
              case .http(.unathorized):
                exceptation.fulfill()
              default:
                XCTFail("Should be unathorized, actual error description \(error.localizedDescription)")
              }
            } else {
              XCTFail("Should be unathorized, actual error description \(error.localizedDescription)")
            }
          }
        },
        receiveValue: { _ in
          XCTFail("Should be fail")
        }
      )
      .store(in: &subscriptions)

    wait(for: [exceptation], timeout: 2)
  }

  func testSwitchToLatest() {
    var expectations: [XCTestExpectation] = []
    let request = TestRequest()
    let tapsSubject = PassthroughSubject<Void, Error>()

    var requestsCount = 0

    httpService.httpTaskWithHandler = { _, _ in
      let publisher = Just("{\"data\":[{\"name\":\"country\"}]}".data(using: .utf8)!)
      return publisher.setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    tapsSubject
      .map {
        self.testObject.httpTaskWith(request: request, configurationType: .default)
      }
      .switchToLatest()
      .sink(
        receiveCompletion: { _ in },
        receiveValue: {
          XCTAssertTrue(
            $0.data.first?.name == "country"
          )

          XCTAssertTrue(
            Thread.current.isMainThread,
            "Thread should be main"
          )

          requestsCount += 1
          expectations.forEach { $0.fulfill() }
        }
      )
      .store(in: &subscriptions)

    for i in 0 ... 10 {
      expectations.append(expectation(description: #function + "\(i)"))
      tapsSubject.send()
    }

    wait(for: expectations, timeout: 5)

    XCTAssertTrue(
      requestsCount == 1,
      "Should be 1 request, actual count: \(requestsCount)"
    )
  }
}

struct TestProvider: BaseUrlProvider {
  var host: String {
    ""
  }

  var port: Int? {
    nil
  }

  var scheme: String {
    ""
  }

  var version: String {
    ""
  }
}
