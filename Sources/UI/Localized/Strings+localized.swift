//
//  Strings+localized.swift
//  
//
//  Created by Jeans Ruiz on 13/06/22.
//

import Foundation

/// Used by Strings+Generated.swift
func localizeKey(_ key: String, _ locale: Locale) -> String {
  guard let bundle = buildBundleForLocalization(locale) else {
    return ""
  }
  return bundle.localizedString(forKey: key, value: nil, table: nil)
}

private func buildBundleForLocalization(_ locale: Locale) -> Bundle? {
  guard let pathBundle = Bundle.module.path(forResource: lprojFileNameForLanguageCode(locale), ofType: "lproj") else {
    return nil
  }
  return Bundle(path: pathBundle)
}

public func lprojFileNameForLanguageCode(_ locale: Locale) -> String {
  return Language(rawValue: locale.languageCode ?? "en")?.rawValue ?? "en"
}

// MARK: - TODO, Move, The Languages the App supported
public enum Language: String, CaseIterable {
  case en
  case es

  public init?(languageString language: String) {
    switch language.lowercased() {
    case "en": self = .en
    case "es": self = .es
    default: return nil
    }
  }

  public init?(languageStrings languages: [String]) {
    guard let preferedLanguage = languages.first,
          let language = Language.init(rawValue: String(preferedLanguage.prefix(2))) else {
            return nil
          }

    self = language
  }
}
