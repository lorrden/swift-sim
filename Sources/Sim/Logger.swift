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

public enum LogLevel {
  case Debug
  case Trace
  case Info
  case Warning
  case Error
}
/// Centralized logger
public class Logger {
  let timeKeeper: TimeKeeper
  var timeUnit: TimeBase = .SimTime

  init(timeKeeper: TimeKeeper) {
    self.timeKeeper = timeKeeper
  }

  func log(sender: Model, level: LogLevel, message: String) {
    let timeStamp = timeKeeper.getTime(base: timeUnit)
    let seconds = Double(timeStamp/1000000000) + Double(timeStamp % 1000000000) / 1.0e9
    print("\(seconds): \(level): \(sender.name): \(message)")
  }

  /// Log debug messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func logDebug(sender: Model, message: String) {
    log(sender: sender, level: .Debug, message: message)
  }
  /// Log trace messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func logTrace(sender: Model, message: String) {
    log(sender: sender, level: .Trace, message: message)
  }
  /// Log informational messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func logInfo(sender: Model, message: String) {
    log(sender: sender, level: .Info, message: message)
  }
  /// Log warning messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func logWarning(sender: Model, message: String) {
    log(sender: sender, level: .Warning, message: message)
  }
  /// Log error messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func logError(sender: Model, message: String) {
    log(sender: sender, level: .Error, message: message)
  }
}
