//
//  ContentView.swift
//  MathFunctions
//
//  Created by Marius on 05/04/2025.
//

import SwiftUI

struct Signal: Shape {
    
    // animation of the signal
    var animatableData: Double {
        get { offset }
        set { self.offset = newValue }
    }

    // signal parameters
    var amplitude: Double
    var frequency: Double
    var offset: Double

    // conforming to Shape protocol
    func path(in rect: CGRect) -> Path {
        let curve = UIBezierPath()

        // some specified points
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth

        // calculate the length between 2 peaks
        let wavelength = width / frequency

        // start from one side and middle screen
        curve.move(to: CGPoint(x: 0, y: midHeight))

        // iterate across each horizontal pixel
        for x in stride(from: 0, through: width, by: 1) {
            // current position in respect to the wavelength
            let relativeX = x / wavelength

            // distance from x axis centre
            let distanceFromMidWidth = x - midWidth

            // normalize it and create reversed parabola
            let normalDistance = oneOverMidWidth * distanceFromMidWidth
            let parabola = -(normalDistance * normalDistance) + 1

            // find sine and add phase
            let sine = sin(relativeX + offset)

            // determine the y_axis point
            let y = parabola * amplitude * sine + midHeight

            // add a line up to this point
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
                Signal(amplitude: 50, frequency: 25, offset: self.offset + Double(i) * .pi)
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
