//
//  MotionManager.swift
//  Sensors
//
//  Created by Mark Townsend on 6/17/20.
//  Copyright © 2020 Mark Townsend. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()

    var fx: CGFloat = 0
    var fy: CGFloat = 0
    var fz: CGFloat = 0

    var dx: Double = 0
    var dy: Double = 0
    var dz: Double = 0

    init() {
        motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
            guard let gravity = data?.gravity else { return }

            self.dx = gravity.x
            self.dy = gravity.y
            self.dz = gravity.z

            self.fx = CGFloat(gravity.x)
            self.fy = CGFloat(gravity.y)
            self.fz = CGFloat(gravity.z)

            self.objectWillChange.send()
        }
    }
}
