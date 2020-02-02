//
//  ViewController.swift
//  CurveAnimation
//
//  Created by Venkatnarayansetty, Badarinath on 2/1/20.
//  Copyright © 2020 Venkatnarayansetty, Badarinath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var button:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add To Basket", for: UIControl.State.normal)
        //button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(addToBasket(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var cartImage:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "cart")
        return imageView
    }()
    
    lazy var cardImage:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "credit_card")
        return imageView
    }()
    
    lazy var emptyCart:UIButton = {
           let button = UIButton(type: UIButton.ButtonType.system)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.setTitle("Empty Cart", for: UIControl.State.normal)
           //button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
           button.addTarget(self, action: #selector(emptyCart(_:)), for: UIControl.Event.touchUpInside)
           return button
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        [button, cartImage, cardImage, emptyCart].forEach { (view) in
            self.view.addSubview(view)
        }
        
        self.cardImage.isHidden = true
        
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.widthAnchor.constraint(equalToConstant: 200),
            self.button.heightAnchor.constraint(equalToConstant: 40),
            self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            //self.cardImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -80),
            //self.cardImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.cardImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.cardImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 150),
            self.cardImage.widthAnchor.constraint(equalToConstant: 40),
            self.cardImage.heightAnchor.constraint(equalToConstant: 40),
            
            self.cartImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.cartImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -30),
            self.cartImage.widthAnchor.constraint(equalToConstant: 40),
            self.cartImage.heightAnchor.constraint(equalToConstant: 40),
            
            self.emptyCart.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 150),
            self.emptyCart.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -20),
            self.emptyCart.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            self.emptyCart.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func addToBasket(_ sender: UIButton) {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: cardImage.center)
        bezierPath.addQuadCurve(to: cartImage.center, controlPoint: CGPoint(x: cardImage.center.x, y: cardImage.center.y))
        
        let moveAnimation = CAKeyframeAnimation(keyPath: "position")
        moveAnimation.path = bezierPath.cgPath
        moveAnimation.isRemovedOnCompletion = true
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0))
        scaleAnimation.isRemovedOnCompletion = true

        let opacityAnimation = CABasicAnimation(keyPath: "alpha")
        opacityAnimation.fromValue = NSNumber(value: 1.0)
        opacityAnimation.toValue = NSNumber(value: 0.1)
        opacityAnimation.isRemovedOnCompletion = true
        
        let animationGroup = CAAnimationGroup()
        animationGroup.delegate = self
        animationGroup.setValue("curvedAnimation", forKey: "animationType")
        animationGroup.animations = [moveAnimation,scaleAnimation, opacityAnimation ]
        animationGroup.duration = 1.0
        self.cardImage.isHidden = false
        cardImage.layer.add(animationGroup, forKey: "curvedAnimation")
    }
    
    @objc func emptyCart(_ sender: UIButton) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.repeatCount = 2
        animation.duration = 0.06
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: cartImage.center.x - 5, y: cartImage.center.y)
        animation.toValue = CGPoint(x: cartImage.center.x + 5, y: cartImage.center.y)
        cartImage.layer.add(animation, forKey: "position")
        cartImage.image = UIImage(named: "cart")
    }

}

extension ViewController : CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag && anim.value(forKey: "animationType") as? String == "curvedAnimation" {
            cartImage.image = UIImage(named: "cart_filled")
            self.cardImage.isHidden = true
        }
    }
}

