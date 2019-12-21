//
//  String+removeWhitespaces.swift
//  NosyToucher
//
//  Created by Roland Tolnay on 19/03/2018.
//  Copyright © 2018 Roland Tolnay. All rights reserved.
//

import Foundation

extension String {
  
  func removingWhitespaces() -> String {
    return components(separatedBy: .whitespaces).joined()
  }
}
