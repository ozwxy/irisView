//
//  IrisView.swift
//  iris
//
//  Created by Kodai Ozawa on 2017/10/05.
//  Copyright © 2017 Kodai Ozawa. All rights reserved.
//

import UIKit

/// Beautiful view for picking colors.
open class IrisView: UIView {
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Properties
    
    /// An optional array of `UIColor` objects used to draw the color palettes. If the value is `nil`, the `fillColor`
    /// will be drawn `white`.
    open var colors: [UIColor]? {
        didSet {
            angle = .pi * 2 / CGFloat(colors?.count ?? 1)
            do { try updatePalette() }
            catch { colors = [.white] }
        }
    }
    
    /// An optional cgFloat object userd to et the palettes' radius. If the value is `nil`,
    /// that radius will be set 100.
    open var radius: CGFloat = 0 {
        didSet {
            radiusClicked = radius * transformRatio
            do { try updatePalette() }
            catch {}
        }
    }
    
    open var transformRatio: CGFloat = 1.35 {
        didSet {
            radiusClicked = radius * transformRatio
            do { try updatePalette() }
            catch {}
        }
    }
    
    open var palettes: [CAShapeLayer] = [CAShapeLayer]()
    
    open var isShadowed: Bool = false
    
    // MARK: - Animation
    
    open func detect(_ touches: Set<UITouch>, with event: UIEvent?, end: Bool = false) {
        if end {
            for (i, palette) in palettes.enumerated() {
                palette.add(sAnimations[i], forKey: nil)
                nonShade(palette)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    palette.removeAllAnimations()
                }
            }
            tappedObject = nil
            return
        }
        if let touch = touches.first {
            guard let superView = self.superview else { return }
            let superPoint = touch.location(in: superView)
            let point = touch.location(in: self)
            let hitView = superView.hitTest(superPoint, with: event)
            
            for (i, palette) in palettes.enumerated() {
                if palette.path!.contains(point) && self == hitView {
                    tappedObject = (i, palette)
                    palette.add(bAnimations[i], forKey: nil)
                    shade(palette)
                } else {
                    palette.add(sAnimations[i], forKey: nil)
                    nonShade(palette)
                }
            }
        }
    }
    
    open func detected() throws -> (Int, CAShapeLayer) {
        guard let obj = tappedObject else { throw error.NotFound }
        
        return obj
    }
    
    public enum Object {
        case index
        case layer
    }
    
    // MARK: - Private
    
    fileprivate var radiusClicked: CGFloat = 0
    
    fileprivate var angle: CGFloat = 0
    
    fileprivate var bAnimations:  [CASpringAnimation] = [CASpringAnimation]()
    
    fileprivate var sAnimations: [CASpringAnimation] = [CASpringAnimation]()
    
    fileprivate var tappedObject: (Int, CAShapeLayer)?
    
    fileprivate func createPath(_ i: Int, with radius: CGFloat) -> CGPath {
        let start: CGFloat = 0.0 + angle * CGFloat(i)
        let end:   CGFloat = start + angle
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: frame.width/2, y: frame.height/2))
        path.addArc(withCenter: CGPoint(x: frame.width/2, y: frame.height/2),
                    radius: radius,
                    startAngle: start,
                    endAngle: end,
                    clockwise: true)
        
        return path.cgPath
    }
    
    fileprivate func sizeAnimation(_ i: Int, to radius: CGFloat) -> CASpringAnimation {
        let path = createPath(i, with: radius)
        let animation = CASpringAnimation(keyPath: "path")
        animation.duration = 0.25
        animation.toValue  = path
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        return animation
    }
    
    fileprivate func updatePalette() throws {
        guard let colors = colors else { throw error.NotFound }
        if palettes.count > 0 {
            palettes    = []
            bAnimations = []
            sAnimations = []
        }
        
        for (i, color) in colors.enumerated() {
            let layer = palette(i, color: color)
            let bAnimation = sizeAnimation(i, to: radiusClicked)
            let sAnimation = sizeAnimation(i, to: radius)
            palettes.append(layer)
            bAnimations.append(bAnimation)
            sAnimations.append(sAnimation)
            self.layer.addSublayer(palettes[i])
        }
    }
    
    fileprivate func palette(_ i: Int, color: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path  = createPath(i, with: radius)
        layer.path = path
        layer.fillColor = color.cgColor
        layer.zPosition = 1000 - radius
        
        return layer
    }
    
    fileprivate func shade(_ palette: CAShapeLayer) {
        if isShadowed {
            palette.shadowOpacity = 0.9
            palette.shadowRadius  = 54
            palette.shadowOffset  = CGSize(width: 10, height: 10)
            palette.shadowColor   = UIColor.black.cgColor
            palette.shadowPath    = palette.path
            palette.rasterizationScale = UIScreen.main.scale
        }
    }
    
    fileprivate func nonShade(_ palette: CAShapeLayer) {
        if isShadowed {
            palette.shadowOpacity = 0.0
            palette.shadowRadius  = 0
            palette.shadowOffset  = CGSize(width: 0, height: 0)
            palette.shadowColor   = UIColor.clear.cgColor
            palette.rasterizationScale = 0
        }
    }
    
    // MARK: - Errors
    
    fileprivate enum error: Error {
        case NotFound
    }
    
}

