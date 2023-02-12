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

@propertyWrapper
struct Input<T> {
  public var wrappedValue: T {
    get {
      _publisher.val
    }
    set {
      _publisher.write(value: newValue)
    }
  }

  class Publisher {
    public var val: T
    func write(value: T) {
      self.val = value
    }
    init(wrappedValue: T) {
      self.val = wrappedValue
    }
  }

  var _publisher: Publisher
  public var projectedValue : Publisher {
    _publisher
  }
  init(wrappedValue: T)
  {
    self._publisher = Publisher(wrappedValue: wrappedValue)
  }
}

@propertyWrapper
struct Output<T> {
  public var wrappedValue: T {
    didSet {
      for v in projectedValue.outputs {
        v.write(value: self.wrappedValue)
      }
    }
  }

  class Publisher {
    var outputs : [Input<T>.Publisher] = []

    func connect(to: Input<T>.Publisher) {
      outputs.append(to)
    }
  }

  var _publisher: Publisher = Publisher()
  public var projectedValue : Publisher {
    _publisher
  }
}
