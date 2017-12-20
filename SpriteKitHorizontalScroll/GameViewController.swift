//
//  GameViewController.swift
//  SpriteKitHorizontalScroll
//
//  Created by Alessandro Ornano on 19/12/2017.
//  Copyright © 2017 Alessandro Ornano. All rights reserved.
//

import UIKit
import SpriteKit
class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = self.view as! SKView? else { return }
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = false
        view.showsDrawCount = true
        let scene = GameScene(size:view.bounds.size)
        scene.scaleMode = .aspectFill
        view.presentScene(scene)
    }
}
