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
  func testSimTimeToUnixTime() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10
    XCTAssertEqual(946728000000000010, timeKeeper.convertToUnixTime(simTime: 0))
    XCTAssertEqual(10, timeKeeper.convertToUnixTime(simTime: -946728000000000000))
  }
  func testMissionTimeToUnixTime() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 20
    XCTAssertEqual(946728000000000020, timeKeeper.convertToUnixTime(missionTime: 0))
    XCTAssertEqual(20, timeKeeper.convertToUnixTime(missionTime: -946728000000000000))
  }

  func testEpochTimeToUnixTime() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10
    XCTAssertEqual(946728000000000000, timeKeeper.convertToUnixTime(epochTime: 0))
    XCTAssertEqual(0, timeKeeper.convertToUnixTime(epochTime: -946728000000000000))
  }

  func testEpochTimeToJD() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10
    XCTAssertEqual(2451545.0, timeKeeper.convertToJD(epochTime: 0))
  }
  func testMissionTimeToJD() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.missionStartTime = 10000000000
    XCTAssertEqual(2451545.000115, timeKeeper.convertToJD(missionTime: 0), accuracy: 0.000005)
  }
  func testSimTimeToJD() throws {
    let timeKeeper = TimeKeeper()
    XCTAssertEqual(2451545.0, timeKeeper.convertToJD(simTime: 0))
  }

  func testUnixTimeToJD() throws {
    let timeKeeper = TimeKeeper()
    timeKeeper.epochTime = 10
    timeKeeper.missionStartTime = 10
    XCTAssertEqual(2440587.5, timeKeeper.convertToJD(unixTime: 0))
  }
  func testUnixTimeToEpochTime() throws {
    let timeKeeper = TimeKeeper()
    XCTAssertEqual(-946728000000000000, timeKeeper.convertToEpochTime(unixTime: 0))
    XCTAssertEqual(0, timeKeeper.convertToEpochTime(unixTime: 946728000000000000))
  }

  func testGetTime() throws {
    let timeKeeper = TimeKeeper()
    XCTAssertEqual(0, timeKeeper.getTime(base: .SimTime))
    XCTAssertEqual(0, timeKeeper.getTime(base: .MissionTime))
    XCTAssertEqual(0, timeKeeper.getTime(base: .EpochTime))
    XCTAssertEqual(946728000000000000, timeKeeper.getTime(base: .UnixTime))
  }

  func testConvertEpochTimeToFoundationDate() throws {
    let timeKeeper = TimeKeeper()

    let date = timeKeeper.convertToCalendarDate(epochTime: 0)
    let formatter = ISO8601DateFormatter()
    let dateString = formatter.string(from: date)

    XCTAssertEqual("2000-01-01T12:00:00Z", dateString)
  }

  func testConvertSimTimeToFoundationDate() throws {
    let timeKeeper = TimeKeeper()

    let date = timeKeeper.convertToCalendarDate(simTime: 0)
    let formatter = ISO8601DateFormatter()
    let dateString = formatter.string(from: date)

    XCTAssertEqual("2000-01-01T12:00:00Z", dateString)
  }
  func testConvertMissionTimeToFoundationDate() throws {
    let timeKeeper = TimeKeeper()

    let date = timeKeeper.convertToCalendarDate(missionTime: 0)
    let formatter = ISO8601DateFormatter()
    let dateString = formatter.string(from: date)

    XCTAssertEqual("2000-01-01T12:00:00Z", dateString)
  }
  func testConvertUnixTimeToFoundationDate() throws {
    let timeKeeper = TimeKeeper()

    let date = timeKeeper.convertToCalendarDate(unixTime: 0)
    let formatter = ISO8601DateFormatter()
    let dateString = formatter.string(from: date)

    XCTAssertEqual("1970-01-01T00:00:00Z", dateString)
  }

}
