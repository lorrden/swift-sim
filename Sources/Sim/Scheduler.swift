//
// SPDX-License-Identifier: Apache-2.0
//
// Copyright 2023 Mattias Holm
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Collections

struct TimedEvent: Comparable {
  let time: Int
  let event: () -> ()

  static func < (lhs: TimedEvent, rhs: TimedEvent) -> Bool {
    return lhs.time < rhs.time
  }
  static func == (lhs: TimedEvent, rhs: TimedEvent) -> Bool {
    return lhs.time == rhs.time
  }
}

public protocol SchedulerProt: Service {
  func postImmediate(event: @escaping () -> ())
  func post(simTime: Int, event: @escaping () -> ())
  func post(relative: Double, event: @escaping () -> ())
  func post(missionTime: Int, event: @escaping () -> ())
  func post(epochTime: Int, event: @escaping () -> ())
}

public class Scheduler: SchedulerProt, Service {
  public var name: String = "Scheduler"
  public weak var sim: Simulator!

  private var immediateEvents: [() -> ()] = []
  private var timedEvents: Heap<TimedEvent> = []

  /// Post an immedate event
  /// - Parameter event: Event handler
  public func postImmediate(event: @escaping () -> ()) {
    immediateEvents.append(event)
  }
  /// Post an event triggered at a specific simulation time
  /// - Parameters:
  ///   - simTime: Simulation time
  ///   - event: Event handler
  public func post(simTime: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: simTime, event: event))
  }
  /// Post an event triggered at a relative time
  /// - Parameters:
  ///   - relative: Relative time in seconds
  ///   - event: Event handler
  public func post(relative: Double, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: timeKeeper.simTime + Int(relative * 1.0e9), event: event))
  }
  /// Post an event trigeered at a specific mission time
  /// - Parameters:
  ///   - missionTime: Mission time of even
  ///   - event: Event handler
  public func post(missionTime: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: missionTime, event: event))
  }
  /// Post an event at a specific epoch time
  /// - Parameters:
  ///   - epochTime: Epoch time
  ///   - event: Event handler
  public func post(epochTime: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: epochTime, event: event))
  }
  /// Post a cyclic event triggered at a specific sim time
  /// - Parameters:
  ///   - simTime: Sim time of first triggering
  ///   - cycle: Cycle in nanoseconds
  ///   - count: Number of times the event should trigger, for indefinite triggerings set to -1
  ///   - event: Event handler
  public func post(simTime: Int, cycle: Int, count: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: simTime, event: event))
  }
  /// Post a cyclic event triggered at a specific mission time
  /// - Parameters:
  ///   - missionTime: Mission time of first triggering
  ///   - cycle: Cycle in nanoseconds
  ///   - count: Number of times the event should trigger, for indefinete triggering set to -1
  ///   - event: Event handler
  public func post(missionTime: Int, cycle: Int, count: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: missionTime, event: event))
  }
  /// Post a cyclic event triggered at a specific epoch time
  /// - Parameters:
  ///   - epochTime: Epoch time of first triggering
  ///   - cycle: Cycle in nanoseconds
  ///   - count: Number of times the event should trigger, for indefinete triggering set to -1
  ///   - event: Event handler
  public func post(epochTime: Int, cycle: Int, count: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: epochTime, event: event))
  }

  fileprivate func runImmediateEvents() {
    for e in immediateEvents {
      e()
    }
    immediateEvents.removeAll()
  }
  /// Run scheduler until simulated time
  /// - Parameter until: Simulated time in nanoseconds
  public func run(until: Int) {
    runImmediateEvents()

    while (timedEvents.min()?.time ?? Int.max) <= until {
      let ev = timedEvents.popMin()!
      timeKeeper.simTime = ev.time
      ev.event()
      runImmediateEvents()
    }
    timeKeeper.simTime = until
  }
  /// Run scheduler until epoch time
  /// - Parameter epochTime: Epoch time in nanoseconds
  public func run(untilEpochTime epochTime: Int) {
    let simTime = timeKeeper.convertToSimTime(epochTime: epochTime)
    run(until: simTime)
  }
  /// Run scheduler until mission time
  /// - Parameter missionTime: Mission time in nanoseconds
  public func run(untilMissionTime missionTime: Int) {
    let simTime = timeKeeper.convertToSimTime(missionTime: missionTime)
    run(until: simTime)
  }
  /// Run scheduler for a fixed number of nanoseconds
  /// - Parameter delta: Relative number of nanoseconds to run the scheduler
  public func run(for delta: Int) {
    let endTime = timeKeeper.simTime + delta
    run(until: endTime)
  }

  fileprivate let timeKeeper: TimeKeeper
  /// Create a new scheduler
  /// - Parameter timeKeeper: Time keeper used by scheduler
  public init(withTimeKeeper timeKeeper: TimeKeeper) {
    self.timeKeeper = timeKeeper
  }
}
