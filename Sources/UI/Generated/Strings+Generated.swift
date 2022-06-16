// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings: String, CaseIterable {

  public static var currentLocale = Locale.current

  public func localized() -> String {
    return localizeKey(self.rawValue, Strings.currentLocale)
  }
  /// Cancel
  case accountAlertCancel = "account_alert_cancel"

  /// Sign out
  case accountAlertLogout = "account_alert_logout"

  /// Are you sure you want to Sign out?
  case accountAlertTitle = "account_alert_title"

  /// Favorites
  case accountFavoriteListTitle = "account_favorite_list_title"

  /// Watch List
  case accountFavoriteWatchListTitle = "account_favorite_watchList_title"

  /// Favorites
  case accountFavoritesCell = "account_favorites_cell"

  /// Hi
  case accountGreetings = "account_greetings"

  /// Sign out
  case accountLogout = "account_logout"

  /// Account
  case accountTitle = "account_title"

  /// Sign in with TheMovieDB
  case accountTitleDetailButton = "account_title_detail_button"

  /// Login
  case accountTitleLogin = "account_title_login"

  /// Watch List
  case accountWatchlistCell = "account_watchlist_cell"

  /// Today
  case airingTodayTabbar = "airing_today_tabbar"

  /// Today on TV
  case airingTodayTitle = "airing_today_title"

  /// Episode Guide
  case detailsEpisodeGuide = "details_episode_guide"

  /// Popular
  case popularTabbar = "popular_tabbar"

  /// Popular TV Shows
  case popularTitle = "popular_title"

  /// Search TV Show
  case searchPlaceholder = "search_placeholder"

  /// Recent Searchs
  case searchResultsRecentSearchsTitle = "search_results_recent_searchs_title"

  /// TVShows Genres
  case searchSectionGenresTitle = "search_section_genres_title"

  /// Recently TVShows Visited
  case searchSectionRecentTitle = "search_section_recent_title"

  /// Search
  case searchTabbar = "search_tabbar"

  /// Search TV Shows
  case searchTitle = "search_title"

  /// Seasons:
  case seasonsSectionTitle = "seasons_section_title"

  /// All Episodes
  case seasonsTitle = "seasons_title"

}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces
