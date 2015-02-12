//
//  ViewController.swift
//  MonkeyPinch
//
//  Created by chenzhipeng on 15/2/12.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
    
        let translation = sender.translationInView(self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: self.view)
        
        // 1
        /// Figure out the length of the velocity vector
        let velocity = sender.velocityInView(self.view)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200
        println("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
        
        // 2
        /// if the length is <200, then decrease the base speed, otherwise increase it
        let slideFactor = 0.1 * slideMultiplier     // Increase for more of a slide
        // 3
        /// Calculate a final point based on the velocity and the slideFactor
        var finalPoint = CGPoint(x:sender.view!.center.x + (velocity.x * slideFactor), y:sender.view!.center.y + (velocity.y * slideFactor))
        
        // 4
        /// Make sure the final point is within the view's bounds
        finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
        finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
        
        // 5
        /**
        *  Animate the view to the final resting place
        */
        UIView.animateWithDuration(Double(slideFactor * 2),
            delay: 0,
            options: .CurveEaseOut,
            animations: { () -> Void in
                sender.view!.center = finalPoint
        }, completion: nil)
    }
    
    @IBAction func handlePinch(sender: UIPinchGestureRecognizer) {
        sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale = 1
    }
    
    @IBAction func handleRotate(sender: UIRotationGestureRecognizer) {
        sender.view!.transform = CGAffineTransformRotate(sender.view!.transform, sender.rotation)
        sender.rotation = 0
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

