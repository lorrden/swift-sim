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
public class Logger {
  func log(sender: Model, level: LogLevel, message: String) {
    print("\(level): \(sender.name): \(message)")
  }

  func logDebug(sender: Model, message: String) {
    log(sender: sender, level: .Debug, message: message)
  }
  func logTrace(sender: Model, message: String) {
    log(sender: sender, level: .Trace, message: message)
  }
  func logInfo(sender: Model, message: String) {
    log(sender: sender, level: .Info, message: message)
  }
  func logWarning(sender: Model, message: String) {
    log(sender: sender, level: .Warning, message: message)
  }
  func logError(sender: Model, message: String) {
    log(sender: sender, level: .Error, message: message)
  }
}
