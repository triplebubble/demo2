//
//  StartGame.swift
//  CS526 FIRST DEMO
//
//  Created by User on 10/11/15.
//  Copyright © 2015 User. All rights reserved.
//

import Foundation
import UIKit


class StartGameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroud_raffleanimation.jpg")!)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        if #available(iOS 8.0, *) {
            navigationController?.hidesBarsOnTap = false
        } else {
            // Fallback on earlier versions
        };
    }


    
}