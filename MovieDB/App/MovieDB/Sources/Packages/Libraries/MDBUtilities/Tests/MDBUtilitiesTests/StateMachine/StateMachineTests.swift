//
//  StateMachineTests.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

@testable import MDBUtilities
@testable import MDBUtilitiesMocks
import XCTest

final class StateMachineTests: XCTestCase {
  var onLoadingConfigurator: OnLoadingStateConfigurator!
  var alertConfiguration: AlertConfiguration!

  override func setUp() {
    super.setUp()

    onLoadingConfigurator = OnLoadingStateConfigurator(loadingText: "Loading")
    alertConfiguration = AlertConfiguration(
      message: "Alert",
      theme: AlertThemeProtocolMock(),
      actions: []
    )
  }

  override func tearDown() {
    onLoadingConfigurator = nil
    alertConfiguration = nil

    super.tearDown()
  }

  func testNoCustomEventAndState() {
    typealias StateType = StateMachineStateType<StateMachineNoCustomState>
    typealias Machine = StateMachine<StateMachineNoCustomState, StateMachineNoCustomEvent>
    var subscriber: AnyCancellable?
    let defaultState = StateType.default(completion: nil)

    let machine = Machine(state: defaultState)

    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(defaultState, state)
        }
      )
    subscriber?.cancel()

    let onLoading = StateType.onLoading(onLoadingConfigurator)
    machine.changeStateIfNeeded(to: onLoading)
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(onLoading, state)
        }
      )
    subscriber?.cancel()
  }

  func testOnErrorMessage() {
    typealias StateType = StateMachineStateType<StateMachineNoCustomState>
    typealias Machine = StateMachine<StateMachineNoCustomState, StateMachineNoCustomEvent>
    var subscriber: AnyCancellable?
    let errorMessage = UUID().uuidString
    alertConfiguration.message = errorMessage
    let onError = StateType.onError([.alert(configuration: alertConfiguration)])

    let machine = Machine(state: onError)
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { [unowned self] state in
          guard
            case let .onError(cases) = state,
            case .alert(self.alertConfiguration) = cases.first
          else {
            return XCTFail("Invalid state \(state)")
          }

          XCTAssertEqual(self.alertConfiguration.message, errorMessage)
        }
      )
    subscriber?.cancel()
  }

  func testCustomStates() {
    typealias StateType = StateMachineStateType<CustomStates>
    typealias Machine = StateMachine<CustomStates, StateMachineNoCustomEvent>
    var subscriber: AnyCancellable?
    let customState = StateType.custom(.one)

    let machine = Machine(state: customState)
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(state, customState)
        }
      )
    subscriber?.cancel()

    let newState = StateType.custom(.two)
    machine.changeStateIfNeeded(to: newState)

    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(state, newState)
        }
      )
    subscriber?.cancel()
  }

  func testStatesWithCustomEvents() {
    typealias StateType = StateMachineStateType<StateMachineNoCustomState>
    typealias Machine = StateMachine<StateMachineNoCustomState, CustomEvents>
    var subscriber: AnyCancellable?
    let defaultState = StateType.default(completion: nil)

    let machine = Machine(state: defaultState)

    machine.addRouteMapping { [unowned self] state, event in
      switch (state, event) {
      case (.default(completion: nil), .custom(.oneButtonTapped)):
        return .onLoading(self.onLoadingConfigurator)
      case (.onLoading, .custom(.twoButtonTapped)):
        return .onError([.viewUpdate])
      case (.onError, .custom(.clearAllButtonTapped)):
        return .default(completion: nil)
      default:
        return nil
      }
    }

    // First iteration - Event "oneButtonTapped" -> state should be "onLoading"
    machine.tryChangeToNextState(for: .custom(.oneButtonTapped))
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { [unowned self] state in
          XCTAssertEqual(state, StateType.onLoading(self.onLoadingConfigurator))
        }
      )
    subscriber?.cancel()

    // Second iteration - Event "twoButtonTapped" -> state should be "onError([.viewUpdate])"
    machine.tryChangeToNextState(for: .custom(.twoButtonTapped))
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(state, StateType.onError([.viewUpdate]))
        }
      )
    subscriber?.cancel()

    // Third iteration - Event "clearAllButtonTapped" -> state should be "default"
    machine.tryChangeToNextState(for: .custom(.clearAllButtonTapped))
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(state, StateType.default(completion: nil))
        }
      )
    subscriber?.cancel()
  }

  func testAnyStateWithCustomEvents() {
    typealias StateType = StateMachineStateType<StateMachineNoCustomState>
    typealias Machine = StateMachine<StateMachineNoCustomState, CustomEvents>
    var subscriber: AnyCancellable?
    let defaultState = StateType.default(completion: nil)

    let machine = Machine(state: defaultState)

    machine.addRouteMapping { [unowned self] state, event in
      switch (state, event) {
      case (.any, .custom(.oneButtonTapped)):
        return .onLoading(self.onLoadingConfigurator)
      case (.onLoading, .custom(.twoButtonTapped)):
        return .onError([.viewUpdate])
      case (.any, .custom(.clearAllButtonTapped)):
        return .default(completion: nil)
      default:
        return nil
      }
    }

    // First iteration - Event "oneButtonTapped" -> state should be "onLoading"
    machine.tryChangeToNextState(for: .custom(.oneButtonTapped))
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { [unowned self] state in
          XCTAssertEqual(state, StateType.onLoading(self.onLoadingConfigurator))
        }
      )
    subscriber?.cancel()

    // Second iteration - Event "twoButtonTapped" -> state should be "onError([.viewUpdate])"
    machine.tryChangeToNextState(for: .custom(.twoButtonTapped))
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(state, StateType.onError([.viewUpdate]))
        }
      )
    subscriber?.cancel()

    // Third iteration - Event "clearAllButtonTapped" -> state should be "default"
    machine.tryChangeToNextState(for: .custom(.clearAllButtonTapped))
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(state, StateType.default(completion: nil))
        }
      )
    subscriber?.cancel()
  }

  func testAnyStateAndAnyEvent() {
    typealias StateType = StateMachineStateType<StateMachineNoCustomState>
    typealias Machine = StateMachine<StateMachineNoCustomState, CustomEvents>
    var subscriber: AnyCancellable?
    let defaultState = StateType.default(completion: nil)

    let machine = Machine(state: defaultState)

    machine.addRouteMapping { [unowned self] state, event in
      switch (state, event) {
      case (.default(completion: nil), .any):
        return .onLoading(self.onLoadingConfigurator)
      case (.onLoading, .any):
        return .onError([.viewUpdate])
      case (.onError, .any):
        return .default(completion: nil)
      default:
        return nil
      }
    }

    // First iteration - Event "any" -> state should be "onLoading"
    machine.tryChangeToNextState(for: .any)
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { [unowned self] state in
          XCTAssertEqual(state, StateType.onLoading(self.onLoadingConfigurator))
        }
      )
    subscriber?.cancel()

    // Second iteration - Event "any" -> state should be "onError([.viewUpdate])"
    machine.tryChangeToNextState(for: .any)
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(state, StateType.onError([.viewUpdate]))
        }
      )
    subscriber?.cancel()

    // Third iteration - Event "any" -> state should be "default"
    machine.tryChangeToNextState(for: .any)
    subscriber = machine
      .onStateChangePublisher
      .sink(
        receiveValue: { state in
          XCTAssertEqual(state, StateType.default(completion: nil))
        }
      )
    subscriber?.cancel()
  }
}

// MARK: - Custom types

extension StateMachineTests {
  enum CustomStates: StateMachineCustomState {
    case one
    case two
  }

  enum CustomEvents: StateMachineCustomEvent {
    case oneButtonTapped
    case twoButtonTapped
    case clearAllButtonTapped
  }
}
