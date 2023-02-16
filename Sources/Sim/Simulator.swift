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

public class EventManager {

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
    self.timeKeeper = TimeKeeper()
    self.scheduler = Scheduler(withTimeKeeper: self.timeKeeper)
    self.eventManager = EventManager()
    self.models = [:]
  }

  public func run(for delta: Int) {
    scheduler.run(for: delta)
  }
  public func run(until: Int) {
    scheduler.run(until: until)
  }
  public func run(untilEpochTime epochTime: Int) {
    scheduler.run(untilEpochTime: epochTime)
  }
  public func run(untilMissionTime missionTime: Int) {
    scheduler.run(untilMissionTime: missionTime)
  }
}
