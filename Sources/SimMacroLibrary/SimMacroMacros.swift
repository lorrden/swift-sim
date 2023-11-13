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

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension VariableDeclSyntax {
  func hasAttribute(name: String) -> Bool {
    let attribs = self.attributes
    let result = attribs.contains {
      guard case let .attribute(attribute) = $0 else {
        return false
      }
      guard let identifierType = attribute.attributeName.as (IdentifierTypeSyntax.self) else {
        return false
      }
      if identifierType.name.text == name {
        return true
      }
      return false
    }
    return result
  }
}

public struct ModelMacro: MemberMacro {
  public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
    guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
      fatalError("compiler bug: the macro does not have any arguments")
    }
    
    for member in classDecl.memberBlock.members.enumerated() {
      let decl = member.element.decl
      if let varDecl = VariableDeclSyntax(decl) {
        if varDecl.hasAttribute(name: "field") {
          for singleVar in varDecl.bindings {
            guard let ips = singleVar.pattern.as(IdentifierPatternSyntax.self) else {
              fatalError("compiler bug: the macro does not have any arguments")
            }
            let varName = ips.identifier.text
            print("field \(varName)")
          }
        }
      }
    }
    return []
  }
}
public struct InputMacro: PeerMacro {
  static public func expansion(of node: AttributeSyntax,
                        providingPeersOf declaration: some DeclSyntaxProtocol,
                        in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    guard let variableDecl = declaration.as(VariableDeclSyntax.self) else {
      fatalError("compiler bug: the macro does not have any arguments")
    }

    return []
  }
}

public struct OutputMacro: PeerMacro {

  public static func expansion(of node: AttributeSyntax,
                        providingPeersOf declaration: some DeclSyntaxProtocol,
                        in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    guard let variableDecl = declaration.as(VariableDeclSyntax.self) else {
      fatalError("compiler bug: the macro does not have any arguments")
    }

    return []
  }
}

public struct FieldMacro: PeerMacro {
  public static func expansion(of node: AttributeSyntax,
                        providingPeersOf declaration: some DeclSyntaxProtocol,
                        in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    guard let variableDecl = declaration.as(VariableDeclSyntax.self) else {
      fatalError("compiler bug: the macro does not have any arguments")
    }

    return []
  }
}


@main
struct SimMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
      ModelMacro.self,
      InputMacro.self,
      OutputMacro.self,
      FieldMacro.self
    ]
}
