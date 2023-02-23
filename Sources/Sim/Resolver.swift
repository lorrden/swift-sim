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

/// Resolves simulation paths
/// Paths can be either absolute (starting with /) or relative with respect to a model.
/// Looking for /foo/bar will return the submodel of foo called bar.
/// Path expressions resolve to models, not fields in the models.
/// Path expressions support `..` and `.` meaning parent or this model.
public class Resolver {
  weak var sim: Simulator!
  init(sim: Simulator)
  {
    self.sim = sim
  }

  /// Resolve absolute path in the simulation tree
  /// - Parameter absolute: Absolute path starting with `/`
  /// - Returns: Returns the model at the given path in the simulation tree, or nil if not found
  public func resolve(absolute: String) -> Model? {
    let components = absolute.split(separator: "/")

    var cursor: Model? = sim.models[String(components[0])]

    for component in components[1...] {
      if component == ".." {
        cursor = cursor?.parent
      } else if component != "." {
        // For non self references go up
        cursor = cursor?.children[String(component)]
      }
    }

    return cursor
  }

  /// Resolve relative path, starting at the given model instead of the root
  /// - Parameters:
  ///   - relative: Relative path starting with a model name, `..` or `.`
  ///   - source: Source model
  /// - Returns: Model at the relative path location, or nil if not found.
  public func resolve(relative: String, source: Model) -> Model? {
    let components = relative.split(separator: "/")
    var cursor: Model? = source
    var atRoot: Bool = false

    for component in components {
      if component == ".." {
        cursor = cursor?.parent
        if atRoot {
          atRoot = false
        } else if cursor == nil  {
          atRoot = true
        }
      } else if component != "." {
        // For non self references go up
        if atRoot {
          cursor = sim.models[String(component)]
          atRoot = false
        } else {
          cursor = cursor?.children[String(component)]
        }
      }
    }

    return cursor
  }

}
