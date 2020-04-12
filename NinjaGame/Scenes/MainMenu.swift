//
//  MainMenu.swift
//  NinjaGame
//
//  Created by Nikolas on 12/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import SpriteKit


class MainMenu: SKScene {
    
    
    //MARK: - Properties
    
    var containerNode: SKSpriteNode!
    
    
    //MARK: - Systems
    
    override func didMove(to view: SKView) {
        
        setupBG()
        setupGrounds()
        setupNodes()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let node = atPoint(touch.location(in: self))
        
        if node.name == "Play" {
            
            let scene = GameScene(size: size)
            scene.scaleMode = scaleMode
            
            view?.presentScene(scene, transition: .doorsOpenVertical(withDuration: 0.3))
        } else if node.name == "HighScore" {
            
            setupPanel()
        } else if node.name == "Setting" {
            
            setupSetting()
        } else if node.name == "Container" {
            
            containerNode.removeFromParent()
        } else if node.name == "Music" {
            
            let node = node as! SKSpriteNode
            
            SKTAudio.musicEnabled = !SKTAudio.musicEnabled
            
            node.texture = SKTexture(imageNamed: SKTAudio.musicEnabled ? "musicOn" : "musicOff")
        } else if node.name == "Effect" {
            
            let node = node as! SKSpriteNode
            
            effectEnabled = !effectEnabled
            
            node.texture = SKTexture(imageNamed: effectEnabled ? "effectOn" : "effectOff")
        }
    }
}




//MARK: - Configurations

extension MainMenu {
    
    
    func setupBG() {
        
        let bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.anchorPoint = .zero
        bgNode.position = .zero
        
        addChild(bgNode)
    }
    
    
    func setupGrounds() {
        
        for i in 0...2 {
            
            let groundNode = SKSpriteNode(imageNamed: "ground")
            groundNode.name = "Ground"
            groundNode.anchorPoint = .zero
            groundNode.zPosition = 1.0
            groundNode.position = CGPoint(x: -CGFloat(i)*groundNode.frame.width, y: 0.0)
        }
    }
    
    
    func moveGrounds() {
        
        enumerateChildNodes(withName: "Ground") { (node, _) in
            
            let node = node as! SKSpriteNode
            node.position.x -= 8.0
            
            if node.position.x < -self.frame.width {
                
                node.position.x += node.frame.width*2.0
            }
        }
    }
    
    
    func setupNodes() {
        
        let play = SKSpriteNode(imageNamed: "play")
        play.name = "Play"
        play.setScale(0.85)
        play.zPosition = 10.0
        play.position = CGPoint(x: size.width/2.0, y: size.height/2.0 + play.frame.height + 50.0)
        
        addChild(play)
        
        let highScore = SKSpriteNode(imageNamed: "highscore")
        highScore.name = "HighScore"
        highScore.setScale(0.85)
        highScore.zPosition = 10.0
        highScore.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        
        addChild(highScore)
        
        let setting = SKSpriteNode(imageNamed: "setting")
        setting.name = "setting"
        setting.setScale(0.85)
        setting.zPosition = 10.0
        setting.position = CGPoint(x: size.width/2.0, y: size.height/2.0 - setting.size.height - 50.0)
        
        addChild(setting)
    }
    
    
    func setupPanel() {
        
        setupContainer()
        
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.setScale(1.5)
        panel.zPosition = 20.0
        panel.position = .zero
        
        containerNode.addChild(panel)
        
        //HighScore
        let x = -panel.frame.width/2.0 + 250.0
        
        let highScoreLabel = SKLabelNode(fontNamed: "Krungthep")
        highScoreLabel.text = "HighScore: \(ScoreGenerator.sharedInstance.getHighScore())"
        highScoreLabel.horizontalAlignmentMode = .left
        highScoreLabel.fontSize = 80.0
        highScoreLabel.zPosition = 25.0
        highScoreLabel.position = CGPoint(x: x, y: highScoreLabel.frame.height/2.0 - 30.0)
        
        panel.addChild(highScoreLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Krungthep")
         scoreLabel.text = "ScoreLabel: \(ScoreGenerator.sharedInstance.getScore())"
               scoreLabel.horizontalAlignmentMode = .left
               scoreLabel.fontSize = 80.0
               scoreLabel.zPosition = 25.0
               scoreLabel.position = CGPoint(x: x, y: -scoreLabel.frame.height/2.0 - 30.0)
        
        panel.addChild(scoreLabel)
    }
    
    
    func setupContainer() {
        
        containerNode = SKSpriteNode()
        containerNode.name = "Container"
        containerNode.zPosition = 15.0
        containerNode.color = .clear
        containerNode.size = size
        containerNode.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        
        addChild(containerNode)
    }
    
    
    func setupSetting() {
        
        setupContainer()
        
        //Panel
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.setScale(1.5)
        panel.zPosition = 20.0
        panel.position = .zero
        
        containerNode.addChild(panel)
        
        //Music
        let music = SKSpriteNode(imageNamed: SKTAudio.musicEnabled ? "musicOn" : "musicOff") //musicOn-true, musicOff-false
        music.name = "Music"
        music.setScale(0.7)
        music.zPosition = 25.0
        music.position = CGPoint(x: -music.frame.width - 50.0, y: 0.0)
        
        panel.addChild(music)
        
        //Sound
        let effect = SKSpriteNode(imageNamed: effectEnabled ? "effectOn" : "effectOff") //effectOn-true, effectOff-false
        effect.name = "Effect"
        effect.setScale(0.7)
        effect.zPosition = 25.0
        effect.position = CGPoint(x: music.frame.width + 50.0, y: 0.0)
        
        panel.addChild(effect)
    }
}
