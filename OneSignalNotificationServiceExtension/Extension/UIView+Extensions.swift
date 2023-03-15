

import UIKit
import Foundation
import Toast

public extension UIView {
    
    /// SwifterSwift: Shake directions of a view.
    ///
    /// - horizontal: Shake left and right.
    /// - vertical: Shake up and down.
    enum ShakeDirection {
        /// Shake left and right.
        case horizontal
        
        /// Shake up and down.
        case vertical
    }
    
    /// SwifterSwift: Shake animations types.
    ///
    /// - linear: linear animation.
    /// - easeIn: easeIn animation.
    /// - easeOut: easeOut animation.
    /// - easeInOut: easeInOut animation.
    enum ShakeAnimationType {
        /// linear animation.
        case linear
        
        /// easeIn animation.
        case easeIn
        
        /// easeOut animation.
        case easeOut
        
        /// easeInOut animation.
        case easeInOut
    }
    
    /// SwifterSwift: Shake view.
    ///
    /// - Parameters:
    ///   - direction: shake direction (horizontal or vertical), (default is .horizontal)
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - animationType: shake animation type (default is .easeOut).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func shake(direction: ShakeDirection = .horizontal, duration: TimeInterval = 1, animationType: ShakeAnimationType = .easeOut, completion:(() -> Void)? = nil) {
        
        CATransaction.begin()
        let animation: CAKeyframeAnimation
        switch direction {
        case .horizontal:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        case .vertical:
            animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        }
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        }
        CATransaction.setCompletionBlock(completion)
        animation.duration = duration
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        CATransaction.commit()
    }
    
    /// SwifterSwift: Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func setBorder(color: UIColor, width: CGFloat, radius: CGFloat) {
        
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
    }
    
    func setBlurEffect(style: UIBlurEffect.Style) {
        
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
    
    func setShadow(scale: Bool = true, color: UIColor, offSet: CGSize, opacity: Float, radius: CGFloat) {
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offSet
        layer.opacity = opacity
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor, horizontal: Bool) {
        
        if let sublayers = layer.sublayers {
            for subLayer in sublayers {
                if subLayer is CAGradientLayer {
                    subLayer.removeFromSuperlayer()
                }
            }
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        if horizontal {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        gradientLayer.cornerRadius = layer.cornerRadius
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func circleView() {
        
        clipsToBounds = true
        if frame.size.width == frame.size.height {
            layer.cornerRadius = frame.size.width / 2
        } else {
            layer.cornerRadius = frame.size.height / 2
        }
    }
    
    // Add line to view
    func addLine(color: UIColor, width: CGFloat) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: frame.size.height - 1, width: frame.size.width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        layer.addSublayer(bottomLine)
    }
    
    // create half circle purple background
    func halfCircleView() {
        
        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: bounds.size.width / 2, y: 0), radius: bounds.size.height, startAngle: 0.0, endAngle: .pi, clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        layer.mask = circleShape
        setGradientBackground(colorOne: UIColor.Main_StartColor, colorTwo: UIColor.Main_EndColor, horizontal: true)
    }
    // show error toast
    func showError(error: String) {
        self.makeToast(error, duration: 2, position: CSToastPositionBottom)
    }
}
