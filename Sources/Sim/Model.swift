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

open class Model {
  weak var _sim: Simulator!
  public weak var sim: Simulator! { get { _sim } }
  weak var parent: Model?
  var children: [String : Model]
  var entrypoints: [String : ()->()] = [:]
  public let name: String

  public init(name: String) {
    self.name = name
    self.children = [:]
  }

  public func add(child: Model) throws {
    guard !children.keys.contains(child.name) else {
      throw SimError.DuplicateName
    }

    children[child.name] = child
    child.parent = self
    child._sim = self.sim
  }
  public func add(child: Model, name withName: String) throws {
    guard !children.keys.contains(name) else {
      throw SimError.DuplicateName
    }

    children[name] = child
    child.parent = self
    child._sim = self.sim
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
