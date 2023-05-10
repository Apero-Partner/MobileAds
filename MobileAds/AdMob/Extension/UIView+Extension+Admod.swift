//
//  UIView+Extension+Admod.swift
//  MobileAds
//
//  Created by ANH VU on 19/01/2022.
//

import Foundation
import UIKit

extension UIView {
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
            guard let rating = starRating?.doubleValue else {
                return nil
            }
            if rating >= 5 {
                return UIImage(named: "stars_5.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            } else if rating >= 4.5 {
                return UIImage(named: "stars_4_5.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            } else if rating >= 4 {
                return UIImage(named: "stars_4.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            } else if rating >= 3.5 {
                return UIImage(named: "stars_3_5.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
            } else {
                return nil
            }
    }
    
    enum GradientDirection {
        case left, topLeft, top, topRight, right, bottomRight, bottom, bottomLeft
        
        var point: CGPoint {
            switch self {
            case .left:
                return .init(x: 0, y: 0.5)
            case .topLeft:
                return .init(x: 0, y: 0)
            case .top:
                return .init(x: 0.5, y: 0)
            case .topRight:
                return .init(x: 1, y: 0)
            case .right:
                return .init(x: 1, y: 0.5)
            case .bottomRight:
                return .init(x: 1, y: 1)
            case .bottom:
                return .init(x: 0.5, y: 1)
            case .bottomLeft:
                return .init(x: 0, y: 1)
            }
        }
    }
    
    func gradient(startColor: UIColor = UIColor(hex: 0xE2465C), endColor: UIColor = UIColor(hex: 0xFFC370), cornerRadius: CGFloat = 0, startPoint: GradientDirection = .left, endPoint: GradientDirection = .right) {
        let gradient = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = startPoint.point
        gradient.endPoint = endPoint.point
        gradient.frame = bounds
        gradient.cornerRadius = cornerRadius
        layer.insertSublayer(gradient, at: 0)
        layer.cornerRadius = cornerRadius
    }
}

@IBDesignable
class DesignableGradient: UIView {
    @IBInspectable var startGradient: UIColor = .white
    @IBInspectable var endGradient: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor().gradientColor(bounds: self.bounds, colorStart: startGradient, colorEnd: endGradient, isHorizontalMode: true)
    }
    
}
@IBDesignable
class DesignableGradientButton: UIButton {
    @IBInspectable var startGradient: UIColor = .white
    @IBInspectable var endGradient: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor().gradientColor(bounds: self.bounds, colorStart: startGradient, colorEnd: endGradient, isHorizontalMode: true)
    }
    
}

@IBDesignable
class DesignableGradientLablel: UILabel {
    @IBInspectable var startGradient: UIColor = .white
    @IBInspectable var endGradient: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor().gradientColor(bounds: self.bounds, colorStart: startGradient, colorEnd: endGradient, isHorizontalMode: true)
    }
    
}

@IBDesignable
class DesignableGradientLablelText: UILabel {
    @IBInspectable var startGradient: UIColor = .white
    @IBInspectable var endGradient: UIColor = .white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textColor = UIColor().gradientColor(bounds: self.bounds, colorStart: startGradient, colorEnd: endGradient, isHorizontalMode: true)
    }
    
}

