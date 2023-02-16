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
public let J2000_EPOCH_IN_UNIX_TIME : Int = 946728000
public let UNIX_EPOCH_IN_JD : Double = 2440587.5

public class TimeKeeper {
  public var simTime: Int = 0

  // epochStartTime tracks the start time in nanoseconds since the UNIX epoch
  public var epochStartTime: Int = J2000_EPOCH_IN_UNIX_TIME * 1000000000 // J2000 epoch by default

  private var simEpochDifference: Int = 0

  public var epochTime: Int {
    get { simTime + simEpochDifference }
    set { simEpochDifference = newValue - simTime }
  }

  // MissionTime = EpochTime – MissionStartTime
  public var missionStartTime = 0
  public var missionTime: Int {
    get { epochTime - missionStartTime }
    set { missionStartTime = epochTime - newValue }
  }

  // EpochTime = MissionTime + MissionStartTime
  public func convertToEpochTime(missionTime: Int) -> Int {
    return missionTime + missionStartTime
  }
  // MissionTime = EpochTime - MissionStartTime
  public func convertToMissionTime(epochTime: Int) -> Int {
    return epochTime - missionStartTime
  }
  // EpochTime = MissionTime + MissionStartTime
  public func convertToEpochTime(simTime: Int) -> Int {
    return simTime + simEpochDifference
  }
  // MissionTime = EpochTime - MissionStartTime
  public func convertToMissionTime(simTime: Int) -> Int {
    return convertToEpochTime(simTime: simTime) - missionStartTime
  }

  public func convertToSimTime(epochTime: Int) -> Int {
    return epochTime - simEpochDifference
  }

  // EpochTime = MissionTime + MissionStartTime
  public func convertToSimTime(missionTime: Int) -> Int {
    return convertToSimTime(epochTime: convertToEpochTime(missionTime: missionTime))
  }

  public func convertToUnixTime(simTime: Int) -> Int {
    return convertToUnixTime(epochTime: convertToEpochTime(simTime: simTime))
  }
  public func convertToUnixTime(missionTime: Int) -> Int {
    return convertToUnixTime(epochTime: convertToEpochTime(missionTime: missionTime))
  }
  public func convertToUnixTime(epochTime: Int) -> Int {
    return epochTime + epochStartTime
  }

  public func convertToEpochTime(unixTime: Int) -> Int {
    return unixTime - epochStartTime
  }

  // The marvelous thing is that UNIX time is 86400 secs per day independent of leap seconds
  public func convertToJD(unixTime: Int) -> Double {
    return Double(unixTime) / 86400_000_000_000.0 + UNIX_EPOCH_IN_JD
  }
  public func convertToJD(epochTime: Int) -> Double {
    return convertToJD(unixTime: convertToUnixTime(epochTime: epochTime))
  }
  public func convertToJD(missionTime: Int) -> Double {
    return convertToJD(unixTime: convertToUnixTime(missionTime: missionTime))
  }
  public func convertToJD(simTime: Int) -> Double {
    return convertToJD(unixTime: convertToUnixTime(simTime: simTime))
  }
}
