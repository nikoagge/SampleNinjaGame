//
//  GameScene.swift
//  NinjaGame
//
//  Created by Nikolas on 9/4/20.
//  Copyright © 2020 Nikolas Aggelidis. All rights reserved.
//


import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
   
    //MARK: - Properties
    
    var ground: SKSpriteNode!
    var player: SKSpriteNode!
    var cameraNode = SKCameraNode()
    var obstacles: [SKSpriteNode] = []
    var coin: SKSpriteNode!
    
    //This is to move the camera. Camera move with speed 450pt per seconds.
    var cameraMovePointPerSecond: CGFloat = 450.0
    
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    
    var isTime: CGFloat = 3.0
    
    //These properties help player to jump.
    var onGround = true
    var velocityY: CGFloat = 0.0
    var gravity: CGFloat = 0.6
    var playerPosY: CGFloat = 0.0
    
    var numScore: Int = 0
    var gameOver = false
    var life: Int = 3
    
    var lifeNodes: [SKSpriteNode] = []
    var scoreLabel = SKLabelNode(fontNamed: "Krungthep")
    var coinIcon: SKSpriteNode!
    
    var pauseNode: SKSpriteNode!
    var containerNode = SKNode()
    
    var soundCoin = SKAction.playSoundFileNamed("coin.mp3")
    var soundJump = SKAction.playSoundFileNamed("jump.wav")
    var soundCollision = SKAction.playSoundFileNamed("collision.wav")
    
    //Add playable area for scene and camera playable area.
    var playableRect: CGRect {
        
        let ratio: CGFloat
        
        //nativeBounds: The bounding rectangle of the physical screen, measured in pixels.
        switch UIScreen.main.nativeBounds.height {
            
        //If case is iPhone X set ratio equal 2.16, another case set ratio equal 16/9.
        case 2688, 1792, 2436:
            ratio = 2.16
            
        default:
            ratio = 16/9
        }
        
        let playableHeight = size.width / ratio
        let playableMargin = (size.height - playableHeight) / 2.0
        
        return CGRect(x: 0.0, y: playableMargin, width: size.width, height: playableHeight)
    }
    
    var cameraRect: CGRect {
        
        let width = playableRect.width
        let height = playableRect.height
        //Calculate the display position of the camera.
        let x = cameraNode.position.x - size.width/2.0 + (size.width - width)/2.0
        let y = cameraNode.position.y - size.height/2.0 + (size.height - height)/2.0
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    //MARK: - Systems
    
    override func didMove(to spriteKitView: SKView) {
        
        setupNodes()
        
        SKTAudio.sharedInstance().playBGMusic("backgroundMusic.mp3")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        
        let node = atPoint(touch.location(in: self))
        
        if node.name == "Pause" {
            
            if isPaused { return }
            
            createPanel()
            
            lastUpdateTime = 0.0
            dt = 0.0
            isPaused = true
        } else if node.name == "Resume" {
            
            containerNode.removeFromParent() //Removes the receing node from its parent.
            isPaused = false
        } else if node.name == "Quit" {
            
            let scene = MainMenu(size: size)
            scene.scaleMode = scaleMode
            
            view?.presentScene(scene, transition: .doorsCloseVertical(withDuration: 0.8))
        } else {
            
            //Player jumps to height of 25pt
            if !isPaused {
                       
                if onGround {
                           
                    onGround = false
                    velocityY = -25.0
                    
                    run(soundJump)
                }
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if velocityY < -12.5 {
            
            velocityY = 12.5
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //If last update time greater than 0 then current time subtract last update time.
        if lastUpdateTime > 0 {
            
            dt = currentTime - lastUpdateTime
        } else {
            
            dt = 0
        }
        
        lastUpdateTime = currentTime
        //This is the time the camera moves.
        print(dt)
        moveCamera()
        movePlayer()
        
        velocityY += gravity
        player.position.y -= velocityY
        
        if player.position.y < playerPosY {
            
            player.position.y = playerPosY
            velocityY = 0.0
            onGround = true
        }
        
        if gameOver {
            
            let scene = GameOver(size: size)
            scene.scaleMode = scaleMode
            
            view?.presentScene(scene, transition: .doorsCloseVertical(withDuration: 0.8))
        }
        
        boundCheckPlayer()
    }
}




//MARK: - Configurations

extension GameScene {
    
    
    func setupNodes() {
        
        createBackGround()
        createGround()
        createPlayer()
        setupObstacles()
        spawnObstacles()
        setupCamera()
        setupCoin()
        spawnCoin()
        setupPhysics()
        setupLife()
        setupScore()
        setupPause()
    }
    
    
    func createBackGround() {
        
        for i in 0...2 {
            
            let backGround = SKSpriteNode(imageNamed: "background")
            backGround.name = "BackGround"
            
            //The default anchorPoint value of scene is (0,0) and default anchorPoint value of node is (0.5, 0.5).
            
            //Set the value of anchorPoint to (0,0) and position to (0,0), to position the background in the center of the screen.
            backGround.anchorPoint = .zero
            backGround.position = CGPoint(x: CGFloat(i)*backGround.frame.width, y: 0.0)
            backGround.zPosition = -1.0
            
            addChild(backGround)
        }
    }
    
    
    func createGround() {
        
        for i in 0...2 {
            
            ground = SKSpriteNode(imageNamed: "ground")
            ground.name = "Ground"
            ground.anchorPoint = .zero
            ground.zPosition = 1.0
            ground.position = CGPoint(x: CGFloat(i)*ground.frame.width, y: 0.0)
            
            //Add physicsBody for Ground node.
            //physicsBody: The physics body associated with the node.
            ground.physicsBody = SKPhysicsBody.init(rectangleOf: ground.size) //Creates a rectangular physics body centered on owning's center node
            ground.physicsBody?.isDynamic = false //A boolean value indicating if the physics body is moved by the physics simulation.
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground //A mask that defines which categories the physics body belongs to.
            
            addChild(ground)
        }
    }
    
    
    func createPlayer() {
        
        player = SKSpriteNode(imageNamed: "ninja")
        player.name = "Player"
        //Set the xScale and yScale properties of the node.
        player.setScale(0.85)
        player.zPosition = 5.0
        player.position = CGPoint(x: frame.width/2.0 - 100.0, y: ground.frame.height + player.frame.height)
        
        //Add physicsBody for the Player node.
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2.0)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.restitution = 0.0 //restitution: the bounciness of the physics body
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Block | PhysicsCategory.Obstacle | PhysicsCategory.Coin //A mask that defines which categories of physics bodies cause intersection notifications with this physics body.
        
        //Get current position of player.
        playerPosY = player.position.y
        
        addChild(player)
    }
    
    
    func setupCamera() {
        
        addChild(cameraNode)
        
        camera = cameraNode
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
    }
    
    
    func moveCamera() {
        
        let amountToMove = CGPoint(x: cameraMovePointPerSecond * CGFloat(dt), y: 0.0)
        //s = v * t formula
        cameraNode.position += amountToMove
        
        //Background
        enumerateChildNodes(withName: "BackGround") { (node, _) in
            
            let node = node as! SKSpriteNode
            
            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                
                node.position = CGPoint(x: node.position.x + node.frame.width*2.0, y: node.position.y)
            }
        }
        
        //Ground
        enumerateChildNodes(withName: "Ground") { (node, _) in
            
            let node = node as! SKSpriteNode
            
            if node.position.x + node.frame.width < self.cameraRect.origin.x {
                
                node.position = CGPoint(x: node.position.x + node.frame.width*2.0, y: node.position.y)
            }
        }
    }
    
    
    func movePlayer() {
        
        let amountToMove = cameraMovePointPerSecond * CGFloat(dt)
        let rotate = CGFloat(1).degreesToRadians() * amountToMove/2.5
        //Rotate player
        
        //The height of the node, relative to its parent.
        player.zPosition -= rotate
        player.position.x += amountToMove
    }
    
    
    func setupObstacles() {
        
        //Block node and Obstacle node will display randomly
        
        for i in 1...3 {
            
            let sprite = SKSpriteNode(imageNamed: "block-\(i)")
            sprite.name = "Block"
            
            obstacles.append(sprite)
        }
        
        for i in 1...2 {
            
            let sprite = SKSpriteNode(imageNamed: "obstacle-\(i)")
            sprite.name = "Obstacle"
            
            obstacles.append(sprite)
        }
        
        let index = Int(arc4random_uniform(UInt32(obstacles.count - 1)))
        let sprite = obstacles[index].copy() as! SKSpriteNode
        sprite.setScale(0.85)
        sprite.zPosition = 5.0
        sprite.position = CGPoint(x: cameraRect.maxX + sprite.frame.width/2.0, y: ground.frame.height + sprite.frame.height/2.0)
        
        //Add physicsBody for Obstacles node.
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = false
        
        if sprite.name == "Block" {
            
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.Block
        } else {
            
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
        }
        
        sprite.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
        addChild(sprite)
        
        //Remove after a while when not in use.
        sprite.run(.sequence([.wait(forDuration: 10.0),
                           .removeFromParent()
        ]))
    }
    
    
    //Spawn nodes
    func spawnObstacles() {
        
        let random = Double(CGFloat.random(min: 1.5, max: isTime))
        
        run(.repeatForever(.sequence([.wait(forDuration: random),
             .run { [weak self] in
                
                self?.setupObstacles()
            }
        ])))
        
        run(.repeatForever(.sequence([.wait(forDuration: 5.0),
             .run {
                
                self.isTime -= 0.01
                
                if self.isTime <= 1.5 {
                    
                    self.isTime = 1.5
                }
            }
        ])))
    }
    
    
    func setupCoin() {
        
        coin = SKSpriteNode(imageNamed: "coin-1")
        coin.name = "Coin"
        coin.zPosition = 20.0
        coin.setScale(0.85)
        
        let coinHeight = coin.frame.height
       
        let random = CGFloat.random(min: -coinHeight, max: coinHeight*2.0)
        
        coin.position = CGPoint(x: cameraRect.maxX + coin.frame.width, y: size.height/2.0 + random)
        
        //Add physicsBody for the coin node.
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width/2.0)
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = false
        coin.physicsBody?.categoryBitMask = PhysicsCategory.Coin
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        
        addChild(coin)
        
        coin.run(.sequence([.wait(forDuration: 15.0), .removeFromParent()]))
        
        //Add textures for coin
        var textures: [SKTexture] = []
        
        for i in 1...6 {
            
            textures.append(SKTexture(imageNamed: "coin-\(i)"))
        }
        
        coin.run(.repeatForever(.animate(withNormalTextures: textures, timePerFrame: 0.083)))
    }
    
    
    func spawnCoin() {
        
        let random = CGFloat.random(min: 2.5, max: 6.0)
        
        run(.repeatForever(.sequence([.wait(forDuration: TimeInterval(random)),
             .run { [weak self] in
                
                self?.setupCoin()
            }
        ])))
    }
    
    
    func setupPhysics() {
         
         //physicsWorld: The physics simulation associated with the scene.
         physicsWorld.contactDelegate = self //A delegate that is called when two physics bodies come in contact with each other.
     }
    
    
    func setupLife() {
        
        let node1 = SKSpriteNode(imageNamed: "life-on")
        let node2 = SKSpriteNode(imageNamed: "life-on")
        let node3 = SKSpriteNode(imageNamed: "life-on")
        
        setupLifePos(node1, i: 1.0, j: 0.0)
        setupLifePos(node2, i: 2.0, j: 8.0)
        setupLifePos(node3, i: 3.0, j: 16.0)
        
        lifeNodes.append(node1)
        lifeNodes.append(node2)
        lifeNodes.append(node3)
    }
    
    
    func setupLifePos(_ node: SKSpriteNode, i: CGFloat, j: CGFloat) {
        
        let width = playableRect.width
        let height = playableRect.height
        
        node.setScale(0.5)
        node.zPosition = 50.0
        node.position = CGPoint(x: -width/2.0 + node.frame.width*i + j - 15.0, y: height/2.0 - node.frame.height/2.0)
    }
    
    
    func setupScore() {
        
        //Icon
        coinIcon = SKSpriteNode(imageNamed: "coin-1")
        coinIcon.zPosition = 50.0
        coinIcon.position = CGPoint(x: -playableRect.width/2.0 + coinIcon.frame.width, y: playableRect.height/2.0 - lifeNodes[0].frame.height - coinIcon.frame.height/2.0)
        
        cameraNode.addChild(coinIcon)
        
        //Score label
        scoreLabel.text = "\(numScore)"
        scoreLabel.fontSize = 60.0
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.zPosition = 50.0
        scoreLabel.position = CGPoint(x: -playableRect.width/2.0 + coinIcon.frame.width*2.0 - 10.0, y: coinIcon.position.y + coinIcon.frame.height/2.0 - 8.0)
        
        cameraNode.addChild(scoreLabel)
    }
    
    
    func setupGameOver() {
        
        life -= 1
        
        if life <= 0 {
            
            life = 0
        }
        
        lifeNodes[life].texture = SKTexture(imageNamed: "life-off")
        
        if life <= 0 && !gameOver {
            
            gameOver = true
        }
    }
    
    
    func setupPause() {
        
        pauseNode = SKSpriteNode(imageNamed: "pause")
        pauseNode.setScale(0.5)
        pauseNode.zPosition = 50.0
        pauseNode.name = "Pause"
        pauseNode.position = CGPoint(x: playableRect.width/2.0 - pauseNode.frame.width/2.0 - 30.0, y: playableRect.height/2.0 - pauseNode.frame.height/2.0 - 10.0)
        
        cameraNode.addChild(pauseNode)
    }
    
    
    func createPanel() {
        
        cameraNode.addChild(containerNode)
        
        let panel = SKSpriteNode(imageNamed: "panel")
        panel.zPosition = 60.0
        panel.position = .zero
        
        containerNode.addChild(panel)
        
        let resume = SKSpriteNode(imageNamed: "resume")
        resume.zPosition = 70.0
        resume.name = "Resume"
        resume.setScale(0.7)
        resume.position = CGPoint(x: -panel.frame.width/2.0 + resume.frame.width*1.5, y: 0.0)
        
        panel.addChild(resume)
        
        let quit = SKSpriteNode(imageNamed: "back")
        quit.zPosition = 70.0
        quit.name = "Quit"
        quit.setScale(0.7)
        quit.position = CGPoint(x: panel.frame.width/2.0 - quit.frame.width*1.5, y: 0.0)
        
        panel.addChild(quit)
    }
    
    
    //Check that the player touches the screen border.
    func boundCheckPlayer() {
        
        let bottomLeft = CGPoint(x: cameraRect.minX, y: cameraRect.minY)
        
        if player.position.x <= bottomLeft.x {
            
            player.position.x = bottomLeft.x
            
            lifeNodes.forEach { ($0.texture = SKTexture(imageNamed: "life-off"))
                
                numScore = 0
                scoreLabel.text = "\(numScore)"
                gameOver = true
            }
        }
    }
}




//MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    
    
    //Called when two bodies start to contact each other
    func didBegin(_ contact: SKPhysicsContact) {
        
        let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        switch other.categoryBitMask {
            
        case PhysicsCategory.Block:
            cameraMovePointPerSecond += 150.0 //Increasing the movement speed of the camera.
            
            numScore -= 1
            
            if numScore <= 0 {
                
                numScore = 0
            }
            
            scoreLabel.text = "\(numScore)"
            
            run(soundCollision)
            
        case PhysicsCategory.Obstacle:
            setupGameOver()
            
        case PhysicsCategory.Coin:
            if let node = other.node {
                
                node.removeFromParent()
                
                numScore += 1
                
                scoreLabel.text = "\(numScore)"
                
                if numScore % 5  == 0 {
                    
                    cameraMovePointPerSecond += 100.0
                }
                
                let highScore = ScoreGenerator.sharedInstance.getHighScore()
                
                if numScore > highScore {
                    
                    ScoreGenerator.sharedInstance.setHighScore(numScore)
                    ScoreGenerator.sharedInstance.setScore(highScore)
                }
                
                run(soundCoin)
            }
            
        default:
            break
        }
    }
}
