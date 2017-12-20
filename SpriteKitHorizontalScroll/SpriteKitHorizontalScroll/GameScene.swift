//
//  GameScene.swift
//  SpriteKitHorizontalScroll
//
//  Created by Alessandro Ornano on 19/12/2017.
//  Copyright © 2017 Alessandro Ornano. All rights reserved.
//

import SpriteKit
class GameScene: SKScene {
    var lastX: CGFloat = 0.0
    var moveableArea = SKNode() // the larger SKNode
    var worlds: [String]! = ["world1","world2","world3"] // the menu voices
    var currentWorld:Int = 0 // contain the current visible menu voice index
    var worldsPos = [CGPoint]() // an array of CGPoints to store the menu voices positions
    override func didMove(to view: SKView) {
        //Make a generic title
        let topLabel = SKLabelNode.init(text: "select world")
        topLabel.fontSize = 40.0
        self.addChild(topLabel)
        topLabel.zPosition = 1
        topLabel.position = CGPoint(x:frame.width / 2, y:frame.height*0.80)
        // Prepare movable area
        self.addChild(moveableArea)
        moveableArea.position = CGPoint(x:self.frame.midX,y:self.frame.midY)
        // Prepare worlds:
        for i in 0..<worlds.count {
            // add a title for i^ world
            let worldLabel = SKLabelNode.init(text: worlds[i])
            self.moveableArea.addChild(worldLabel)
            worldLabel.position = CGPoint(x:CGFloat(i)*self.frame.width ,y:moveableArea.frame.height*0.60)
            // add a sprite for i^ world
            let randomRed = CGFloat(drand48())
            let randomGreen = CGFloat(drand48())
            let randomBlue = CGFloat(drand48())
            let randomColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
            let worldSprite = SKSpriteNode.init(color: randomColor, size: CGSize.init(width: 100.0, height: 100.0))
            worldSprite.name = worlds[i]
            self.moveableArea.addChild(worldSprite)
            worldSprite.position = CGPoint(x:CGFloat(i)*self.frame.width ,y:0.0)
        }
    }
    func tapNode(node:SKNode,action:SKAction) {
        if node.action(forKey: "tap") == nil {
            node.run(action, withKey: "tap")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchedNode = self.atPoint(location)
        lastX = location.x
        let sequence = SKAction.sequence([SKAction.scale(to: 1.5, duration: 0.2),SKAction.scale(to: 1.0, duration: 0.1)]) // a little action to show the selection of the world
        switch touchedNode.name {
        case "world1"?:
            print("world1 was touched..")
            tapNode(node:touchedNode,action:sequence)
        case "world2"?:
            print("world2 was touched..")
            tapNode(node:touchedNode,action:sequence)
        case "world3"?:
            print("world3 was touched..")
            tapNode(node:touchedNode,action:sequence)
        default:break
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let currentX = location.x
        let leftLimit:CGFloat = CGFloat(worlds.count-1)
        let rightLimit:CGFloat = 1.0
        let scrollSpeed:CGFloat = 1.0
        let newX = moveableArea.position.x + ((currentX - lastX)*scrollSpeed)
        if newX < self.size.width*(-leftLimit) {
            moveableArea.position = CGPoint(x:self.size.width*(-leftLimit), y:moveableArea.position.y)
        }
        else if newX > self.size.width*rightLimit {
            moveableArea.position = CGPoint(x:self.size.width*rightLimit, y:moveableArea.position.y)
        }
        else {
            moveableArea.position = CGPoint(x:newX, y:moveableArea.position.y)
        }
        // detect current visible world
        worldsPos = [CGPoint]()
        for i in 0..<worlds.count {
            let leftLimit = self.size.width-(self.size.width*CGFloat(i))
            let rightLimit = self.size.width-(self.size.width*CGFloat(i+1))
            if rightLimit ... leftLimit ~= moveableArea.position.x {
                currentWorld = i
            }
            worldsPos.append(CGPoint(x: (rightLimit + (leftLimit - rightLimit)/2), y:moveableArea.position.y))
        }
        lastX = currentX
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if worldsPos.count>0, moveableArea.action(forKey: "moveAction") == nil {
            let moveAction = SKAction.move(to: worldsPos[currentWorld], duration: 0.5)
            moveAction.timingMode = .easeInEaseOut
            self.moveableArea.run(moveAction, withKey: "moveAction")
        }
    }
}
