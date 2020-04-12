//
//  Types.swift
//  NinjaGame
//
//  Created by Nikolas on 12/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


struct PhysicsCategory {
    
    
    //The following values correspond to 2^0, 2^1, 2^2, 2^3, 2^4
    static let Player: UInt32 = 0b1 //1
    static let Block: UInt32 = 0b10 //2
    static let Obstacle: UInt32 = 0b100 //4
    static let Ground: UInt32 = 0b1000 //8
    static let Coin: UInt32 = 0b10000 //16
}
