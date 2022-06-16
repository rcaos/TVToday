//
//  Language.swift
//  
//
//  Created by Jeans Ruiz on 15/06/22.
//

/// The Languages the App supported
public enum Language: String, CaseIterable {
  case en
  case es

  public init?(languageStrings languages: [String]) {
    guard let preferedLanguage = languages.first,
          let language = Language.init(
            rawValue: String(preferedLanguage.prefix(2).lowercased())) else {
              return nil
            }

    self = language
  }
}
