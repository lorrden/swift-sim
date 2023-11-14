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
@testable import Simulator

final class EventManagerTest: XCTestCase {
  func testPublication() throws {
    let eventManager = EventManagerImpl()
    XCTAssertNoThrow(try eventManager.publishEvent(eventName: "foo"))
    XCTAssertThrowsError(try eventManager.publishEvent(eventName: "foo")) { error in
      XCTAssertEqual(error as! SimError, SimError.DuplicateName)
    }

    XCTAssertEqual(1, try eventManager.publishEvent(eventName: "bar"))
  }

  func testSubscribe() throws {
    let eventManager = EventManagerImpl()
    XCTAssertThrowsError(try eventManager.subscribe(eventName: "foo", action: {})) { error in
      XCTAssertEqual(error as! SimError, SimError.InvalidEventName)
    }

    XCTAssertThrowsError(try eventManager.subscribe(eventId: 42, action: {})) { error in
      XCTAssertEqual(error as! SimError, SimError.InvalidEventId)
    }
  }
  func testEmitFailures() throws {
    let eventManager = EventManagerImpl()
    XCTAssertThrowsError(try eventManager.emit(eventName: "foo")) { error in
      XCTAssertEqual(error as! SimError, SimError.InvalidEventName)
    }

    XCTAssertThrowsError(try eventManager.emit(eventId: 42)) { error in
      XCTAssertEqual(error as! SimError, SimError.InvalidEventId)
    }
  }
  func testEmitAndSubscribe() throws {
    let eventManager = EventManagerImpl()
    let _ = try eventManager.publishEvent(eventName: "foo")

    var wasInvoked = false
    try eventManager.subscribe(eventName: "foo") {
      wasInvoked = true
    }

    XCTAssertFalse(wasInvoked)

    try eventManager.emit(eventName: "foo")

    XCTAssertTrue(wasInvoked)
  }
}
