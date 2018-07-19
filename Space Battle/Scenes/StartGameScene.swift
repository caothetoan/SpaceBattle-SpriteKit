//
//  StartGameScene.swift
//  Space Battle
//
//  Created by toanct on 7/16/18.
//  Copyright © 2018 toanct. All rights reserved.
//

import UIKit
import SpriteKit

class StartGameScene: SKScene {

    // called immediately after the scene is presented by the view
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        
        let startGameButton = SKSpriteNode(imageNamed: "newgamebtn")
        startGameButton.position = CGPoint(x:Int(size.width/2), y:Int(size.height/2 - 100))
        startGameButton.name = "startgame"
        addChild(startGameButton)
    }
    
    // invoked when one or more fingers touch down on the screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        let touchLocation = touch?.location(in: self)
        let touchedNode = self.nodes(at: touchLocation!)
        for node in touchedNode {
            if node.name == "startgame" {
                let gameOverScene = GameScene(size: size)
                gameOverScene.scaleMode = scaleMode
                let transitionType = SKTransition.flipHorizontal(withDuration: 1.0)
                view?.presentScene(gameOverScene, transition: transitionType)
            }
        }
    }
}
