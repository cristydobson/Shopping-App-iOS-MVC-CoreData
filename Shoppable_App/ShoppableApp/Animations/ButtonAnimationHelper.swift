//
//  ButtonAnimationHelper.swift
//
//
//  Created by Cristina Dobson
//


import UIKit


struct ButtonAnimationHelper {
  
  // MARK: - Cell Shopping Cart button animation
  
  // Animate the Shopping Cart round cell button
  
  static func animateShoppingCartRoundButton(_ sender: UIButton) {
    
    sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    sender.isEnabled = false
    
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
        sender.transform = CGAffineTransform.identity
      },
      completion: { success in
        if success { sender.isEnabled = true }
      })
  }
  
}












