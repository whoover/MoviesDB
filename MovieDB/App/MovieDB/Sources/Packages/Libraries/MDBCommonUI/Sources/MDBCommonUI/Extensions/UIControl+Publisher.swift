//
//  UIControl+Publisher.swift
//
//
//  Created by Artem Belenkov on 08.01.2022.
//

/// Extension to `UIControl` with custom `Subscription` implementation for all events.
private extension UIControl {
  class EventControlSubscription<EventSubscriber: Subscriber, T: UIControl>: Subscription
    where EventSubscriber.Input == T, EventSubscriber.Failure == Never
  {
    let control: T
    let event: T.Event
    var subscriber: EventSubscriber?

    var currentDemand: Subscribers.Demand = .none

    init(control: T, event: T.Event, subscriber: EventSubscriber) {
      self.control = control
      self.event = event
      self.subscriber = subscriber

      control.addTarget(self,
                        action: #selector(eventRaised),
                        for: event)
    }

    func request(_ demand: Subscribers.Demand) {
      currentDemand += demand
    }

    func cancel() {
      subscriber = nil
      control.removeTarget(self,
                           action: #selector(eventRaised),
                           for: event)
    }

    @objc
    func eventRaised() {
      if currentDemand > 0 {
        currentDemand += subscriber?.receive(control) ?? .none
        currentDemand -= 1
      }
    }
  }
}

/// Extension to `UIControl` with custom `Publisher` implementation for all events.
public extension UIControl {
  struct EventControlPublisher<T: UIControl>: Publisher {
    public typealias Output = T
    public typealias Failure = Never

    let control: T
    let controlEvent: T.Event

    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
      // instantiate the new subscription
      let subscription = EventControlSubscription(control: control, event: controlEvent, subscriber: subscriber)
      // tell the subscriber that it has successfully subscribed to the publisher
      subscriber.receive(subscription: subscription)
    }
  }
}

/// Extension to `UIControl` with custom publisher.
extension UIControl {
  func publisher(for event: UIControl.Event) -> UIControl.EventControlPublisher<UIControl> {
    UIControl.EventControlPublisher(control: self, controlEvent: event)
  }
}

/// Extension to `UIButton` with custom publisher.
extension UIButton {
  func buttonPublisher(for event: UIControl.Event) -> UIControl.EventControlPublisher<UIButton> {
    UIControl.EventControlPublisher(control: self, controlEvent: event)
  }
}

/// Extension to `UISwitch` with custom publisher.
public extension UISwitch {
  func switchPublisher(for event: UIControl.Event) -> UIControl.EventControlPublisher<UISwitch> {
    UIControl.EventControlPublisher(control: self, controlEvent: event)
  }
}
