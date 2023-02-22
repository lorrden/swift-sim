//
//  File.swift
//  
//
//  Created by Mattias Holm on 2023-02-22.
//

import Foundation

public class Resolver {
  weak var sim: Simulator!
  init(sim: Simulator)
  {
    self.sim = sim
  }

  public func resolve(absolute: String) -> Model? {
    let components = absolute.split(separator: "/")

    var cursor: Model? = sim.models[String(components[0])]

    for component in components[1...] {
      if component == ".." {
        cursor = cursor?.parent
      } else if component != "." {
        // For non self references go up
        cursor = cursor?.children[String(component)]
      }
    }

    return cursor
  }

  public func resolve(relative: String, source: Model) -> Model? {
    let components = relative.split(separator: "/")
    var cursor: Model? = source
    var atRoot: Bool = false

    for component in components {
      if component == ".." {
        cursor = cursor?.parent
        if atRoot {
          atRoot = false
        } else if cursor == nil  {
          atRoot = true
        }
      } else if component != "." {
        // For non self references go up
        if atRoot {
          cursor = sim.models[String(component)]
          atRoot = false
        } else {
          cursor = cursor?.children[String(component)]
        }
      }
    }

    return cursor
  }

}
