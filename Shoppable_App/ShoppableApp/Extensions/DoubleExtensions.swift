//
//  DoubleExtensions.swift
//
//
//  Created by Cristina Dobson
//


import Foundation


extension Double {
  
  
  // MARK: - Double to Currency String
  
  // Format a double to a currency format
  func toCurrencyFormat() -> String {
    
    let currency = Locale.current.currency?.identifier
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currency
    formatter.maximumFractionDigits = 2
    
    return formatter.string(from: NSNumber(value: self))!
  }
  
  
  // MARK: - Multiply Double by Int
  
  // Multiply the price by the product count
  func byItemCount(_ count: Int) -> Double {
    return self * Double(count)
  }
  
}
