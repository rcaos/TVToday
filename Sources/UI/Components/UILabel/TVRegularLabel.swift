//
//  TVRegularLabel.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public class TVRegularLabel: UILabel {

  public var tvSize: FontSize! = .normal {
    didSet {
      configureView()
    }
  }

  public var tvFont: Font! = .sanFrancisco {
    didSet {
      font = tvFont.of(type: .regular, with: tvSize)
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
    font = tvFont.of(type: .regular, with: tvSize)
  }
}
