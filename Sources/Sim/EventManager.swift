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

public protocol EventManagerProt : Service {
  func queryEventId(eventName: String) -> Int?
  func publishEvent(eventName: String) throws -> Int
  func subscribe(eventName: String,  action: @escaping () -> ()) throws
  func subscribe(eventId: Int, action: @escaping () -> ()) throws
  func emit(eventName: String) throws
  func emit(eventId: Int) throws
}

public class EventManager : EventManagerProt, Service {
  public var name: String = "EventManager"
  public weak var sim: Simulator!

  var events: [[()->()]] = []
  var eventIds : [String:Int] = [:]
  public func queryEventId(eventName: String) -> Int? {
    return eventIds[eventName]
  }
  /// Publish an event by name
  /// - Parameter eventName: Event name
  /// - Returns: Event ID unless the eventName was a duplicate
  public func publishEvent(eventName: String) throws -> Int {
    guard !eventIds.keys.contains(eventName) else {
      throw SimError.DuplicateName
    }

    let eventID = events.count
    eventIds[eventName] = eventID
    events.append([])
    return eventID
  }

  public func subscribe(eventName: String,  action: @escaping () -> ()) throws {
    guard let id = queryEventId(eventName: eventName) else {
      throw SimError.InvalidEventName
    }
    try subscribe(eventId: id, action: action)
  }
  public func subscribe(eventId: Int, action: @escaping () -> ()) throws {
    guard eventId < events.count else {
      throw SimError.InvalidEventId
    }
    events[eventId].append(action)
  }

  public func emit(eventName: String) throws {
    guard let id = queryEventId(eventName: eventName) else {
      throw SimError.InvalidEventName
    }
    try emit(eventId: id)
  }
  public func emit(eventId: Int) throws {
    guard eventId < events.count else {
      throw SimError.InvalidEventId
    }
    for event in events[eventId] {
      event()
    }
  }
}
