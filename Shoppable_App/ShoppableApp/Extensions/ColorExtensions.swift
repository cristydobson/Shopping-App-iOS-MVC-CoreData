//
//  ColorExtensions.swift
//  ShoppableApp
//
//  Created on 2/2/23.
//

import Foundation
import UIKit

extension UIColor {
  
  //Support custom colors for dark and light themes
  static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
    return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
  }
  
  //Custom gray color
  static let imageBorderGray = UIColor(red: 209/255, green: 209/255,
                                       blue: 209/255, alpha: 1)
}

