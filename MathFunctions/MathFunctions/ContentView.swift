//
//  ContentView.swift
//  MathFunctions
//
//  Created by Marius on 18/04/2025.
//

import SwiftUI

struct Signal: Shape {
    
    // facilitates animation
    var animatableData: Double {
        get { offset }
        set { self.offset = newValue }
    }

    // signal parameters
    var amplitude: Double
    var frequency: Double
    var offset: Double

    // creating path (Shape protocol conformity only prerequisite)
    func path(in rect: CGRect) -> Path {
        let curve = UIBezierPath()

        // some specified points
        let screenWidth = Double(rect.width)
        let screenHeigth = Double(rect.height)
        let screenMiddleWidth = screenWidth / 2
        let screenMiddleHeigth = screenHeigth / 2

        // length between 2 peaks (wavelength)
        let lambda = screenWidth / frequency

        // start from one side and middle screen
        curve.move(to: CGPoint(x: 0, y: screenMiddleHeigth))

        // iterate across each horizontal pixel
        for x in stride(from: 0, through: screenWidth, by: 1) {
            
            // x position in respect to wavelength
            let positionX = x / lambda

            // distance of x from middle screen
            let distanceX = x - screenMiddleWidth

            // normalize calculated distance (value betweeen -1 and 1)
            let distanceNormX = distanceX / screenMiddleWidth
            
            // determine the inverted parabolic curve
            let parabola = -(distanceNormX * distanceNormX) + 1

            // find sine of x position and phase taken into account
            let sine = sin(positionX + offset)

            // determine the value on y_axis
            let y = sine * amplitude * parabola + screenMiddleHeigth

            // add a line up to current (x,y) point
            curve.addLine(to: CGPoint(x: x, y: y))
        }
        return Path(curve.cgPath)
    }
}

struct ContentView: View {
    @State private var offset = 0.0

    var body: some View {
        ZStack {
            let colors: [Color] = [.yellow, .green]
            ForEach(0..<2) { i in
                Signal(amplitude: 80, frequency: 20, offset: self.offset + Double(i) * .pi)
                    .stroke(colors[i], lineWidth: 5)
            }
        }
        .background(Color(red: 0.45, green: 0.41, blue: 0.94))
        .onAppear {
            withAnimation(Animation.linear(duration: 3).repeatForever(autoreverses: false)) {
                self.offset = .pi * 2
            }
        }
    }
}

#Preview {
    ContentView()
}
