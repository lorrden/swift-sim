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

class Foo : Model {
  override init(name: String) {
    super.init(name: name)
  }
}
final class SimulatorTest: XCTestCase {
    func testScheduler() throws {
      var wasCalled: Bool = false
      let sim = SimulatorImpl()

      sim.scheduler.postImmediate() {
        wasCalled = true;
      }
      sim.scheduler.run(for: 0)
      XCTAssertEqual(wasCalled, true)

      var ev2WasCalled = false
      sim.scheduler.post(simTime: 10) {
        ev2WasCalled = true
      }
      sim.scheduler.run(until: 0)
      XCTAssertEqual(ev2WasCalled, false)

      sim.scheduler.run(until: 9)
      XCTAssertEqual(ev2WasCalled, false)

      sim.scheduler.run(until: 10)
      XCTAssertEqual(ev2WasCalled, true)

    }

  func testAddModel() throws {
    let sim = SimulatorImpl()
    XCTAssertNoThrow(try sim.add(model: Foo(name: "foo")))
    XCTAssertThrowsError(try sim.add(model: Foo(name: "foo"))) { error in
      XCTAssertEqual(error as! SimError, SimError.DuplicateName)
    }
  }
}
