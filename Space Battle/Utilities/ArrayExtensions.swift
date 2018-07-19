//
//  ArrayExtensions.swift
//  Space Battle
//
//  Created by toanct on 7/19/18.
//  Copyright © 2018 toanct. All rights reserved.
//

import Foundation
import UIKit
extension Array {
    func randomElement() -> Invader {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index] as! Invader
    }
}
/*RANDOM FUNCTIONS */

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random( min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func randomInt( min: Int, max: Int) -> Int{
    //return randomInt() * (max - min ) + min
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
}
