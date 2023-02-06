//
//  ViewExtensions.swift
//  ShoppableApp
//
//  Created on 2/2/23.
//

import Foundation
import UIKit

extension UIView {
  
  //Show a background Blur view
  func showAnimatedAsBlur(withDuration duration: TimeInterval, delay: TimeInterval) {
    if self.isHidden {
      self.isHidden = false
      self.isUserInteractionEnabled = true
      
      UIView.animate(
        withDuration: duration,
        delay: delay,
        options: .curveEaseInOut,
        animations: {
          self.alpha = 1
        },
        completion: nil)
    }
  }
  
  //Hide a background Blur view
  func hideAnimatedAsBlur(withDuration duration: TimeInterval, delay: TimeInterval) {
    if !self.isHidden {
      UIView.animate(
        withDuration: duration,
        delay: 0,
        options: .curveEaseOut,
        animations: {
          self.alpha = 0
        })
      { finished in
        if finished {
          self.isHidden = true
          self.isUserInteractionEnabled = false
        }
      }
    }
  }
  
  //Add a drop down shadow to a view
  func addDropShadow(opacity: Float, radius: CGFloat, offset: CGSize, lightColor: UIColor, darkColor: UIColor) {
    self.layer.masksToBounds = false
    self.layer.shadowOpacity = opacity
    self.layer.shadowRadius = radius
    self.layer.shadowOffset = offset
    self.layer.shadowColor = UIColor.dynamicColor(
      light: lightColor,
      dark: darkColor).cgColor
  }
  
  //Customize the border of a view
  func addBorderStyle(borderWidth: CGFloat, borderColor: UIColor) {
    layer.borderWidth = borderWidth
    layer.borderColor = borderColor.cgColor
  }
  
  //Add corner radius to a view
  func addCornerRadius(_ cornerRadius: CGFloat) {
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = true
  }
  
}

