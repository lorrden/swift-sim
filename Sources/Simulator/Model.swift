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

public protocol Publisher : Service {
  func publishField(name: String, reader: ()->(), writer: ()->())
}

open class Model {
  weak var _sim: Simulator!
  public weak var sim: Simulator! { get { _sim } }
  weak var parent: Model?
  var children: [String : Model]
  var entrypoints: [String : ()->()] = [:]

  var stateWriters: [String : (Any)->()] = [:]
  var stateReaders: [String : ()->Any] = [:]

  public let name: String

  public init(name: String) {
    self.name = name
    self.children = [:]
  }

  public func publishFieldReader(name: String, reader: @escaping ()->(Any)) throws {
    guard !stateReaders.keys.contains(name) else {
      throw SimError.DuplicateName
    }

    stateReaders[name] = reader
  }
  public func publishFieldWriter(name: String, writer: @escaping (Any)->()) throws {
    guard !stateWriters.keys.contains(name) else {
      throw SimError.DuplicateName
    }

    stateWriters[name] = writer
  }
  public func getField(name: String) throws -> Any {
    guard let reader = stateReaders[name] else {
      throw SimError.InvalidFieldName
    }

    return reader()
  }
  public func setField(name: String, value: Any) throws
  {
    guard let writer = stateWriters[name] else {
      throw SimError.InvalidFieldName
    }

    writer(value)
  }

  public func add(child: Model) throws {
    try add(child: child, withName: child.name)
  }
  public func add(child: Model, withName name: String) throws {
    guard !children.keys.contains(name) else {
      throw SimError.DuplicateName
    }

    children[name] = child
    child.parent = self
    child._sim = self.sim

    if let clockedModel = child as? ClockedModel {
      sim.scheduler.post(simTime: Int(clockedModel.period * 1e9),
                     cycle: Int(clockedModel.period * 1e9),
                     count: nil) {
        clockedModel.tick(dt: clockedModel.period)
      }
    }
  }

  public func add(entrypoint: String, operation: @escaping ()->()) throws {
    guard !entrypoints.keys.contains(entrypoint) else {
      throw SimError.DuplicateName
    }

    entrypoints[entrypoint] = operation
  }

  // Called after everything has been built to finish initialisation
  open func publish() {
  }
  open func configure() {
  }
  open func connect() {
  }
}

/* The ClockedModel protocol is used to trigger models at a specific rate */
public protocol ClockedModel {
  var frequency: Double { get set }
  var period: Double { get set }
  func tick(dt: Double)
}
