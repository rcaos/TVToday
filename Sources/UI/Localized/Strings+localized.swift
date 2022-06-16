//
//  Strings+localized.swift
//  
//
//  Created by Jeans Ruiz on 13/06/22.
//

import Foundation
import Shared

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

private func lprojFileNameForLanguageCode(_ locale: Locale) -> String {
  return Language(rawValue: locale.languageCode ?? "en")?.rawValue ?? "en"
}
