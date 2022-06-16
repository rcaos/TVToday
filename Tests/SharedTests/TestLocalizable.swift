//
//  TestLocalizable.swift
//  
//
//  Created by Jeans Ruiz on 15/06/22.
//

import XCTest
@testable import Shared
@testable import UI

class TestLocalizable: XCTestCase {

  func test_Spanish_Keys_probably_missing() throws {
    Strings.currentLocale = Locale(identifier: Language.es.rawValue)

    for key in Strings.allCases {
      XCTAssertNotEqual(key.rawValue, key.localized(), "Check this key for Spanish Localizable.String Its Probably Missing. Avoid use same key for the same description")
    }
  }

  func test_English_Keys_probably_missing() throws {
    Strings.currentLocale = Locale(identifier: Language.en.rawValue)

    for key in Strings.allCases {
      XCTAssertNotEqual(key.rawValue, key.localized(), "Check this key for English Localizable.String Its Probably Missing. Avoid use same key for the same description")
    }
  }
}
