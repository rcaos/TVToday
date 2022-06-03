//
//  Fonts.swift
//  
//
//  Created by Jeans Ruiz on 17/05/22.
//

import UIKit

extension UIFont {

  public func designed(_ design: UIFontDescriptor.SystemDesign) -> UIFont {
    return self.fontDescriptor.withDesign(design)
      .map { UIFont(descriptor: $0, size: 0) } ?? self
  }

  /// Returns a bolded version of `self`.
  public var bolded: UIFont {
    return self.fontDescriptor.withSymbolicTraits(.traitBold)
      .map { UIFont(descriptor: $0, size: 0.0) } ?? self
  }

  /// Returns a version of `self` with the desired weight.
  public func weighted(_ weight: UIFont.Weight) -> UIFont {
    let descriptor = self.fontDescriptor.addingAttributes([
      .traits: [UIFontDescriptor.TraitKey.weight: weight]
    ])
    return UIFont(descriptor: descriptor, size: 0.0)
  }

  /// Returns an italicized version of `self`.
  public var italicized: UIFont {
    return self.fontDescriptor.withSymbolicTraits(.traitItalic)
      .map { UIFont(descriptor: $0, size: 0.0) } ?? self
  }

  public static func app_largeTitle(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .largeTitle, size: size)
  }

  /// light, 28pt font, 34pt leading, 13pt tracking
  public static func app_title1(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .title1, size: size)
  }

  /// regular, 22pt font, 28pt leading, 16pt tracking
  public static func app_title2(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .title2, size: size)
  }

  /// regular, 20pt font, 24pt leading, 19pt tracking
  public static func app_title3(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .title3, size: size)
  }

  /// semi-bold, 17pt font, 22pt leading, -24pt tracking
  public static func app_headline(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .headline, size: size)
  }

  /// regular, 17pt font, 22pt leading, -24pt tracking
  public static func app_body(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .body, size: size)
  }

  /// regular, 16pt font, 21pt leading, -20pt tracking
  public static func app_callout(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .callout, size: size)
  }

  /// regular, 15pt font, 20pt leading, -16pt tracking
  public static func app_subhead(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .subheadline, size: size)
  }

  /// regular, 13pt font, 18pt leading, -6pt tracking
  public static func app_footnote(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .footnote, size: size)
  }

  /// regular, 12pt font, 16pt leading, 0pt tracking
  public static func app_caption1(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .caption1, size: size)
  }

  /// regular, 11pt font, 13pt leading, 6pt tracking
  public static func app_caption2(size: CGFloat = 0) -> UIFont {
    return .preferredFont(style: .caption2, size: size)
  }

  private static func preferredFont(
    style: UIFont.TextStyle,
    size: CGFloat = 0
  ) -> UIFont {
    if let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).withDesign(.default) {
      return UIFont(descriptor: descriptor, size: size)
    } else {
      return UIFont.preferredFont(forTextStyle: style, compatibleWith: .current)
    }
  }
}
