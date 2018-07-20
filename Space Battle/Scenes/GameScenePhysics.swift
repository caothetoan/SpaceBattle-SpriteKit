//
//  GameScenePhysics.swift
//  Space Battle
//
//  Created by toanct on 7/19/18.
//  Copyright © 2018 toanct. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene : SKPhysicsContactDelegate {

    func setUpPhysics() {
        
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody?.categoryBitMask = CollisionCategories.EdgeBody
        
       
    }
    
    //
    func setupAccelerometer(){
        motionManager.accelerometerUpdateInterval = 0.2
        //        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {
        //            (accelerometerData: CMAccelerometerData!, error: NSError!) in
        //            let acceleration = accelerometerData.acceleration
        //            self.accelerationX = CGFloat(acceleration.x)
        //            } as! CMAccelerometerHandler)
    }
    
    override func didSimulatePhysics() {
        // TODO uncomment check exception accelemeter
        player.physicsBody?.velocity = CGVector(dx: accelerationX * 600, dy: 0)
    }
}
