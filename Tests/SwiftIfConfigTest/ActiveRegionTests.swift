//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftDiagnostics
import SwiftIfConfig
import SwiftParser
import SwiftSyntax
import SwiftSyntaxMacrosGenericTestSupport
import XCTest
import _SwiftSyntaxGenericTestSupport
import _SwiftSyntaxTestSupport

public class ActiveRegionTests: XCTestCase {
  let linuxBuildConfig = TestingBuildConfiguration(
    customConditions: ["DEBUG", "ASSERTS"],
    features: ["ParameterPacks"],
    attributes: ["available"]
  )

  func testActiveRegions() throws {
    try assertActiveCode(
      """
      4️⃣
      #if DEBUG
      0️⃣func f()
      #elseif ASSERTS
      1️⃣func g()

      #if compiler(>=8.0)
      2️⃣func h()
      #else
      3️⃣var i
      #endif
      #endif
      5️⃣token
      """,
      configuration: linuxBuildConfig,
      states: [
        "0️⃣": .active,
        "1️⃣": .inactive,
        "2️⃣": .unparsed,
        "3️⃣": .inactive,
        "4️⃣": .active,
        "5️⃣": .active,
      ]
    )
  }

  func testActiveRegionsInPostfix() throws {
    try assertActiveCode(
      """
      4️⃣a.b()
      #if DEBUG
      0️⃣.c()
      #elseif ASSERTS
      1️⃣.d()
      #if compiler(>=8.0)
      2️⃣.e()
      #else
      3️⃣.f()
      #endif
      #endif
      5️⃣.g()
      """,
      configuration: linuxBuildConfig,
      states: [
        "0️⃣": .active,
        "1️⃣": .inactive,
        "2️⃣": .unparsed,
        "3️⃣": .inactive,
        "4️⃣": .active,
        "5️⃣": .active,
      ]
    )
  }

  func testActiveRegionsWithErrors() throws {
    try assertActiveCode(
      """
      #if FOO > 10
      0️⃣class Foo {
      }
      #else
      1️⃣class Fallback {
      }
      #endif
      """,
      states: [
        "0️⃣": .unparsed,
        "1️⃣": .active,
      ]
    )
  }
}

/// Assert that the various marked positions in the source code have the
/// expected active states.
func assertActiveCode(
  _ markedSource: String,
  configuration: some BuildConfiguration = TestingBuildConfiguration(),
  states: [String: IfConfigRegionState],
  file: StaticString = #filePath,
  line: UInt = #line
) throws {
  // Pull out the markers that we'll use to dig out nodes to query.
  let (markerLocations, source) = extractMarkers(markedSource)

  var parser = Parser(source)
  let tree = SourceFileSyntax.parse(from: &parser)

  let configuredRegions = tree.configuredRegions(in: configuration)

  for (marker, location) in markerLocations {
    guard let expectedState = states[marker] else {
      XCTFail("Missing marker \(marker) in expected states", file: file, line: line)
      continue
    }

    guard let token = tree.token(at: AbsolutePosition(utf8Offset: location)) else {
      XCTFail("Unable to find token at location \(location)", file: file, line: line)
      continue
    }

    let (actualState, _) = token.isActive(in: configuration)
    XCTAssertEqual(actualState, expectedState, "isActive(in:) at marker \(marker)", file: file, line: line)

    let actualViaRegions = token.isActive(inConfiguredRegions: configuredRegions)
    XCTAssertEqual(
      actualViaRegions,
      expectedState,
      "isActive(inConfiguredRegions:) at marker \(marker)",
      file: file,
      line: line
    )
  }
}
