//
//  DoubleExtensions.swift
//  ShoppableApp
//
//  Created on 2/2/23.
//

import Foundation

extension Double {
  
  //Format a double to a currency format
  func toCurrencyFormat(in currency: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currency
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSNumber(value: self))!
  }
  
  //Multiply the price by the product count
  func byItemCount(_ count: Int) -> Double {
    return self * Double(count)
  }
  
}
