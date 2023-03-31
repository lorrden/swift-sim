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

public protocol Simulator : AnyObject {
  var logger : Logger { get }
  var scheduler : Scheduler { get }
  var eventManager : EventManager { get }
  var timeKeeper : TimeKeeper { get }
  var resolver: Resolver { get }


  func initialize()
  func publish()
  func configure()
  func connect()

  func addInit(initializer: @escaping () -> ())

  func run(for delta: Int)
  func run(until: Int)
  func run(untilEpochTime epochTime: Int)
  func run(untilMissionTime missionTime: Int)

  func add(model: Model) throws
  func add(service: Service) throws
  func add(model: Model, withName name: String) throws
  func add(service: Service, withName name: String) throws

  func getRootModel(name: String) -> Model?
  func getService(name: String) -> Service?
}

/// Simulator
///
/// The `Simulator` is the main driver in `swift-sim`.
/// The `Simulator` manages the simulation tree, and exposes functions to run the simulation.
public class SimulatorImpl: Simulator {
  public var logger : Logger
  public var scheduler : Scheduler
  public var eventManager : EventManager
  public var timeKeeper : TimeKeeper
  public var models : [String : Model]
  public var resolver: Resolver
  public var services : [String : Service]

  var initializers: [()->()] = []

  /// Create a new `Simulator`
  public init() {
    self.timeKeeper = TimeKeeperImpl()
    self.logger = LoggerImpl(timeKeeper: self.timeKeeper)
    self.scheduler = SchedulerImpl(withTimeKeeper: self.timeKeeper)
    self.eventManager = EventManagerImpl()
    self.models = [:]
    self.services = [:]

    self.resolver = ResolverImpl()

    try! add(service: self.logger)
    try! add(service: self.timeKeeper)
    try! add(service: self.scheduler)
    try! add(service: self.eventManager)
    try! add(service: self.resolver)
  }

  public func initialize() {
    for initializer in initializers {
      initializer()
    }
  }
  public func addInit(initializer: @escaping () -> ()) {
    initializers.append(initializer)
  }
  func publish(model: Model) {
    model.publish()
    for (_, child) in model.children {
      publish(model: child)
    }
  }

  public func publish() {
    for (_, model) in models {
      publish(model: model)
    }
  }

  func configure(model: Model) {
    model.configure()
    for (_, child) in model.children {
      configure(model: child)
    }
  }

  public func configure() {
    for (_, model) in models {
      configure(model: model)
    }
  }
  func connect(model: Model) {
    model.connect()
    for (_, child) in model.children {
      connect(model: child)
    }
  }

  public func connect() {
    for (_, model) in models {
      connect(model: model)
    }
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

  func propagateSim(model: Model) {
    model._sim = self
    for (_, child) in model.children {
      propagateSim(model: child)
    }
  }
  /// Add root model using the models name
  /// - Parameter model: Root model to add in the simulator
  public func add(model: Model) throws {
    try add(model: model, withName: model.name)
  }
  /// Add service using the service name
  /// - Parameter model: Root model to add in the simulator
  public func add(service: Service) throws {
    try add(service: service, withName: service.name)
  }

  /// Add root model
  /// - Parameter model: Root model to add in the simulator
  /// - Parameter name: Name of model
  public func add(model: Model, withName name: String) throws {
    guard !models.keys.contains(name) else {
      throw SimError.DuplicateName
    }
    models[name] = model
    model._sim = self
    propagateSim(model: model)

    if let clockedModel = model as? ClockedModel {
      scheduler.post(simTime: Int(clockedModel.period * 1e9),
                     cycle: Int(clockedModel.period * 1e9),
                     count: nil) {
        clockedModel.tick(dt: clockedModel.period)
      }
    }
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
