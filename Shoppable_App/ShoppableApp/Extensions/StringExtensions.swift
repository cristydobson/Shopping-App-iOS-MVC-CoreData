//
//  StringExtensions.swift
//  ShoppableApp
//
//  Created on 2/2/23.
//


import UIKit


extension String {
  
  
  // MARK: - Currency String Style
  
  // Add style to a currency string
  func toCurrencyAttributedString(with fontSize: CGFloat) -> NSMutableAttributedString {
    
    let attributedPriceString = NSMutableAttributedString(string: self)
    attributedPriceString.setAttributes(
      [
        NSAttributedString.Key.font: UIFont
          .systemFont(ofSize: fontSize, weight: .black)
      ],
      range: NSRange(location: 0, length: self.count))
    
    // Prefix & Postfix
    let regexArr = [#"^\W?"#, #"(\.|\,)\d{2}(\s\w+)?$"#]
    
    let regexFonts = [
      UIFont.systemFont(ofSize: fontSize/1.7, weight: .bold),
      UIFont.systemFont(ofSize: fontSize/2, weight: .black)
    ]
    
    let regexBaseline = [fontSize/6, fontSize/3]
    
    for i in 0..<regexArr.count {
      
      var component: Range<String.Index>?
      component = self.range(
        of: regexArr[i], options: .regularExpression)
      
      let regexAttribute = [
        NSAttributedString.Key.font: regexFonts[i],
        NSAttributedString.Key.baselineOffset: regexBaseline[i]
      ] as [NSAttributedString.Key : Any]
      
      
      if let regexComp = component {
        
        let regexString = String(self[regexComp])
        let regexLocation = i==0 ? 0 : (self.count)-regexString.count
        
        attributedPriceString.setAttributes(
          regexAttribute,
          range: NSRange(location: regexLocation,
                         length: regexString.count))
      }
      
    }
    
    return attributedPriceString
  }
  
  
  // MARK: - Add Style to any String
  
  func toStyleString(with fontSize: CGFloat, and fontWeight: UIFont.Weight) -> NSAttributedString {
    
    let attributedString = NSMutableAttributedString(string: self)
    
    let attributedStringKey = [
      NSAttributedString.Key.font: UIFont
        .systemFont(ofSize: fontSize, weight: fontWeight)
    ]
    
    attributedString.setAttributes(
      attributedStringKey,
      range: NSRange(location: 0, length: self.count))
    
    return attributedString
  }
  
  
  // MARK: - Capitalize first letter
  
  func capitalizingFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }
  
  mutating func capitalizeFirstLetter() {
    self = self.capitalizingFirstLetter()
  }
  
}
