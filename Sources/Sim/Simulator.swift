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


/// Simulator
///
/// The `Simulator` is the main driver in `swift-sim`.
/// The `Simulator` manages the simulation tree, and exposes functions to run the simulation.
public class Simulator {
  public var logger : Logger
  public var scheduler : Scheduler
  public var eventManager : EventManager
  public var timeKeeper : TimeKeeper
  public var models : [String : Model]
  /// Add root model
  /// - Parameter model: Root model to add in the simulator
  public func add(model: Model) throws {
    guard !models.keys.contains(model.name) else {
      throw SimError.DuplicateName
    }
    models[model.name] = model
  }

  /// Create a new `Simulator`
  public init() {
    self.logger = Logger()
    self.timeKeeper = TimeKeeper()
    self.scheduler = Scheduler(withTimeKeeper: self.timeKeeper)
    self.eventManager = EventManager()
    self.models = [:]
  }

  /// Run simulation for a relative time mission time
  /// - Parameter delta: Nanoseconds to run simulation
  public func run(for delta: Int) {
    scheduler.run(for: delta)
  }
  /// Run simulation until an absoulte simulation time
  /// - Parameter until: Absolute simulation time in nanoseconds
  public func run(until: Int) {
    scheduler.run(until: until)
  }
  /// Run simulation until an absoulte epoch time
  /// - Parameter epochTime: Absolute epoch time in nanoseconds
  public func run(untilEpochTime epochTime: Int) {
    scheduler.run(untilEpochTime: epochTime)
  }
  /// Run simulation until an absoulte mission time
  /// - Parameter missionTime: Absolute mission time in nanoseconds
  public func run(untilMissionTime missionTime: Int) {
    scheduler.run(untilMissionTime: missionTime)
  }
}
