//
//  Invader.swift
//  Space Battle
//
//  Created by toanct on 7/17/18.
//  Copyright © 2018 toanct. All rights reserved.
//
import SpriteKit
import UIKit

class Invader: SKSpriteNode {
    var invaderRow = 0
    var invaderColumn = 0
    
    init() {
        let texture = SKTexture(imageNamed: "invader1")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        self.name = "invader"
        self.physicsBody =
            SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Invader
        self.physicsBody?.contactTestBitMask = CollisionCategories.PlayerBullet | CollisionCategories.Player
        self.physicsBody?.collisionBitMask = 0x0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func fireBullet(scene: SKScene){
        
    }
}
