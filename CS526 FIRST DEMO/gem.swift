//
//  gem.swift
//  CS526 FIRST DEMO
//
//  Created by luoyixiao on 15/10/5.
//  Copyright © 2015年 User. All rights reserved.
//

import Foundation
import SpriteKit

class Gem: SKSpriteNode {
    var colour: Int = 0
    convenience init(s: String) {
        self.init(imageNamed: s)
    }
}

