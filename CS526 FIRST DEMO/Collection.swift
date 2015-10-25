//
//  Collection.swift
//  CS526 FIRST DEMO
//
//  Created by User on 10/25/15.
//  Copyright © 2015 User. All rights reserved.
//

import Foundation
import SpriteKit

class Collection: SKSpriteNode {
    var content = Int(0)
    convenience init(s: String) {
        self.init(imageNamed: s)
    }
}