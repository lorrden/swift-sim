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

import Foundation

public let J2000_EPOCH_IN_UNIX_TIME : Int = 946728000
public let UNIX_EPOCH_IN_JD : Double = 2440587.5

public enum TimeBase {
  case UnixTime
  case EpochTime
  case SimTime
  case MissionTime
}

public protocol TimeKeeperProt: Service {
  var unixTime: Int { get }
  var simTime: Int { get set }
  var epochTime: Int { get set }
  var missionStartTime: Int { get set }
  var missionTime: Int { get set }
}

/// Manages simulation, mission and epoch time
///
/// The `TimeKeeper` works with simulation, epoch and mission time in nanoseconds.
/// The different times are related as follows:
///
/// - Simulation Time starts with 0 when the simulation is initialized. It is the time base used internally for events etc.
/// - Epoch Time relates the simulation time to a speciific epoch (e.g. the epoch could be that of J2000 or the UNIX epoch), in addition the epoch time is related to the UNIX epoch with a fixed offset. This in turn enables the conversion into human readable dates.
/// - Mission Time is related to epoch time and provides a mission specific time (e.g. T -/+ n)

public class TimeKeeper : TimeKeeperProt, Service {
  public var name: String = "TimeKeeper"
  public weak var sim: Simulator!

  public var unixTime: Int {
    get { convertToUnixTime(simTime: simTime)}
  }
  public var simTime: Int = 0

  /// Epoch offset in nanoseconds from the UNIX epoch
  public var epochStartTime: Int = J2000_EPOCH_IN_UNIX_TIME * 1000000000 // J2000 epoch by default

  /// Offset relating epoch time to simulation time in nanoseconds
  private var simEpochDifference: Int = 0

  /// Epoch time in nanoseconds
  public var epochTime: Int {
    get { simTime + simEpochDifference }
    set { simEpochDifference = newValue - simTime }
  }


  /// Mission start time is the epoch time when the mission starts in nanoseconds
  public var missionStartTime = 0
  /// missionTime = epochTime – missionStartTime
  public var missionTime: Int {
    get { epochTime - missionStartTime }
    set { missionStartTime = epochTime - newValue }
  }

  /// Converts mission time to epoch time
  /// - Parameter missionTime: Mission time in nanoseconds
  /// - Returns: Epoch time in nanoseconds
  public func convertToEpochTime(missionTime: Int) -> Int {
    return missionTime + missionStartTime
  }
  /// Converts epoch time to mission time
  /// - Parameter epochTime: Epoch time in nanoseconds
  /// - Returns: Mission time in nanoseconds
  public func convertToMissionTime(epochTime: Int) -> Int {
    return epochTime - missionStartTime
  }
  /// Converts sim time to epoch time
  /// - Parameter simTime: Sim time in nanoseconds
  /// - Returns: Epoch time in nanoseconds
  public func convertToEpochTime(simTime: Int) -> Int {
    return simTime + simEpochDifference
  }
  /// Converts sim time to mission time
  /// - Parameter simTime: Sim time in nanoseconds
  /// - Returns: Mission time in nanoseconds
  public func convertToMissionTime(simTime: Int) -> Int {
    return convertToEpochTime(simTime: simTime) - missionStartTime
  }

  /// Converts epoch time to sim time
  /// - Parameter epochTime: Epoch time in nanoseconds
  /// - Returns: Sim time in nanoseconds
  public func convertToSimTime(epochTime: Int) -> Int {
    return epochTime - simEpochDifference
  }

  /// Converts mission time to sim time
  /// - Parameter missionTime: Mission time in nanoseconds
  /// - Returns: Sim time in nanoseconds
  public func convertToSimTime(missionTime: Int) -> Int {
    return convertToSimTime(epochTime: convertToEpochTime(missionTime: missionTime))
  }

  /// Converts sim time to UNIX time
  /// - Parameter simTime: Sim time in nanoseconds
  /// - Returns: UNIX time in nanoseconds
  public func convertToUnixTime(simTime: Int) -> Int {
    return convertToUnixTime(epochTime: convertToEpochTime(simTime: simTime))
  }
  /// Converts mission time to UNIX time
  /// - Parameter missionTime: Mission time in nanoseconds
  /// - Returns: UNIX time in nanoseconds
  public func convertToUnixTime(missionTime: Int) -> Int {
    return convertToUnixTime(epochTime: convertToEpochTime(missionTime: missionTime))
  }
  /// Converts epoch time to UNIX time
  /// - Parameter epochTime: Epoch time in nanoseconds
  /// - Returns: UNIX time in nanoseconds
  public func convertToUnixTime(epochTime: Int) -> Int {
    return epochTime + epochStartTime
  }

  /// Converts UNIX time to epoch time
  /// - Parameter unixTime: Unix time in nanoseconds
  /// - Returns: Epoch time in nanoseconds
  public func convertToEpochTime(unixTime: Int) -> Int {
    return unixTime - epochStartTime
  }

  /// Converts UNIX time to JD
  ///
  /// The marvelous thing is that UNIX time is 86400 secs per day independent of leap seconds.
  /// So the conversion is very simple in the end.
  /// - Parameter unixTime: Unix time in nanoseconds
  /// - Returns: Julian date
  public func convertToJD(unixTime: Int) -> Double {
    return Double(unixTime) / 86400_000_000_000.0 + UNIX_EPOCH_IN_JD
  }
  /// Converts epoch time to JD
  /// - Parameter epochTime: Epoch time in nanoseconds
  /// - Returns: Julian date
  public func convertToJD(epochTime: Int) -> Double {
    return convertToJD(unixTime: convertToUnixTime(epochTime: epochTime))
  }
  /// Converts mission time to JD
  /// - Parameter missionTime: Mission time in nanoseconds
  /// - Returns: Julian date
  public func convertToJD(missionTime: Int) -> Double {
    return convertToJD(unixTime: convertToUnixTime(missionTime: missionTime))
  }
  /// Converts sim time to JD
  /// - Parameter simTime: Sim time in nanoseconds
  /// - Returns: Julian date
  public func convertToJD(simTime: Int) -> Double {
    return convertToJD(unixTime: convertToUnixTime(simTime: simTime))
  }

  public func getTime(base: TimeBase) -> Int {
    switch base {
    case .EpochTime:
      return epochTime
    case .MissionTime:
      return missionTime
    case .SimTime:
      return simTime
    case .UnixTime:
      return unixTime
    }
  }

  public func convertToCalendarDate(epochTime: Int) -> Date {
    let unixTime = convertToUnixTime(epochTime: epochTime)
    let interval = Double(unixTime)/1000000000.0
    return Date(timeIntervalSince1970: interval)
  }

  public func convertToCalendarDate(simTime: Int) -> Date {
    let unixTime = convertToUnixTime(simTime: epochTime)
    let interval = Double(unixTime)/1000000000.0
    return Date(timeIntervalSince1970: interval)
  }
  public func convertToCalendarDate(missionTime: Int) -> Date {
    let unixTime = convertToUnixTime(missionTime: epochTime)
    let interval = Double(unixTime)/1000000000.0
    return Date(timeIntervalSince1970: interval)
  }
  public func convertToCalendarDate(unixTime: Int) -> Date {
    let interval = Double(unixTime)/1000000000.0
    return Date(timeIntervalSince1970: interval)
  }

}
