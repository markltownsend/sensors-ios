//
//  GameScene.swift
//  MySpriteKit
//
//  Created by Mark Townsend on 6/16/20.
//  Copyright © 2020 Mark Townsend. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {

    private let swiftNode = SKSpriteNode(imageNamed: "swift")
    private let motionManager = CMMotionManager()

    override func sceneDidLoad() {
        motionManager.startAccelerometerUpdates()

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

        swiftNode.position = CGPoint(x: frame.midX, y: frame.midY)
        swiftNode.size = CGSize(width: 100, height: 100)
        addChild(swiftNode)
        swiftNode.physicsBody = SKPhysicsBody(circleOfRadius: swiftNode.size.width / 2)
        swiftNode.physicsBody?.allowsRotation = true
        swiftNode.physicsBody?.restitution = 0.5
    }

    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * -1.62, dy: accelerometerData.acceleration.y * 9.8)
        }
    }
}
