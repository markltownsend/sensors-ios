//
//  ContentView.swift
//  Sensors
//
//  Created by Mark Townsend on 6/16/20.
//  Copyright © 2020 Mark Townsend. All rights reserved.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var location: LocationManager

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {
            Text("\(location.speed) MPH").font(.system(size: 45, weight: .bold, design: .default))
            if location.course > 0 {
                HStack {
                    Text("Course: ").bold()
                    Text("\(location.course, specifier: "%.2f")")
                }
            }
            HStack {
                Text("Heading: ").bold()
                Text("\(location.heading, specifier: "%.2f")")
            }
            HStack {
                Text("Coordinates: ").bold()
                Text("\(location.latLong.0, specifier: "%.2f"), \(location.latLong.1, specifier: "%.2f")")
            }.padding(.bottom)
            HStack(alignment: .top, spacing: 8) {
                Text("Location: ").bold()
                Text("\(location.cityState)")
            }
        }.onAppear() {
            self.location.start()
        }.onDisappear() {
            self.location.stop()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
