//
//  SimMacroTest.swift
//  
//
//  Created by Mattias Holm on 2023-11-06.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SimulatorMacroLibrary)
import SimulatorMacroLibrary

let testMacros: [String: Macro.Type] = [
  "model": ModelMacro.self,
  "input": InputMacro.self,
  "output": OutputMacro.self,
  "field": FieldMacro.self,
]
#endif

final class SimMacroTest: XCTestCase {
  func testModelMacro() throws {
    #if canImport(SimulatorMacroLibrary)
      assertMacroExpansion(
        """
        @model
        class Foo {
          @field var x, y: Int
        }
        """,
        expandedSource:
        """

        class Foo {
          var x, y: Int
        }
        """,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testInputMacro() throws {
    #if canImport(SimulatorMacroLibrary)
      assertMacroExpansion(
        """
        @input
        var foo: Int
        """,
        expandedSource:
        """

        var foo: Int
        """,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testOutputMacro() throws {
    #if canImport(SimulatorMacroLibrary)
      assertMacroExpansion(
        """
        @output
        var foo: Int
        """,
        expandedSource:
        """

        var foo: Int
        """,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testFieldMacro() throws {
    #if canImport(SimulatorMacroLibrary)
      assertMacroExpansion(
        """
        @field
        var foo: Int
        """,
        expandedSource:
        """

        var foo: Int
        """,
        macros: testMacros
      )
    #else
      throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }
}
