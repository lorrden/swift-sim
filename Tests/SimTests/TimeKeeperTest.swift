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

final class TimeKeeperTest: XCTestCase {
  func testEpochToMissionTime() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10

    XCTAssertEqual(0, timeKeeper.convertToMissionTime(epochTime: 10))
  }
  func testEpochToSimTime() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10
    XCTAssertEqual(0, timeKeeper.convertToSimTime(epochTime: 10))
  }
  func testMissionToSimTime() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10
    XCTAssertEqual(10, timeKeeper.convertToSimTime(missionTime: 10))
  }
  func testMissionToEpochTime() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10
    XCTAssertEqual(20, timeKeeper.convertToEpochTime(missionTime: 10))
  }
  func testSimToMissionTime() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10
    XCTAssertEqual(10, timeKeeper.convertToMissionTime(simTime: 10))
  }
  func testSimToEpochTime() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10
    XCTAssertEqual(20, timeKeeper.convertToEpochTime(simTime:  10))
  }
}
