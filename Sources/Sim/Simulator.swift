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

import Foundation
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

public class Scheduler {
  private var immediateEvents: [() -> ()] = []
  private var timedEvents: Heap<TimedEvent> = []

  public func postImmediate(event: @escaping () -> ()) {
    immediateEvents.append(event)
  }
  public func post(simTime: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: simTime, event: event))
  }
  public func post(missionTime: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: missionTime, event: event))
  }
  public func post(epochTime: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: epochTime, event: event))

  }
  public func post(simTime: Int, cycle: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: simTime, event: event))

  }
  public func post(missionTime: Int, cycle: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: missionTime, event: event))

  }
  public func post(epochTime: Int, cycle: Int, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: epochTime, event: event))

  }

  public func runImmediateEvents() {
    for e in immediateEvents {
      e()
    }
    immediateEvents.removeAll()
  }
  public func run(until: Int) {
    runImmediateEvents()

    while (timedEvents.min()?.time ?? Int.max) <= until {
      let ev = timedEvents.popMin()!
      ev.event()
      runImmediateEvents()
    }
  }
  public func run(for: Int) {
    runImmediateEvents()
  }
}
public class EventManager {

}
public class TimeKeeper {
  var simTime: Int = 0
  var epochTime: Int = 0
  var missionStartTime = 0
}

public class Simulator {
  public var logger : Logger
  public var scheduler : Scheduler
  public var eventManager : EventManager
  public var timeKeeper : TimeKeeper
  public var models : [String : Model]
  // Add root model
  public func add(model: Model) {
    if models.keys.contains(model.name) {
      return
    }
    models[model.name] = model
  }

  public init() {
    self.logger = Logger()
    self.scheduler = Scheduler()
    self.eventManager = EventManager()
    self.timeKeeper = TimeKeeper()
    self.models = [:]
  }
}
