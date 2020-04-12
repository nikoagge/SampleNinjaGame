//
//  GameViewController.swift
//  NinjaGame
//
//  Created by Nikolas on 9/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let gameScene = MainMenu(size: CGSize(width: 2048, height: 1536))
        gameScene.scaleMode = .aspectFill
        
        let spriteKitView = view as! SKView
        spriteKitView.showsFPS = true
        spriteKitView.showsNodeCount = true
        spriteKitView.showsPhysics = true
        spriteKitView.ignoresSiblingOrder = true
        spriteKitView.presentScene(gameScene)
    }


    override var prefersStatusBarHidden: Bool {
        
        return true
    }
}
