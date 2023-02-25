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



final class ResolverTest: XCTestCase {
  func testResolveAbsolute() throws {
    let sim = Simulator()
    let a = Model(name: "a")
    let b = Model(name: "b")
    let c = Model(name: "c")
    try a.add(child: c)
    try sim.add(model: a)
    try sim.add(model: b)
    XCTAssertIdentical(a, sim.resolver.resolve(absolute: "/a"))
    XCTAssertIdentical(b, sim.resolver.resolve(absolute: "/b"))
    XCTAssertIdentical(c, sim.resolver.resolve(absolute: "/a/c"))
    XCTAssertIdentical(nil, sim.resolver.resolve(absolute: "/x"))
    XCTAssertIdentical(nil, sim.resolver.resolve(absolute: "/a/y"))
    XCTAssertIdentical(a, sim.resolver.resolve(absolute: "/a/c/../"))
  }


  func testResolveRelative() throws {
    let sim = Simulator()
    let a = Model(name: "a")
    let b = Model(name: "b")
    let c = Model(name: "c")
    try a.add(child: c)
    try sim.add(model: a)
    try sim.add(model: b)
    XCTAssertIdentical(a, sim.resolver.resolve(relative: "../", source: c))
    XCTAssertIdentical(b, sim.resolver.resolve(relative: "../b", source: a))
    XCTAssertIdentical(a, sim.resolver.resolve(relative: "../../a", source: c))
    XCTAssertIdentical(b, sim.resolver.resolve(relative: "../../b", source: c))
    XCTAssertIdentical(c, sim.resolver.resolve(relative: "./", source: c))
    XCTAssertIdentical(a, sim.resolver.resolve(relative: "../a", source: b))
    XCTAssertIdentical(c, sim.resolver.resolve(relative: "../a/c", source: b))
    XCTAssertIdentical(nil, sim.resolver.resolve(relative: "../../", source: b))
    XCTAssertIdentical(nil, sim.resolver.resolve(relative: "../../a", source: b))
  }
}
