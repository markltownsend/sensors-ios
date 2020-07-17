//
//  GameViewController.swift
//  Sensors
//
//  Created by Mark Townsend on 6/18/20.
//  Copyright © 2020 Mark Townsend. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import SwiftUI

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .fill

            view.presentScene(scene)

            let locationManager = LocationManager()
            let contentView = ContentView().environmentObject(locationManager)
            let contentHostController = UIHostingController(rootView: contentView)
            addChild(contentHostController)
            contentHostController.view.frame = view.frame
            contentHostController.view.backgroundColor = .clear
            view.addSubview(contentHostController.view)
        }
    }
}
