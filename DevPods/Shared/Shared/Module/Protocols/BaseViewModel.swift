//
//  BaseViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/9/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxFlow

public protocol BaseViewModel: Stepper {
  
  associatedtype Input
  associatedtype Output
  
  var input: Input { get }
  
  var output: Output { get }
}
