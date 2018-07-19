//
//  Bullet.swift
//  Space Battle
//
//  Created by toanct on 7/19/18.
//  Copyright © 2018 toanct. All rights reserved.
//

import UIKit
import SpriteKit

class Bullet: SKSpriteNode {
    init(imageName: String, bulletSound: String?) {
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        if(bulletSound != nil){
            run(SKAction.playSoundFileNamed(bulletSound!, waitForCompletion: false))
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
