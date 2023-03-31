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

class ClockedFoo : Model, ClockedModel {
  var period: Double = 0.1
  var frequency: Double{
    get {
      return 1 / period
    }
    set {
      period = 1 / newValue
    }
  }
  var tickInvokations: Int = 0

  func tick(dt: Double) {
    tickInvokations += 1
  }
  override init(name: String) {
    super.init(name: name)
  }
}

final class ClockedModelTest: XCTestCase {
  func testClockedRootModel() throws {
    let sim = SimulatorImpl() as Simulator
    XCTAssertNoThrow(try sim.add(model: ClockedFoo(name: "foo")))
    let foo = sim.getRootModel(name: "foo") as! ClockedFoo


    XCTAssertEqual(0, foo.tickInvokations)

    sim.scheduler.run(for: 100_000_000)
    XCTAssertEqual(1, foo.tickInvokations)

    sim.scheduler.run(for: 100_000_000)
    XCTAssertEqual(2, foo.tickInvokations)

    sim.scheduler.run(for: 1_000_000_000)
    XCTAssertEqual(12, foo.tickInvokations)
  }
}
