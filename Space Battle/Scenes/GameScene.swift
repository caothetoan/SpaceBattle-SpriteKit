//
//  GameScene.swift
//  Space Battle
//
//  Created by toanct on 7/16/18.
//  Copyright © 2018 toanct. All rights reserved.
//

import SpriteKit
import GameplayKit
import UserNotifications

var invaderNum = 1
struct CollisionCategories{
    static let Invader : UInt32 = 0x1 << 0
    static let Player: UInt32 = 0x1 << 1
    static let InvaderBullet: UInt32 = 0x1 << 2
    static let PlayerBullet: UInt32 = 0x1 << 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let rowsOfInvaders = 4
    var invaderSpeed = 2
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(0)
    var invadersWhoCanFire:[Invader] = [Invader]()
    let player:Player = Player()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor.black
        rightBounds = self.size.width - 30
        
        setupInvaders()
        setupPlayer()
        
        invokeInvaderFire()
    }
    
    func didBegin( _ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.PlayerBullet != 0)){
            NSLog("Invader and Player Bullet Conatact")
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0)) {
            NSLog("Player and Invader Bullet Contact")
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Player != 0)) {
            NSLog("Invader and Player Collision Contact")
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.fireBullet(scene: self)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveInvaders()
    }
    
    //
    func setupInvaders(){
        var invaderRow: Int = 0;
        var invaderColumn: Int = 0;
        let numberOfInvaders: Int = invaderNum * 2 + 1
        for i in 1...rowsOfInvaders {
            invaderRow = i
            for j in 1...numberOfInvaders {
                invaderColumn = j
                let tempInvader:Invader = Invader()
                let invaderHalfWidth:CGFloat = tempInvader.size.width/2
                let xPositionStart:CGFloat = size.width/2 - invaderHalfWidth - (CGFloat(invaderNum) * tempInvader.size.width) + CGFloat(10)
                tempInvader.position = CGPoint(x:xPositionStart + ((tempInvader.size.width+CGFloat(10))*(CGFloat(j-1))), y:CGFloat(self.size.height - CGFloat(i) * 46))
                tempInvader.invaderRow = invaderRow
                tempInvader.invaderColumn = invaderColumn
                addChild(tempInvader)
                if(i == rowsOfInvaders){
                    invadersWhoCanFire.append(tempInvader)
                }
            }
        }
    }
    //
    func setupPlayer(){
        
        player.position = CGPoint(x:CGFloat(self.frame.width/2), y:player.size.height/2 + 10)
        addChild(player)
    }
    //
    func moveInvaders(){
        var changeDirection = false
        enumerateChildNodes(withName: "invader") { node, stop in
            let invader = node as! SKSpriteNode
            let invaderHalfWidth = invader.size.width/2
            invader.position.x -= CGFloat(self.invaderSpeed)
            if(invader.position.x > self.rightBounds - invaderHalfWidth || invader.position.x < self.leftBounds + invaderHalfWidth){
                changeDirection = true
            }
            
        }
        
        if(changeDirection == true){
            self.invaderSpeed *= -1
            self.enumerateChildNodes(withName: "invader") { node, stop in
                let invader = node as! SKSpriteNode
                invader.position.y -= CGFloat(46) //46
            }
            changeDirection = false
        }
        
    }
    //
    func invokeInvaderFire(){
        let fireBullet = SKAction.run(){
            self.fireInvaderBullet()
        }
        let waitToFireInvaderBullet = SKAction.wait(forDuration: 1.5)
        let invaderFire = SKAction.sequence([fireBullet,waitToFireInvaderBullet])
        let repeatForeverAction = SKAction.repeatForever(invaderFire)
        run(repeatForeverAction)
    }
    
    func fireInvaderBullet(){
        let randomInvader = invadersWhoCanFire.randomElement()
        randomInvader.fireBullet(scene: self)
    }
}

extension GameScene {
    func scheduleNotificationWith(body: String, intervalInSeconds: TimeInterval, badgeNumber: Int) {
        // 1
        let localNotification = UNMutableNotificationContent()
        
        // 2
        localNotification.body = body
        localNotification.sound = UNNotificationSound.default()
        localNotification.badge = badgeNumber as NSNumber?
        
        // 3
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: intervalInSeconds, repeats: false)
        let request = UNNotificationRequest.init(identifier: body, content: localNotification, trigger: trigger)
        
        // 4
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }

}
