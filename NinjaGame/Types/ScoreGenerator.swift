//
//  ScoreGenerator.swift
//  NinjaGame
//
//  Created by Nikolas on 12/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import Foundation


class ScoreGenerator {
    
    
    static let sharedInstance = ScoreGenerator()
    
    
    private init() {
        
    }
    
    
    static let keyHighScore = "keyHighScore"
    static let keyScore = "keyScore"
    
    
    func setScore(_ score: Int) {
        
        UserDefaults.standard.set(score, forKey: ScoreGenerator.keyScore)
    }
    
    
    func getScore() -> Int {
        
        return UserDefaults.standard.integer(forKey: ScoreGenerator.keyScore)
    }
    
    
    func setHighScore(_ highScore: Int) {
           
           UserDefaults.standard.set(highScore, forKey: ScoreGenerator.keyHighScore)
       }
       
       
       func getHighScore() -> Int {
           
           return UserDefaults.standard.integer(forKey: ScoreGenerator.keyHighScore)
       }
}
