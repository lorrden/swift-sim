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

import XCTest
@testable import Sim

class MyModel : Model {
  @Input public var xInput: Int
  @Output public var xOutput: Int

  override init(name: String) {
    self.xInput = 0
    self.xOutput = 0
    super.init(name: name)
  }
}

final class ConnectorTest: XCTestCase {
    func testConnectors() throws {
        let a = MyModel(name: "a")
        let b = MyModel(name: "b")
        let c = MyModel(name: "c")
        a.$xOutput.connect(to: b.$xInput)
        a.$xOutput.connect(to: c.$xInput)

        a.xOutput = 123
        XCTAssertEqual(123, b.xInput)
        XCTAssertEqual(123, c.xInput)

        a.xOutput = 42
        XCTAssertEqual(42, b.xInput)
        XCTAssertEqual(42, c.xInput)
    }
}
