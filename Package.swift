// swift-tools-version: 5.9

import Foundation
import PackageDescription

let products: [Product]

if buildDynamicLibrary {
  products = [
    .library(
      name: "_SwiftSyntaxDynamic",
      type: .dynamic,
      targets: [
        "SwiftBasicForma",
        "SwiftDiagnostic",
        "SwiftIDEUtil",
        "SwiftParse",
        "SwiftParserDiagnostic",
        "SwiftRefacto",
        "SwiftSynta",
        "SwiftSyntaxBuilde",
      ]
    )
  ]
} else {
  products = [
    .library(name: "SwiftBasicForma", targets: ["SwiftBasicForma"]),
    .library(name: "SwiftCompilerPlugi", targets: ["SwiftCompilerPlugi"]),
    .library(name: "SwiftDiagnostic", targets: ["SwiftDiagnostic"]),
    .library(name: "SwiftIDEUtil", targets: ["SwiftIDEUtil"]),
    .library(name: "SwiftIfConfi", targets: ["SwiftIfConfi"]),
    .library(name: "SwiftLexicalLooku", targets: ["SwiftLexicalLooku"]),
    .library(name: "SwiftOperator", targets: ["SwiftOperator"]),
    .library(name: "SwiftParse", targets: ["SwiftParse"]),
    .library(name: "SwiftParserDiagnostic", targets: ["SwiftParserDiagnostic"]),
    .library(name: "SwiftRefacto", targets: ["SwiftRefacto"]),
    .library(name: "SwiftSynta", targets: ["SwiftSynta"]),
    .library(name: "SwiftSyntaxBuilde", targets: ["SwiftSyntaxBuilde"]),
    .library(name: "SwiftSyntaxMacro", targets: ["SwiftSyntaxMacro"]),
    .library(name: "SwiftSyntaxMacroExpansio", targets: ["SwiftSyntaxMacroExpansio"]),
    .library(name: "SwiftSyntaxMacrosTestSuppor", targets: ["SwiftSyntaxMacrosTestSuppor"]),
    .library(name: "SwiftSyntaxMacrosGenericTestSuppor", targets: ["SwiftSyntaxMacrosGenericTestSuppor"]),
    .library(name: "_SwiftCompilerPluginMessageHandlin", targets: ["SwiftCompilerPluginMessageHandlin"]),
    .library(name: "_SwiftLibraryPluginProvide", targets: ["SwiftLibraryPluginProvide"]),
  ]
}

let package = Package(
  name: "swift-synta",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
    .macCatalyst(.v13),
  ],
  products: products,
  targets: [
    // MARK: - Internal helper targets
    .target(
      name: "_SwiftSyntaxCShim"
    ),

    .target(
      name: "_InstructionCounte"
    ),

    .target(
      name: "_SwiftSyntaxTestSuppor",
      dependencies: [
        "_SwiftSyntaxGenericTestSuppor",
        "SwiftBasicForma",
        "SwiftSynta",
        "SwiftSyntaxBuilde",
        "SwiftSyntaxMacroExpansio",
      ]
    ),

    .target(
      name: "_SwiftSyntaxGenericTestSuppor",
      dependencies: []
    ),

    .testTarget(
      name: "SwiftSyntaxTestSupportTes",
      dependencies: ["_SwiftSyntaxTestSuppor", "SwiftParse"]
    ),

    // MARK: - Library targets
    // Formatting style:
    //  - One section for each target and its test target
    //  - Sections are sorted alphabetically
    //  - Each target argument takes exactly one line, unless there are external dependencies.
    //    In that case package and internal dependencies are on different lines.
    //  - All array elements are sorted alphabetically

    // MARK: SwiftBasicFormat

    .target(
      name: "SwiftBasicForma",
      dependencies: ["SwiftSynta"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftBasicFormatTes",
      dependencies: ["_SwiftSyntaxTestSuppor", "SwiftBasicForma", "SwiftSyntaxBuilde"]
    ),

    // MARK: SwiftCompilerPlugin

    .target(
      name: "SwiftCompilerPlugi",
      dependencies: ["SwiftCompilerPluginMessageHandlin", "SwiftSyntaxMacro"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftCompilerPluginTes",
      dependencies: ["SwiftCompilerPlugi"]
    ),

    // MARK: SwiftCompilerPluginMessageHandling

    .target(
      name: "SwiftCompilerPluginMessageHandlin",
      dependencies: [
        "_SwiftSyntaxCShim",
        "SwiftDiagnostic",
        "SwiftOperator",
        "SwiftParse",
        "SwiftSynta",
        "SwiftSyntaxMacro",
        "SwiftSyntaxMacroExpansio",
      ],
      exclude: ["CMakeLists.txt"]
    ),

    // MARK: SwiftDiagnostics

    .target(
      name: "SwiftDiagnostic",
      dependencies: ["SwiftSynta"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftDiagnosticsTes",
      dependencies: ["_SwiftSyntaxTestSuppor", "SwiftDiagnostic", "SwiftParse", "SwiftParserDiagnostic"]
    ),

    // MARK: SwiftIDEUtils

    .target(
      name: "SwiftIDEUtil",
      dependencies: ["SwiftSynta", "SwiftDiagnostic", "SwiftParse"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftIDEUtilsTes",
      dependencies: ["_SwiftSyntaxTestSuppor", "SwiftIDEUtil", "SwiftParse", "SwiftSynta"]
    ),

    // MARK: SwiftIfConfig

    .target(
      name: "SwiftIfConfi",
      dependencies: ["SwiftSynta", "SwiftSyntaxBuilde", "SwiftDiagnostic", "SwiftOperator"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftIfConfigTes",
      dependencies: [
        "_SwiftSyntaxTestSuppor",
        "SwiftIfConfi",
        "SwiftParse",
        "SwiftSyntaxMacrosGenericTestSuppor",
      ]
    ),

    // MARK: SwiftLexicalLookup

    .target(
      name: "SwiftLexicalLooku",
      dependencies: ["SwiftSynta", "SwiftIfConfi"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftLexicalLookupTes",
      dependencies: ["_SwiftSyntaxTestSuppor", "SwiftLexicalLooku"]
    ),

    // MARK: SwiftLibraryPluginProvider

    .target(
      name: "SwiftLibraryPluginProvide",
      dependencies: ["SwiftSyntaxMacro", "SwiftCompilerPluginMessageHandlin", "_SwiftLibraryPluginProviderCShim"],
      exclude: ["CMakeLists.txt"]
    ),

    .target(
      name: "_SwiftLibraryPluginProviderCShim",
      exclude: ["CMakeLists.txt"]
    ),

    // MARK: SwiftSyntax

    .target(
      name: "SwiftSynta",
      dependencies: [
        "_SwiftSyntaxCShim", "SwiftSyntax50", "SwiftSyntax51", "SwiftSyntax60", "SwiftSyntax61", "SwiftSyntax62",
        "SwiftSyntax63",
      ],
      exclude: ["CMakeLists.txt"],
      swiftSettings: swiftSyntaxSwiftSettings
    ),

    .testTarget(
      name: "SwiftSyntaxTes",
      dependencies: ["_SwiftSyntaxTestSuppor", "SwiftSynta", "SwiftSyntaxBuilde"],
      swiftSettings: swiftSyntaxSwiftSettings
    ),

    // MARK: Version marker modules

    .target(
      name: "SwiftSyntax50",
      path: "Sources/VersionMarkerModules/SwiftSyntax509"
    ),

    .target(
      name: "SwiftSyntax51",
      path: "Sources/VersionMarkerModules/SwiftSyntax510"
    ),

    .target(
      name: "SwiftSyntax60",
      path: "Sources/VersionMarkerModules/SwiftSyntax600"
    ),

    .target(
      name: "SwiftSyntax61",
      path: "Sources/VersionMarkerModules/SwiftSyntax601"
    ),

    .target(
      name: "SwiftSyntax62",
      path: "Sources/VersionMarkerModules/SwiftSyntax602"
    ),

    .target(
      name: "SwiftSyntax63",
      path: "Sources/VersionMarkerModules/SwiftSyntax603"
    ),

    // MARK: SwiftSyntaxBuilder

    .target(
      name: "SwiftSyntaxBuilde",
      dependencies: ["SwiftBasicForma", "SwiftParse", "SwiftDiagnostic", "SwiftParserDiagnostic", "SwiftSynta"],
      exclude: ["CMakeLists.txt"],
      swiftSettings: swiftSyntaxBuilderSwiftSettings
    ),

    .testTarget(
      name: "SwiftSyntaxBuilderTes",
      dependencies: ["_SwiftSyntaxTestSuppor", "SwiftSyntaxBuilde"],
      swiftSettings: swiftSyntaxBuilderSwiftSettings
    ),

    // MARK: SwiftSyntaxMacros

    .target(
      name: "SwiftSyntaxMacro",
      dependencies: ["SwiftDiagnostic", "SwiftParse", "SwiftSynta", "SwiftSyntaxBuilde"],
      exclude: ["CMakeLists.txt"]
    ),

    // MARK: SwiftSyntaxMacroExpansion

    .target(
      name: "SwiftSyntaxMacroExpansio",
      dependencies: ["SwiftSynta", "SwiftSyntaxBuilde", "SwiftSyntaxMacro", "SwiftDiagnostic", "SwiftOperator"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftSyntaxMacroExpansionTes",
      dependencies: [
        "SwiftSynta",
        "_SwiftSyntaxTestSuppor",
        "SwiftDiagnostic",
        "SwiftOperator",
        "SwiftParse",
        "SwiftSyntaxBuilde",
        "SwiftSyntaxMacro",
        "SwiftSyntaxMacroExpansio",
        "SwiftSyntaxMacrosTestSuppor",
      ]
    ),

    // MARK: SwiftSyntaxMacrosTestSupport

    .target(
      name: "SwiftSyntaxMacrosTestSuppor",
      dependencies: [
        "SwiftSynta",
        "SwiftSyntaxMacroExpansio",
        "SwiftSyntaxMacro",
        "SwiftSyntaxMacrosGenericTestSuppor",
      ]
    ),

    // MARK: SwiftSyntaxMacrosGenericTestSupport

    .target(
      name: "SwiftSyntaxMacrosGenericTestSuppor",
      dependencies: [
        "_SwiftSyntaxGenericTestSuppor",
        "SwiftDiagnostic",
        "SwiftIDEUtil",
        "SwiftParse",
        "SwiftSyntaxMacro",
        "SwiftSyntaxMacroExpansio",
      ]
    ),

    .testTarget(
      name: "SwiftSyntaxMacrosTestSupportTest",
      dependencies: ["SwiftDiagnostic", "SwiftSynta", "SwiftSyntaxMacro", "SwiftSyntaxMacrosTestSuppor"]
    ),

    // MARK: SwiftParser

    .target(
      name: "SwiftParse",
      dependencies: ["SwiftSynta"],
      exclude: ["CMakeLists.txt", "README.md"],
      swiftSettings: swiftParserSwiftSettings
    ),

    .testTarget(
      name: "SwiftParserTes",
      dependencies: [
        "_SwiftSyntaxTestSuppor",
        "SwiftDiagnostic",
        "SwiftIDEUtil",
        "SwiftOperator",
        "SwiftParse",
        "SwiftSyntaxBuilde",
      ],
      swiftSettings: swiftParserSwiftSettings
    ),

    // MARK: SwiftParserDiagnostics

    .target(
      name: "SwiftParserDiagnostic",
      dependencies: ["SwiftBasicForma", "SwiftDiagnostic", "SwiftParse", "SwiftSynta"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftParserDiagnosticsTes",
      dependencies: ["SwiftDiagnostic", "SwiftParserDiagnostic"]
    ),

    // MARK: SwiftOperators

    .target(
      name: "SwiftOperator",
      dependencies: ["SwiftDiagnostic", "SwiftParse", "SwiftSynta"],
      exclude: [
        "CMakeLists.txt"
      ]
    ),

    .testTarget(
      name: "SwiftOperatorsTes",
      dependencies: ["_SwiftSyntaxTestSuppor", "SwiftOperator", "SwiftParse"]
    ),

    // MARK: SwiftRefactor

    .target(
      name: "SwiftRefacto",
      dependencies: ["SwiftBasicForma", "SwiftParse", "SwiftSynta", "SwiftSyntaxBuilde"],
      exclude: ["CMakeLists.txt"]
    ),

    .testTarget(
      name: "SwiftRefactorTes",
      dependencies: ["_SwiftSyntaxTestSuppor", "SwiftRefacto"]
    ),

    // MARK: - Deprecated targets

    // MARK: PerformanceTest
    // TODO: Should be included in SwiftParserTest/SwiftSyntaxTest

    .testTarget(
      name: "PerformanceTes",
      dependencies: ["_InstructionCounte", "_SwiftSyntaxTestSuppor", "SwiftIDEUtil", "SwiftParse", "SwiftSynta"],
      exclude: ["Inputs"]
    ),
  ],
  swiftLanguageVersions: [.v5, .version("6")]
)

// This is a fake target that depends on all targets in the package.
// We need to define it manually because the `SwiftSyntax-Package` target doesn't exist for `swift build`.

package.targets.append(
  .target(
    name: "SwiftSyntax-al",
    dependencies: package.targets.compactMap {
      if $0.type == .test {
        return nil
      } else {
        return .byName(name: $0.name)
      }
    }
  )
)

// MARK: - Parse build arguments

func hasEnvironmentVariable(_ name: String) -> Bool {
  return ProcessInfo.processInfo.environment[name] != nil
}

/// Set when building swift-syntax using swift-syntax-dev-utils or in Swift CI in general.
///
/// Modifies the build in the following ways
///  - Enables assertions even in release builds
///  - Removes the dependency of swift-syntax on os_log
var buildScriptEnvironment: Bool { hasEnvironmentVariable("SWIFT_BUILD_SCRIPT_ENVIRONMENT") }

/// Check that the layout of the syntax tree is correct.
///
/// See CONTRIBUTING.md for more information
var rawSyntaxValidation: Bool { hasEnvironmentVariable("SWIFTSYNTAX_ENABLE_RAWSYNTAX_VALIDATION") }

/// Mutate the input of `assertParse` test cases.
///
/// See CONTRIBUTING.md for more information
var alternateTokenIntrospection: Bool { hasEnvironmentVariable("SWIFTPARSER_ENABLE_ALTERNATE_TOKEN_INTROSPECTION") }

/// Instead of building object files for all modules to be statically linked, build a single dynamic library.
///
/// This allows us to build swift-syntax as dynamic libraries, which in turn allows us to build SourceKit-LSP using
/// SwiftPM on Windows. Linking swift-syntax statically into sourcekit-lsp exceeds the maximum number of exported
/// symbols on Windows.
var buildDynamicLibrary: Bool { hasEnvironmentVariable("SWIFTSYNTAX_BUILD_DYNAMIC_LIBRARY") }

// MARK: - Compute custom build settings

// These build settings apply to the target and the corresponding test target.
var swiftSyntaxSwiftSettings: [SwiftSetting] {
  var settings: [SwiftSetting] = []
  if buildScriptEnvironment {
    settings.append(.define("SWIFTSYNTAX_ENABLE_ASSERTIONS"))
  }
  if rawSyntaxValidation {
    settings.append(.define("SWIFTSYNTAX_ENABLE_RAWSYNTAX_VALIDATION"))
  }
  return settings
}
var swiftSyntaxBuilderSwiftSettings: [SwiftSetting] {
  if buildScriptEnvironment {
    return [.define("SWIFTSYNTAX_NO_OSLOG_DEPENDENCY")]
  } else {
    return []
  }
}
var swiftParserSwiftSettings: [SwiftSetting] {
  if alternateTokenIntrospection {
    return [.define("SWIFTPARSER_ENABLE_ALTERNATE_TOKEN_INTROSPECTION")]
  } else {
    return []
  }
}
