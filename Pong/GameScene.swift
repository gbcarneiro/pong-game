//
//  GameScene.swift
//  Pong
//
//  Created by MacBook on 14/07/19.
//  Copyright © 2019 Gabriel Carneiro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    
    var score = [Int]()
    
    var topLabel = SKLabelNode()
    var btmLabel = SKLabelNode()
    
    
    override func didMove(to view: SKView) {
        
        topLabel = self.childNode(withName: "topLabel") as! SKLabelNode
        btmLabel = self.childNode(withName: "btmLabel") as! SKLabelNode
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
       
        //Height of rectangles
        enemy.position.y = (self.frame.height / 2) - 50
        main.position.y = (-self.frame.height / 2) + 50
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0
        border.restitution = 1
        
        self.physicsBody = border
        
        startGame()
    
    }
    
    func startGame() {
        score = [0,0] //Main, Enemy
        btmLabel.text = "\(score[0])"
        topLabel.text = "\(score[1])"
        //applying impulse in the ball
        ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
    }
    
    func addScore(playerWhoWon: SKSpriteNode) {
        
        //Put the ball in the same point
        ball.position = CGPoint(x: 0, y: 0)
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        //add the score
        if (playerWhoWon == main) {
            score[0] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
        } else if (playerWhoWon == enemy) {
            score[1] += 1
            ball.physicsBody?.applyImpulse(CGVector(dx: -10, dy: -10))
        }
        
        btmLabel.text = "\(score[0])"
        topLabel.text = "\(score[1])"
        
    }
    
    //Moving the main
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameMode == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                } else if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            } else {
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if currentGameMode == .player2 {
                if location.y > 0 {
                    enemy.run(SKAction.moveTo(x: location.x, duration: 0.2))
                } else if location.y < 0 {
                    main.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            } else {
                main.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        //Making the enemy move
        switch currentGameMode {
        case .easy:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 1))
            break
        case .medium:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.5))
            break
        case .hard:
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
            break
        case .player2:
            break
        }
        
        //Calculate the score
        if (ball.position.y <= main.position.y - 30) {
            addScore(playerWhoWon: enemy)
        } else if (ball.position.y >= enemy.position.y + 30){
            addScore(playerWhoWon: main)
        }
        
    }
}
