//
//  JuhuaView.swift
//  Juhua
//
//  Created by Kyle Sun on 2017/4/21.
//  Copyright © 2017年 Kyle Sun. All rights reserved.
//

import UIKit

class JuhuaView: UIView {
    
    let kDotCount: Int = 6
    let kDotWidth: CGFloat = 10.0
    
    var dots = [CAShapeLayer]()
    let contentView = UIView()
    var count = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(contentView)
        for _ in 0 ..< kDotCount {
            let dot = CAShapeLayer()
            dot.frame = CGRect(x: 0, y: 0, width: kDotWidth, height: kDotWidth)
            dot.path = UIBezierPath(ovalIn: dot.frame).cgPath
            dot.fillColor = UIColor.cyan.cgColor
            contentView.layer.addSublayer(dot)
            dots.append(dot)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = min(frame.size.width, frame.size.height)
        contentView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        performRotationAnimation()
        performLoopAnimation()
    }

    func startAnimating() {
        stopAnimating()
//        performRotationAnimation()
//        performLoopAnimation()
    }
    
    func stopAnimating() {
        for dot in dots {
            dot.removeAllAnimations()
        }
        contentView.layer.removeAllAnimations()
        count = 0
    }
    
    func performRotationAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = HUGE
        rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        contentView.layer.add(rotation, forKey: nil)
    }
    
    func performLoopAnimation() {
        let anim = CAKeyframeAnimation(keyPath: "position")
        anim.duration = 2
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.delegate = self
        anim.fillMode = kCAFillModeBoth
        anim.isRemovedOnCompletion = false
        
        let width = contentView.frame.size.width
        let center = CGPoint(x: width / 2, y: width / 2)
        let radius = (width - kDotWidth) / 2
        for i in 0 ..< dots.count {
            let angle = -CGFloat(i) * 0.2
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: angle, endAngle: .pi * 2 + angle, clockwise: true)
            anim.path = path.cgPath
            anim.beginTime = CACurrentMediaTime() + Double(i) * 0.15
            dots[i].add(anim, forKey: nil)
        }
    }
}

extension JuhuaView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if !flag {
            return
        }
        count += 1
        NSLog("count %d", count)
        if count % dots.count == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performLoopAnimation()
            }
        }
    }
}
