//
//  TVBoldLabel.swift
//  UI
//
//  Created by Jeans Ruiz on 7/14/20.
//

import UIKit

public class TVBoldLabel: UILabel {

  public var tvSize: FontSize! = .normal {
    didSet {
      configureView()
    }
  }

  public var tvFont: Font! = .sanFrancisco {
    didSet {
      font = tvFont.of(type: .bold, with: tvSize)
    }
  }

  public var tvColor: UIColor = Colors.electricBlue.color {
    didSet {
      textColor = tvColor
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    configureView()
  }

  private func configureView() {
    font = tvFont.of(type: .bold, with: tvSize)
    textColor = tvColor
  }
}
