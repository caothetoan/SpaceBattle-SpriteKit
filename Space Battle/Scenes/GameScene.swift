//
//  GameScene.swift
//  Space Battle
//
//  Created by toanct on 7/16/18.
//  Copyright © 2018 toanct. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import UserNotifications

var invaderNum = 1
struct CollisionCategories{
    static let Invader : UInt32 = 0x1 << 0
    static let Player: UInt32 = 0x1 << 1
    static let InvaderBullet: UInt32 = 0x1 << 2
    static let PlayerBullet: UInt32 = 0x1 << 3
    static let EdgeBody: UInt32 = 0x1 << 4
}
struct CMAcceleration {
    var x: Double
    var y: Double
    var z: Double
    
}

class GameScene: SKScene {
    
    let rowsOfInvaders = 4
    var invaderSpeed = 2
    let leftBounds = CGFloat(30)
    var rightBounds = CGFloat(0)
    var invadersWhoCanFire:[Invader] = [Invader]()
    let player:Player = Player()
    let maxLevels = 3
    var isPlayerMoved:Bool = false
    
    let motionManager: CMMotionManager = CMMotionManager()
    var accelerationX: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        
        // For Debug Use only
        view.showsPhysics = false
        setUpPhysics()
        loadBackground()
        
        setupInvaders()
        setupPlayer()
        
        invokeInvaderFire()
        invokePlayerFire()
        
        setupAccelerometer()
    }
    func loadBackground() {
        backgroundColor = SKColor.black
        rightBounds = self.size.width - 30
        
    }
    
    private func loadGameinfo() {
        
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
            if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
                return
            }
            
            //let invadersPerRow = invaderNum * 2 + 1
            let theInvader = firstBody.node as! Invader
            let newInvaderRow = theInvader.invaderRow - 1
            let newInvaderColumn = theInvader.invaderColumn
            if(newInvaderRow >= 1){
                self.enumerateChildNodes(withName: "invader") { node, stop in
                    let invader = node as! Invader
                    if invader.invaderRow == newInvaderRow && invader.invaderColumn == newInvaderColumn{
                        self.invadersWhoCanFire.append(invader)
//                        stop.withMemoryRebound(to: <#T##T.Type#>, capacity: <#T##Int#>, <#T##body: (UnsafeMutablePointer<T>) throws -> Result##(UnsafeMutablePointer<T>) throws -> Result#>)
//                        stop.memory = true
                    }
                }
            }
            let invaderIndex = findIndex(array: invadersWhoCanFire,valueToFind: firstBody.node as! Invader)
            if(invaderIndex != nil){
                invadersWhoCanFire.remove(at: invaderIndex!)
            }
            theInvader.removeFromParent()
            secondBody.node?.removeFromParent()
            
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Player != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.InvaderBullet != 0)) {
            player.die()
        }
        
        if ((firstBody.categoryBitMask & CollisionCategories.Invader != 0) &&
            (secondBody.categoryBitMask & CollisionCategories.Player != 0)) {
            player.kill()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        var pos:CGPoint!
//        for touch in touches{
//            pos = touch.location(in: self)
//        }
//
//        if isPlayerMoved{
//            // If player has swiped, it will not trigger this function
//            return
//        }
        //player.fireBullet(scene: self)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let startPoint = touch.location(in: self)
            let endPoint = touch.previousLocation(in: self)
            
            // check if vine cut
            scene?.physicsWorld.enumerateBodies(alongRayStart: startPoint, end: endPoint,
                using: { (body, point, normal, stop) in
                    self.checkIfVineCutWithBody(body)
            })
            
            // produce some nice particles
            showMoveParticles(touchPosition: startPoint)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        moveInvaders()
    }
    //
    fileprivate func checkIfVineCutWithBody(_ body: SKPhysicsBody) {
      
        let node = body.node!
        
        // if it has a name it must be a vine node
        if let name = node.name {
           
            // snip the vine
            //node.removeFromParent()
            
            // fade out all nodes matching name
            enumerateChildNodes(withName: name, using: { (node, stop) in
                let fadeAway = SKAction.fadeOut(withDuration: 0.25)
                let removeNode = SKAction.removeFromParent()
                let sequence = SKAction.sequence([fadeAway, removeNode])
                node.run(sequence)
            })
            
            //player.removeAllActions()
        
        }
    }
    
    fileprivate func showMoveParticles(touchPosition: CGPoint) {
       
        player.position = touchPosition
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
    func invokePlayerFire() {
        
        let fireBullet = SKAction.run(){
            self.player.fireBullet(scene: self)
        }
        let waitToFireBullet = SKAction.wait(forDuration: 1.5)
        let invaderFire = SKAction.sequence([fireBullet,waitToFireBullet])
        let repeatForeverAction = SKAction.repeatForever(invaderFire)
        run(repeatForeverAction)
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
        
        if(invadersWhoCanFire.isEmpty){
            invaderNum += 1
            levelComplete()
        }else{
            let randomInvader = invadersWhoCanFire.randomElement()
            randomInvader.fireBullet(scene: self)
        }
        
    }
    
    func findIndex<T: Equatable>(array: [T], valueToFind: T) -> Int? {
//        for (index, value) in enumerate(array) {
        for (index, value) in array.enumerated() {
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
    
    func levelComplete(){
        if(invaderNum <= maxLevels){
            let levelCompleteScene = LevelCompleteScene(size: size)
            levelCompleteScene.scaleMode = scaleMode
            let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
            view?.presentScene(levelCompleteScene,transition: transitionType)
        } else {
            invaderNum = 1
            newGame()
        }
    }
    
    func newGame(){
        let gameOverScene = StartGameScene(size: size)
        gameOverScene.scaleMode = scaleMode
        let transitionType = SKTransition.flipHorizontal(withDuration: 0.5)
        view?.presentScene(gameOverScene,transition: transitionType)
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
