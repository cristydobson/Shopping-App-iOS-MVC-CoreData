//
//  ProductPageVcCheckmark.swift
//
//
//  Created by Cristina Dobson
//


import UIKit


// Checkmark Animation

extension ProductPageViewController {
  
  
  /*
   Animate a checkmark on the 'Add To Cart' button
   as feedback to the user
   */
  
  // MARK: - Setup the Checkmark animation

  func setupCheckmarkAnimation() {
    checkmark = CheckmarkView()
    let checkmarkHeight = addToCartButton.frame.height-4
    let checkMarkRect = CGRect(
      x: 0, y: 0,
      width: checkmarkHeight, height: checkmarkHeight)
    
    checkmark.setupAnimation(
      frame: checkMarkRect,
      animatedLayerColor: .white,
      strokeWidth: 4,
      animated: true
    )
    
    // Add the checkmark to its container view
    checkmarkBGView.addSubview(self.checkmark)
    
    setupCheckmarkDependentUI()
    animateCheckmark()
  }
  
  
  // MARK: - Prepare AddToCart button
  
  func setupCheckmarkDependentUI() {
    
    // Remove the text from the 'Add To Cart' button
    setupAddToCartButton(isEnabled: false)
  }
  
  
  // MARK: - Animate Checkmark

  func animateCheckmark() {
    
    checkmark.animate(duration: 0.2) { finished in
      
      if finished {
        
        // The UI must be accessed through the main thread
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          
          // Remove the checkmark after it's done animating
          self.checkmark.removeFromSuperview()
          self.checkmark = nil
          
          // Return the Add To Cart button back to normal
          self.setupAddToCartButton(isEnabled: true)
          
          // Remove the blurred background view
          self.blurView.hideAnimatedAsBlur(withDuration: 0.1, delay: 0)
        }
        
      }
    }
    
  }
  
}
