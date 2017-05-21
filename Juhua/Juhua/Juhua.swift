//
//  Juhua.swift
//  Juhua
//
//  Created by Kyle Sun on 2017/4/21.
//  Copyright © 2017年 Kyle Sun. All rights reserved.
//

import UIKit

class Juhua: UIView {
    
    let dotCount: Int = 6
    let dotWidth: CGFloat = 6.0
    
    var dots = [CAShapeLayer]()
    let contentLayer = CALayer()
    var count = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let width = min(frame.size.width, frame.size.height)
        contentLayer.frame = CGRect(x: 0, y: 0, width: width, height: width)
        layer.addSublayer(contentLayer)
        
        for _ in 0 ..< dotCount {
            let dot = CAShapeLayer()
            dot.frame = CGRect(x: 0, y: 0, width: dotWidth, height: dotWidth)
            dot.path = UIBezierPath(ovalIn: dot.frame).cgPath
            dot.fillColor = UIColor.white.cgColor
            contentLayer.addSublayer(dot)
            dots.append(dot)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        startAnimating()
    }

    func startAnimating() {
        performRotationAnimation()
        performLoopAnimation()
    }
    
    func stopAnimating() {
        for dot in dots {
            dot.removeAllAnimations()
        }
        count = 0
//        contentLayer.removeAllAnimations()
    }
    
    func performRotationAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = HUGE
        rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        contentLayer.add(rotation, forKey: nil)
    }
    
    func performLoopAnimation() {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.duration = 2
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.delegate = self
        anim.fillMode = kCAFillModeBoth
        anim.isRemovedOnCompletion = false
        
        let width = contentLayer.frame.size.width
        let center = CGPoint(x: width / 2, y: width / 2)
        let radius: CGFloat = 60//(width - dotWidth) / 2
        for i in 0 ..< dots.count {
            let angle = -CGFloat(i) * 0.2
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: angle, endAngle: .pi * 2 + angle, clockwise: true)
            anim.path = path.cgPath
            anim.beginTime = CACurrentMediaTime() + Double(i) * 0.15
            dots[i].add(anim, forKey: nil)
        }
    }
}

extension Juhua: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !flag {
            return
        }
        count += 1
        NSLog("anim %@ count %d", anim, count)
        if count % dots.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.performLoopAnimation()
            }
        }
    }
}
