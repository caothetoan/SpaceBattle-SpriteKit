//
//  InvaderBullet.swift
//  Space Battle
//
//  Created by toanct on 7/19/18.
//  Copyright © 2018 toanct. All rights reserved.
//

import UIKit
import SpriteKit

class InvaderBullet: Bullet {

    override init(imageName: String, bulletSound:String?){
        super.init(imageName: imageName, bulletSound: bulletSound)
        
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.InvaderBullet
        self.physicsBody?.contactTestBitMask = CollisionCategories.Player
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func fireBullet(scene: SKScene){
        let bullet = InvaderBullet(imageName: "laser",bulletSound: nil)
        bullet.position.x = self.position.x
        bullet.position.y = self.position.y - self.size.height/2
        scene.addChild(bullet)
        let moveBulletAction = SKAction.move(to: CGPoint(x:self.position.x,y: 0 - bullet.size.height), duration: 2.0)
        let removeBulletAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveBulletAction,removeBulletAction]))
    }
    
   
}
