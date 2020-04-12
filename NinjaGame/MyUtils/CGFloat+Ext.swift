//
//  CGFloat+Ext.swift
//  NinjaGame
//
//  Created by Nikolas on 10/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import CoreGraphics


//π radians = 180˚
public let π = CGFloat.pi


extension CGFloat {
    
    
    func radiansToDegrees() -> CGFloat {
        
        return self * 180.0 / π
    }
    
    
    func degreesToRadians() -> CGFloat {
        
        return self * π / 180.0
    }
    
    
    //Create methods to get random values
    static func random() -> CGFloat {
        
        //Return 0 or 1
        return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
    }
    
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        
        assert(min < max)
        
        //Return max or min
        return CGFloat.random() * (max - min) + min
    }
}
