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
  public var resolver: Resolver!
  public var services : [String : Service]

  /// Create a new `Simulator`
  public init() {
    self.timeKeeper = TimeKeeper()
    self.logger = Logger(timeKeeper: self.timeKeeper)
    self.scheduler = Scheduler(withTimeKeeper: self.timeKeeper)
    self.eventManager = EventManager()
    self.models = [:]
    self.services = [:]

    self.resolver = Resolver()

    try! add(service: self.timeKeeper)
    try! add(service: self.logger)
    try! add(service: self.scheduler)
    try! add(service: self.eventManager)
    try! add(service: self.resolver)
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


  /// Add root model using the models name
  /// - Parameter model: Root model to add in the simulator
  public func add(model: Model) throws {
    guard !models.keys.contains(model.name) else {
      throw SimError.DuplicateName
    }
    models[model.name] = model
    model.sim = self
  }
  /// Add service using the service name
  /// - Parameter model: Root model to add in the simulator
  public func add(service: Service) throws {
    guard !services.keys.contains(service.name) else {
      throw SimError.DuplicateName
    }
    services[service.name] = service
    service.sim = self
  }

  /// Add root model
  /// - Parameter model: Root model to add in the simulator
  /// - Parameter name: Name of model
  public func add(model: Model, withName name: String) throws {
    guard !models.keys.contains(name) else {
      throw SimError.DuplicateName
    }
    models[name] = model
    model.sim = self
  }
  /// Add service
  /// - Parameter service: Service object
  /// - Parameter name: Name of service used when looking it up
  public func add(service: Service, withName name: String) throws {
    guard !services.keys.contains(name) else {
      throw SimError.DuplicateName
    }
    services[name] = service
    service.sim = self
  }

  /// Get a root model by name
  /// - Parameter name: Name of root model to get
  /// - Returns: Root model or nil if not found
  public func getRootModel(name: String) -> Model? {
    return models[name]
  }

  /// Get service
  /// - Parameter name: Name of service
  /// - Returns: Service or nil if not found
  public func getService(name: String) -> Service? {
    return services[name]
  }

  // func initialize()
  // func Publish
  // func Configure
  // func connect
  // func halt(immediate: Bool)
}
