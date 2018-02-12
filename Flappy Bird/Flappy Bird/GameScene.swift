//
//  GameScene.swift
//  Flappy Bird
//
//  Created by Tony Coniglio on 2/8/18.
//  Copyright © 2018 Resin. All rights reserved.
//

import SpriteKit
import GameplayKit
import ObjectiveC

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var timer = Timer()
    var gameOver = false
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var score = 0
    
    enum ColliderType : UInt32 {
        
        case Bird = 1
        case Object = 2
        case Gap = 4
        
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        setupGame()
        
    }
    
    func setupGame() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo:  nil, repeats: true)
        
        //background
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        let moveBgAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 7)
        let shiftBackground = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy:0), duration: 0)
        let imNotMovingInertia = SKAction.repeatForever(SKAction.sequence([moveBgAnimation, shiftBackground]))
        var  i : CGFloat = 0
        
        while i < 3 {
            
            let xMarksTheSpot : CGFloat = bgTexture.size().width * i
            let yMarksTheSpot : CGFloat = self.frame.midY
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: xMarksTheSpot, y: yMarksTheSpot)
            bg.size.height = self.frame.height
            bg.run(imNotMovingInertia)
            self.addChild(bg)
            
            i += 1
            
            bg.zPosition = -1
            
        }
        
        //bird
        
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.run(makeBirdFlap)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        bird.physicsBody!.isDynamic = false
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Bird.rawValue
        self.addChild(bird)
        
        //floor
        
        let ground = SKNode()
        let groundSize = CGSize(width: self.frame.width, height: 1)
        ground.position = CGPoint(x: self.frame.maxX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: groundSize)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        self.addChild(ground)
        
        //score label
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.color = UIColor.black
        scoreLabel.fontColor = UIColor.white
        scoreLabel.text = "Score: \(score)"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height/2 - 70)
        scoreLabel.zPosition = 2
        self.addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
            let birdTexture = SKTexture(imageNamed: "flappy1.png")
            bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
            let birdMovement = CGVector(dx: 0, dy: 100)
            bird.physicsBody!.isDynamic = true
            bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody!.applyImpulse(birdMovement)
        } else {
            gameOver = false
            score = 0
            self.speed = 1
            self.removeAllChildren()
            setupGame()
        }
    }
    
    @objc func makePipes(){
        
        //pipes
        
        let gapHeight = bird.size.height * 4
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
        let movePipe = SKAction.move(by: CGVector(dx: -2 * self.frame.width,dy: 0), duration: TimeInterval(self.frame.width / 100))
        
        let xCoordinate = self.frame.midX + self.frame.width
        
        let pipeA = SKTexture(imageNamed: "pipe1.png")
        let pipeATexture = SKSpriteNode(texture: pipeA)
        pipeATexture.position = CGPoint(x: xCoordinate, y: self.frame.midY + pipeA.size().height / 2 + (gapHeight / 2 + pipeOffset))
        self.addChild(pipeATexture)
        pipeATexture.physicsBody = SKPhysicsBody(rectangleOf: pipeA.size())
        pipeATexture.physicsBody?.isDynamic = false
        pipeATexture.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipeATexture.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipeATexture.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        pipeATexture.run(movePipe)
        
        let pipeB = SKTexture(imageNamed: "pipe2.png")
        let pipeBTexture = SKSpriteNode(texture: pipeB)
        pipeATexture.position = CGPoint(x: xCoordinate, y: self.frame.midY - pipeB.size().height / 2 - (gapHeight / 2 + pipeOffset))
        self.addChild(pipeBTexture)
        pipeBTexture.physicsBody = SKPhysicsBody(rectangleOf: pipeB.size())
        pipeBTexture.physicsBody?.isDynamic = false
        pipeBTexture.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipeBTexture.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipeBTexture.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        pipeBTexture.run(movePipe)
        
        let gap = SKNode()
        gap.position = CGPoint(x: xCoordinate, y: self.frame.midY + pipeOffset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeA.size().width, height:  gapHeight))
        gap.physicsBody?.isDynamic = false
        gap.run(movePipe)
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        self.addChild(gap)
    }
    
    //contact
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameOver == false {
            if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
                print("Add one to score")
                score += 1
            } else {
                print("Game Over")
                self.speed = 0
                timer.invalidate()
                gameOver = true
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over! Tap to play again."
                gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)
                gameOverLabel.zPosition = 2
                self.addChild(gameOverLabel)
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
