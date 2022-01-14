@testable import MDBServicesMocks
import XCTest

final class DatabaseServiceTests: XCTestCase {
  private let databaseService = DatabaseService()
  var subscriptions = Set<AnyCancellable>()

  static var realmURL: URL {
    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      .first!
      .appendingPathComponent("tests", isDirectory: true)

    if !FileManager.default.fileExists(atPath: url.path) {
      try! FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
    }
    return url
      .appendingPathComponent("realmTests", isDirectory: true)
  }

  var realmURL: URL {
    DatabaseServiceTests.realmURL
  }

  var key: Data {
    var keyData = Data()
    let dataArray: StrideTo<UInt8> = stride(from: UInt8(0), to: UInt8(64), by: 1)
    dataArray.forEach {
      keyData.append($0)
    }

    return keyData
  }

  override func setUp() {
    super.setUp()

    databaseService.setup(version: 1, encryptionKey: key, realmURL: realmURL)
      .sink(
        receiveCompletion: { print($0) },
        receiveValue: {
          print($0)
        }
      )
      .store(in: &subscriptions)
  }

  override class func setUp() {
    super.setUp()

    do {
      try FileManager.default.removeItem(at: realmURL)
    } catch (_) {}
  }

  override func tearDown() {
    _ = databaseService.removeAll(of: TestPerson.self)
    subscriptions = []

    super.tearDown()
  }

  // MARK: - Positive

  func testAddOrUpdate() {
    let total = persons.count + 2
    let firstTestPerson = persons[0]
    let lastTestPerson = persons[persons.count - 1]
    let expectation = expectation(description: #function)

    persons
      .publisher
      .collect()
      .addOrUpdateObjects(in: databaseService)
      .map { _ in firstTestPerson }
      .addOrUpdateObject(in: databaseService)
      .map { _ in lastTestPerson }
      .addOrUpdateObject(in: databaseService)
      .getAll(in: databaseService)
      .sink(
        receiveCompletion: {
          switch $0 {
          case let .failure(error):
            XCTAssert(
              error.localizedDescription.isEmpty,
              error.localizedDescription
            )
          default:
            break
          }

          expectation.fulfill()
        },
        receiveValue: { (storedTestPersons: [TestPerson]) in
          XCTAssertTrue(
            storedTestPersons.count == total,
            "Stored count: \(storedTestPersons.count) should be \(self.persons.count)"
          )
        }
      )
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 2)
  }

  func testGetAddOrUpdateUniqual() {
    let key = UUID().uuidString
    let newFirstName = "NEW_FNAME"
    let person = TestPerson(firstName: "FNAME", lastName: "LNAME", primaryKey: key)

    let expectation = expectation(description: #function)

    Just(person)
      .subscribe(on: DispatchQueue(label: "Test"))
      .addOrUpdateObject(in: databaseService)
      .map { _ in key }
      .get(in: databaseService)
      .map { (stored: TestPerson) -> TestPerson in
        stored.firstName = newFirstName

        XCTAssertTrue(
          !Thread.current.isMainThread,
          "Should be background thread"
        )

        return stored
      }
      .addOrUpdateObject(in: databaseService)
      .map { _ in key }
      .get(in: databaseService)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: {
          switch $0 {
          case let .failure(error):
            expectation.fulfill()
            XCTAssert(
              false,
              error.localizedDescription
            )
          default:
            break
          }
        },
        receiveValue: { (updated: TestPerson) in
          expectation.fulfill()

          XCTAssertTrue(
            Thread.current.isMainThread,
            "Should be main thread"
          )

          XCTAssertTrue(
            updated.firstName == newFirstName,
            "New firstName is: \(updated.firstName), not equal \(newFirstName)"
          )
        }
      )
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 2)
  }

  func testRemoveAll() {
    let expectation = expectation(description: #function)

    persons
      .publisher
      .collect()
      .addOrUpdateObjects(in: databaseService)
      .map { _ in TestPerson.self }
      .removeAll(in: databaseService)
      .getAll(in: databaseService)
      .sink(
        receiveCompletion: {
          switch $0 {
          case let .failure(error):
            XCTAssert(
              false,
              error.localizedDescription
            )
          default:
            break
          }

          expectation.fulfill()
        },
        receiveValue: { (persons: [TestPerson]) in
          XCTAssertTrue(
            persons.isEmpty,
            "Oll `TestPerson` should be deleted"
          )
        }
      )
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 2)
  }

  // MARK: - Negative

  func testObjectDoesntExists() {
    let key = UUID().uuidString
    let person = TestPerson(firstName: "FNAME", lastName: "LNAME", primaryKey: key)
    let expectation = expectation(description: #function)

    Just(person)
      .addOrUpdateObject(in: databaseService)
      .map { _ in person }
      .removeObject(in: databaseService)
      .map { _ in key }
      .get(in: databaseService)
      .sink(
        receiveCompletion: {
          switch $0 {
          case let .failure(error):
            XCTAssert(
              error == DatabaseError.objectDoesntExists,
              error.localizedDescription
            )
          default:
            XCTAssert(false)
          }

          expectation.fulfill()
        },
        receiveValue: { (stored: TestPerson) in
          XCTAssert(
            false,
            "TestPerson \(stored) should be deleted"
          )
        }
      )
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 2)
  }

  func testRealmDoesntExists() {
    let person = persons[0]
    let emptyDbService = DatabaseService()
    let expectation = expectation(description: #function)

    emptyDbService
      .addOrUpdate(object: person)
      .sink(receiveCompletion: {
        switch $0 {
        case let .failure(error):
          XCTAssert(
            error == DatabaseError.databaseDoesntExists,
            error.localizedDescription
          )
        default:
          XCTAssert(false)
        }

        expectation.fulfill()
      }, receiveValue: { _ in })
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 2)
  }

  func testObjectsKeyDoesntExists() {
    let emptyPrimaryKeyModel = EmptyPrimaryKeyModel()
    let expectation = expectation(description: #function)

    Just(emptyPrimaryKeyModel)
      .removeObject(in: databaseService)
      .sink(
        receiveCompletion: {
          switch $0 {
          case let .failure(error):
            XCTAssert(
              error == DatabaseError.objectsKeyDoesntExists,
              error.localizedDescription
            )
          default:
            XCTAssert(false)
          }

          expectation.fulfill()
        },
        receiveValue: { _ in }
      )
      .store(in: &subscriptions)

    wait(for: [expectation], timeout: 2)
  }
}

// MARK: - For test purposes

private extension DatabaseServiceTests {
  var persons: [TestPerson] {
    [TestPerson(firstName: "FirstName 1", lastName: "LastName 1"),
     TestPerson(firstName: "FirstName 2", lastName: "LastName 2"),
     TestPerson(firstName: "FirstName 3", lastName: "LastName 3"),
     TestPerson(firstName: "FirstName 1", lastName: "LastName 1"),
     TestPerson(firstName: "FirstName 2", lastName: "LastName 3"),
     TestPerson(firstName: "FirstName 3", lastName: "LastName 1"),
     TestPerson(firstName: "FirstName 3", lastName: "LastName 3")]
  }
}
