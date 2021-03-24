//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/21.
//

import SwiftUI

struct AppIconView<Background>: View where Background: View{
    let background: Background
    var body: some View {
        ZStack{
            background
            LinearGradient(gradient: Gradient(stops: [.init(color: .clear, location: 0), .init(color: Color.black.opacity(0.006), location: 0.5), .init(color: Color.black.opacity(0.01), location: 0.6), .init(color: Color.black.opacity(0.025), location: 0.7), .init(color: Color.black.opacity(0.044), location: 0.8), .init(color: Color.black.opacity(0.09), location: 0.9), .init(color: Color.black.opacity(0.15), location: 1)]), startPoint: .init(x: 0.5, y: 0.5), endPoint: .init(x: 0.5, y: 1))
            LinearGradient(gradient: Gradient(stops: [.init(color: .clear, location: 0), .init(color: .clear, location: 0.3), .init(color: Color.white.opacity(0.005), location: 0.5), .init(color: Color.white.opacity(0.01), location: 0.6), .init(color: Color.white.opacity(0.017), location: 0.7), .init(color: Color.white.opacity(0.023), location: 0.8), .init(color: Color.white.opacity(0.024), location: 0.85), .init(color: Color.white.opacity(0.023), location: 0.9),.init(color: Color.white.opacity(0.015), location: 0.95), .init(color: .clear, location: 1)]), startPoint: .init(x: 0.5, y: 0.3), endPoint: .init(x: 0.5, y: 0))
            LinearGradient(gradient: Gradient(stops: [
                .init(color: Color.black.opacity(0.12), location: 0),
                .init(color: Color.black.opacity(0.05), location: 0.125),
                .init(color: Color.black.opacity(0.02), location: 0.25),
                .init(color: .clear, location: 0.4),
                .init(color: .clear, location: 0.6),
                .init(color: Color.black.opacity(0.02), location: 0.75),
                .init(color: Color.black.opacity(0.05), location: 0.875),
                .init(color: Color.black.opacity(0.12), location: 1)
            ]), startPoint: .init(x: 0, y: 0.5), endPoint: .init(x: 1, y: 0.5))
        }.aspectRatio(1, contentMode: .fit)
        .clipShape(Squircle(.appleAppShape))
    }
}

internal struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView(background: Color.green).frame(width: 400, height: 600, alignment: .center)
    }
}
