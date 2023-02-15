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
  public func post(relative: Double, event: @escaping () -> ()) {
    timedEvents.insert(TimedEvent(time: Int(relative * 1.0e9), event: event))
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
  public var simTime: Int = 0

  private var unixEpochDifference: Int = 946724400 * 1000000000 // J2000 epoch by default
  private var simEpochDifference: Int = 0
  public var epochTime: Int {
    get { simTime + simEpochDifference }
    set { simEpochDifference = newValue - simTime }
  }

  // MissionTime = EpochTime – MissionStartTime
  public var missionStartTime = 0
  public var missionTime: Int {
    get { epochTime - missionStartTime }
    set { missionStartTime = epochTime - newValue }
  }

  // EpochTime = MissionTime + MissionStartTime
  public func convertToEpochTime(missionTime: Int) -> Int {
    return missionTime + missionStartTime
  }
  // MissionTime = EpochTime - MissionStartTime
  public func convertToMissionTime(epochTime: Int) -> Int {
    return epochTime - missionStartTime
  }
  // EpochTime = MissionTime + MissionStartTime
  public func convertToEpochTime(simTime: Int) -> Int {
    return simTime + simEpochDifference
  }
  // MissionTime = EpochTime - MissionStartTime
  public func convertToMissionTime(simTime: Int) -> Int {
    return convertToEpochTime(simTime: simTime) - missionStartTime
  }

  public func convertToSimTime(epochTime: Int) -> Int {
    return epochTime - simEpochDifference
  }

  // EpochTime = MissionTime + MissionStartTime
  public func convertToSimTime(missionTime: Int) -> Int {
    return convertToSimTime(epochTime: convertToEpochTime(missionTime: missionTime))
  }

  public func convertToUnixTime(simTime: Int) -> Int {
    return convertToUnixTime(epochTime: convertToEpochTime(simTime: simTime))
  }
  public func convertToUnixTime(missionTime: Int) -> Int {
    return convertToUnixTime(epochTime: convertToEpochTime(missionTime: missionTime))
  }
  public func convertToUnixTime(epochTime: Int) -> Int {
    return epochTime + unixEpochDifference
  }
}

public enum SimError : Error {
  case CannotDelete
  case CannotRemove
  case CannotRestore
  case CannotStore
  case ContainerFull
  case DuplicateName
  case DuplicateUuid
  case EventSinkAlreadySubscribed
  case EventSinkNotSubscribed
  case FieldAlreadyConnected

  case InvalidAnyType
  case InvalidArrayIndex
  case InvalidArraySize
  case InvalidArrayValue
  case InvalidComponentState
  case InvalidEventSink
  case InvalidFieldName
  case InvalidLibrary
  case InvalidObjectName
  case InvalidObjectType
  case InvalidOperationName
  case InvalidParameterCount
  case InvalidParameterIndex
  case InvalidParameterType
  case InvalidParameterValue
  case InvalidReturnValue
  case InvalidSimualtorState
  case InvalidTarget

  case LibraryNotFound
  case NotContained
  case NotReferenced
  case ReferenceFull

  case VoidOperation
  case DuplicateLiteral
  case InvalidPrimitiveType
  case TypeAlreadyRegistered
  case TypeNotRegistered
  case EntryPointAlreadySubscribed
  case EntryPointNotSubscribed
  case InvalidCycleTime
  case InvalidEventId
  case InvalidEventName
  case InvalidSimulationTime
}

public class Simulator {
  public var logger : Logger
  public var scheduler : Scheduler
  public var eventManager : EventManager
  public var timeKeeper : TimeKeeper
  public var models : [String : Model]
  // Add root model
  public func add(model: Model) throws {
    guard !models.keys.contains(model.name) else {
      throw SimError.DuplicateName
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
