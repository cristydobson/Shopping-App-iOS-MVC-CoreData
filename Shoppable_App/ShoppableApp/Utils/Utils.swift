/*
 Utils.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/20/23.
 
 Contains extensions to use throughout the app for:
 - Double
 - UIColor
 - UIView
 - String
 
 */

import Foundation
import UIKit

//MARK: - Double extension
extension Double {
  //Format a double to a currency format
  func toCurrencyFormat(in currency: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currency
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSNumber(value: self))!
  }
}


//MARK: - UIColor extension
extension UIColor {
  //Support custom colors for dark and light themes
  static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
    return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
  }
  
  //Custom gray color
  static let imageBorderGray = UIColor(red: 209/255, green: 209/255,
                                       blue: 209/255, alpha: 1)
}


//MARK: - UIView extension
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

extension String {
  
  //Add style to a currency string
  func toCurrencyAttributedString(with fontSize: CGFloat) -> NSMutableAttributedString {
    
    let postfixRegex = #"[0-9a-zA-Z\t]{2,6}+$"#
    let attributedPriceString = NSMutableAttributedString(string: self)

    var component: Range<String.Index>?
    component = self.range(
      of: postfixRegex,
      options: .regularExpression
    )

    attributedPriceString.setAttributes(
      [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize,
                                                      weight: .black)],
      range: NSRange(location: 0, length: self.count)
    )
    
    let postfixAttr = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize-8,
                                                     weight: .bold),
      NSAttributedString.Key.baselineOffset: 10
    ] as [NSAttributedString.Key : Any]

    if let postfixComp = component {
      let postfix = String(self[postfixComp])
      attributedPriceString.setAttributes(
        postfixAttr,
        range: NSRange(location: (self.count-1)-postfix.count,
                       length: postfix.count+1))
    }
    
    return attributedPriceString
  }
  
  //Add style to any string
  func toStyledString(with fontSize: CGFloat, and fontWeight: UIFont.Weight) -> NSAttributedString {
    
    let attributedString = NSMutableAttributedString(string: self)
    let attributedStringKey = [
      NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize,
                                                     weight: fontWeight)
    ]
    attributedString.setAttributes(
      attributedStringKey,
      range: NSRange(location: 0, length: self.count))
    
    return attributedString
  }
  
  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
}
