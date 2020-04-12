//
//  SKAction+Ext.swift
//  NinjaGame
//
//  Created by Nikolas on 13/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import SpriteKit




extension SKAction {
    
    
    class func playSoundFileNamed(_ fileNamed: String) -> SKAction {
        
        if !effectEnabled { return SKAction() }
        
        return SKAction.playSoundFileNamed(fileNamed, waitForCompletion: false)
    }
}


private let keyEffect = "keyEffect"

var effectEnabled: Bool = {
    
    return !UserDefaults.standard.bool(forKey: keyEffect)
}() {
    
    didSet {
        
        let value = !effectEnabled
        
        UserDefaults.standard.set(value, forKey: keyEffect)
        
        if value {
            
            SKAction.stop()
        }
    }
}
