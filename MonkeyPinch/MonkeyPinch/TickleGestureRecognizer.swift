//
//  TickleGestureRecognizer.swift
//  MonkeyPinch
//
//  Created by chenzhipeng on 15/2/12.
//  Copyright (c) 2015年 chenzhipeng. All rights reserved.
//

import UIKit

class TickleGestureRecognizer: UIGestureRecognizer {
    
    // 1
    let requiredTickles = 2
    let distanceForTickleGesture: CGFloat = 25.0
    
    // 2
    enum Direction: Int {
        case DirectionUnKnown = 0
        case DirectionLeft
        case DirectionRight
    }
    
    // 3
    var tickleCount: Int = 0
    var curTickleStart: CGPoint = CGPointZero
    var lastDirection: Direction = .DirectionUnKnown
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject() as UITouch
        self.curTickleStart = touch.locationInView(self.view)
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        let touch = touches.anyObject() as UITouch
        let ticklePoint = touch.locationInView(self.view)
        
        let moveAmt = ticklePoint.x - curTickleStart.x
        var curDirection: Direction
        if moveAmt < 0 {
            curDirection = .DirectionLeft
        } else {
            curDirection = .DirectionRight
        }
        
        if abs(moveAmt) < self.distanceForTickleGesture {
            return
        }
        
        if self.lastDirection == .DirectionUnKnown || (self.lastDirection == .DirectionLeft && curDirection == .DirectionRight) || (self.lastDirection == .DirectionRight && curDirection == .DirectionLeft) {
            self.tickleCount++
            self.curTickleStart = ticklePoint
            self.lastDirection = curDirection
            
            if self.state == .Possible && self.tickleCount > self.requiredTickles {
                self.state = .Ended
            }
        }
        
        
    }
    override func reset() {
        self.tickleCount = 0
        self.curTickleStart = CGPointZero
        self.lastDirection = .DirectionUnKnown
        if self.state == .Possible {
            self.state = .Failed
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        self.reset()
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.reset()
    }
    
}
