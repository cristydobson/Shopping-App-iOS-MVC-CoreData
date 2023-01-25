/*
 CheckmarkView.swift
 ShoppableApp
 
 Created by Cristina Dobson on 1/24/23.
 
 Animate a Checkmark on the Add To Cart button in
 ProductPageViewController
 */

import UIKit

class CheckmarkView: UIView, CAAnimationDelegate {

  //MARK: - Properties
  
  //Private properties to customize the animation
  private var initialLayerColor: UIColor = UIColor.green {
    didSet {
      initialLayer.strokeColor = initialLayerColor.cgColor
    }
  }
  
  private var animatedLayerColor: UIColor = UIColor.green {
    didSet {
      animatedLayer?.strokeColor = animatedLayerColor.cgColor
    }
  }
  
  private var strokeWidth: CGFloat = 8 {
    didSet {
      initialLayer.lineWidth = strokeWidth
      animatedLayer?.lineWidth = strokeWidth
    }
  }
  
  private var animated: Bool = true {
    didSet {
      if animated {
        animatedLayer = createCheckMarkLayer(
          strokeColor: animatedLayerColor,
          strokeEnd: 0
        )
        layer.addSublayer(animatedLayer!)
      }
    }
  }
  
  private lazy var initialLayer: CAShapeLayer = {
    return self.createCheckMarkLayer(
      strokeColor: self.initialLayerColor,
      strokeEnd: 1
    )
  }()
  
  private var animatedLayer: CAShapeLayer?
  
  
  //MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  //MARK: - Required Init
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  //MARK: - Animation Methods
  //Set up the initial values for the animation
  func setupAnimation(frame: CGRect, initialLayerColor: UIColor, animatedLayerColor: UIColor, strokeWidth: CGFloat, animated: Bool) {
    self.frame = frame
    self.initialLayerColor = initialLayerColor
    self.animatedLayerColor = animatedLayerColor
    self.strokeWidth = strokeWidth
    self.animated = animated
  }
  
  private func configureView() {
    backgroundColor = .clear
    layer.addSublayer(initialLayer)
  }
  
  //Perform the animation
  func animate(duration: TimeInterval = 0.6, completion: @escaping (Bool) -> Void) {
    guard let animatedLayer = animatedLayer else { return }
    
    let animation = CABasicAnimation(keyPath: AnimationKey.strokeEnd.rawValue)
    animation.delegate = self
    animation.fromValue = 0
    animation.toValue = 1
    animation.timingFunction = CAMediaTimingFunction(
      name: CAMediaTimingFunctionName.easeOut
    )
    animation.duration = duration
    animation.isRemovedOnCompletion = true
    
    animatedLayer.strokeEnd = 2
    animatedLayer.add(
      animation,
      forKey: AnimationKey.animateCheckmark.rawValue
    )
    
    completion(true)
  }

  //Draw the checkmark following a path
  private func createCheckMarkLayer(strokeColor: UIColor, strokeEnd: CGFloat) -> CAShapeLayer {
    let scale = frame.width / 100
    let centerX = frame.size.width / 2
    let centerY = frame.size.height / 2
    let sixOclock = CGFloat(Double.pi / 2)
    
    let checkmarkPath = UIBezierPath(
      arcCenter: CGPoint(x: centerX, y: centerY),
      radius: centerX,
      startAngle: sixOclock,
      endAngle: sixOclock,
      clockwise: true
    )
    checkmarkPath.move(
      to: CGPoint(x: centerX - 23 * scale,
                  y: centerY - 1 * scale)
    )
    checkmarkPath.addLine(
      to: CGPoint(x: centerX - 6 * scale,
                  y: centerY + 15.9 * scale)
    )
    checkmarkPath.addLine(
      to: CGPoint(x: centerX + 22.8 * scale,
                  y: centerY - 13.4 * scale)
    )
    
    let checkmarkLayer = CAShapeLayer()
    checkmarkLayer.fillColor = UIColor.clear.cgColor
    checkmarkLayer.lineWidth = strokeWidth
    checkmarkLayer.path = checkmarkPath.cgPath
    checkmarkLayer.strokeEnd = strokeEnd
    checkmarkLayer.strokeColor = strokeColor.cgColor
    checkmarkLayer.lineCap = CAShapeLayerLineCap.round
    checkmarkLayer.lineJoin = CAShapeLayerLineJoin.round
    
    return checkmarkLayer
  }
}


