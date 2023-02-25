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

public protocol LogBackend {
  func log(sender: Model, level: Logger.Level, message: String)
  var timeKeeper: TimeKeeper { get set }
  var level: Logger.Level { get set }
}

class PrintLogger : LogBackend {
  func log(sender: Model, level: Logger.Level, message: String) {
    let timeStamp = timeKeeper.getTime(base: timeUnit)
    let seconds = Double(timeStamp/1000000000) + Double(timeStamp % 1000000000) / 1.0e9
    print("\(seconds): \(level): \(sender.name): \(message)")
  }
  var timeKeeper: TimeKeeper
  var timeUnit: TimeBase = .SimTime
  var level: Logger.Level = .Info
  init(timeKeeper: TimeKeeper) {
    self.timeKeeper = timeKeeper
  }
}

public protocol LoggerProt : Service {
  /// Log debug messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func debug(sender: Model, message: String)

  /// Log trace messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func trace(sender: Model, message: String)
  /// Log informational messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func info(sender: Model, message: String)
  /// Log warning messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func warning(sender: Model, message: String)
  /// Log error messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  func error(sender: Model, message: String)
}

/// Centralized logger
public class Logger : LoggerProt, Service {
  public var name: String = "Logger"
  public weak var sim: Simulator!

  public enum Level {
    case Debug
    case Trace
    case Info
    case Warning
    case Error
  }
  var logBackend: LogBackend
  let timeKeeper: TimeKeeper
  var timeUnit: TimeBase = .SimTime

  init(timeKeeper: TimeKeeper) {
    self.timeKeeper = timeKeeper
    self.logBackend = PrintLogger(timeKeeper: timeKeeper)
  }

  func log(sender: Model, level: Logger.Level, message: String) {
    logBackend.log(sender: sender, level: level, message: message)
  }

  /// Log debug messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  public func debug(sender: Model, message: String) {
    log(sender: sender, level: .Debug, message: message)
  }
  /// Log trace messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  public func trace(sender: Model, message: String) {
    log(sender: sender, level: .Trace, message: message)
  }
  /// Log informational messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  public func info(sender: Model, message: String) {
    log(sender: sender, level: .Info, message: message)
  }
  /// Log warning messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  public func warning(sender: Model, message: String) {
    log(sender: sender, level: .Warning, message: message)
  }
  /// Log error messages
  /// - Parameters:
  ///   - sender: Model emitting the message
  ///   - message: Message
  public func error(sender: Model, message: String) {
    log(sender: sender, level: .Error, message: message)
  }
}
