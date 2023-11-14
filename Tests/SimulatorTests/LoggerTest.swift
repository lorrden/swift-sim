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

fileprivate class NamedModel : Model {
  override init(name: String) {
    super.init(name: name)
  }
}


class TestLogger : LogBackend {
  func log(sender: Model, level: LogLevel, message: String) {
    let timeStamp = timeKeeper.getTime(base: timeUnit)
    let seconds = Double(timeStamp/1000000000) + Double(timeStamp % 1000000000) / 1.0e9
    self.message = "\(seconds): \(level): \(sender.name): \(message)"
  }
  var timeKeeper: TimeKeeper
  var timeUnit: TimeBase = .SimTime
  var level: LogLevel = .Info
  init(timeKeeper: TimeKeeper) {
    self.timeKeeper = timeKeeper
  }

  var message: String = ""
}

final class LoggerTest: XCTestCase {
  func testLogDebug() throws {
    let timeKeeper = TimeKeeperImpl()
    let loggerBackend = TestLogger(timeKeeper: timeKeeper)
    let logger = LoggerImpl(timeKeeper: timeKeeper)
    logger.logBackend = loggerBackend
    loggerBackend.level = .Debug
    let foo = NamedModel(name: "foo")
    logger.debug(sender: foo, message: "my message")

    XCTAssertEqual("0.0: Debug: foo: my message", loggerBackend.message)
  }

  func testLogTrace() throws {
    let timeKeeper = TimeKeeperImpl()
    let loggerBackend = TestLogger(timeKeeper: timeKeeper)
    let logger = LoggerImpl(timeKeeper: timeKeeper)
    logger.logBackend = loggerBackend
    loggerBackend.level = .Debug
    let foo = NamedModel(name: "foo")
    logger.trace(sender: foo, message: "my message")

    XCTAssertEqual("0.0: Trace: foo: my message", loggerBackend.message)
  }


  func testLogInfo() throws {
    let timeKeeper = TimeKeeperImpl()
    let loggerBackend = TestLogger(timeKeeper: timeKeeper)
    let logger = LoggerImpl(timeKeeper: timeKeeper)
    logger.logBackend = loggerBackend
    let foo = NamedModel(name: "foo")
    logger.info(sender: foo, message: "my message")

    XCTAssertEqual("0.0: Info: foo: my message", loggerBackend.message)
  }

  func testLogWarning() throws {
    let timeKeeper = TimeKeeperImpl()
    let loggerBackend = TestLogger(timeKeeper: timeKeeper)
    let logger = LoggerImpl(timeKeeper: timeKeeper)
    logger.logBackend = loggerBackend
    let foo = NamedModel(name: "foo")
    logger.warning(sender: foo, message: "my message")

    XCTAssertEqual("0.0: Warning: foo: my message", loggerBackend.message)
  }

  func testLogError() throws {
    let timeKeeper = TimeKeeperImpl()
    let loggerBackend = TestLogger(timeKeeper: timeKeeper)
    let logger = LoggerImpl(timeKeeper: timeKeeper)
    logger.logBackend = loggerBackend
    let foo = NamedModel(name: "foo")
    logger.error(sender: foo, message: "my message")

    XCTAssertEqual("0.0: Error: foo: my message", loggerBackend.message)
  }


}
