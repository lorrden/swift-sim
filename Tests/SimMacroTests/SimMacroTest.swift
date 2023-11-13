//
//  SimMacroTest.swift
//  
//
//  Created by Mattias Holm on 2023-11-06.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SimMacroLibrary)
import SimMacroLibrary

let testMacros: [String: Macro.Type] = [
  "model": ModelMacro.self,
  "input": InputMacro.self,
  "output": OutputMacro.self,
  "field": FieldMacro.self,
]
#endif

final class SimMacroTest: XCTestCase {
  func testModelMacro() throws {
    #if canImport(SimMacroLibrary)
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
    #if canImport(SimMacroLibrary)
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
    #if canImport(SimMacroLibrary)
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
    #if canImport(SimMacroLibrary)
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
