//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/21.
//

import SwiftUI

struct AppIconView: View {
    let color: Color
    var body: some View {
        /*
        ZStack{
            Color.blue
            LinearGradient(gradient: Gradient(stops: [.init(color: .clear, location: 0), .init(color: Color.black.opacity(0.002), location: 0.5), .init(color: Color.black.opacity(0.004), location: 0.6), .init(color: Color.black.opacity(0.009), location: 0.7), .init(color: Color.black.opacity(0.017), location: 0.8), .init(color: Color.black.opacity(0.032), location: 0.9), .init(color: Color.black.opacity(0.057), location: 1)]), startPoint: .init(x: 0.5, y: 0.5), endPoint: .init(x: 0.5, y: 1))
            LinearGradient(gradient: Gradient(stops: [.init(color: .clear, location: 0), .init(color: .clear, location: 0.3), .init(color: Color.white.opacity(0.0017), location: 0.5), .init(color: Color.white.opacity(0.0035), location: 0.6), .init(color: Color.white.opacity(0.0056), location: 0.7), .init(color: Color.white.opacity(0.0076), location: 0.8), .init(color: Color.white.opacity(0.008), location: 0.85), .init(color: Color.white.opacity(0.00755), location: 0.9),.init(color: Color.white.opacity(0.0058), location: 0.95), .init(color: .clear, location: 1)]), startPoint: .init(x: 0.5, y: 0.5), endPoint: .init(x: 0.5, y: 0))
            LinearGradient(gradient: Gradient(stops: [.init(color: Color.black.opacity(0.026), location: 0), .init(color: .clear, location: 0.125), .init(color: .clear, location: 0.875), .init(color: Color.black.opacity(0.026), location: 1)]), startPoint: .init(x: 0, y: 0.5), endPoint: .init(x: 1, y: 0.5))
        }.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).clipShape(Squircle())
 */
        
        
            ZStack{
                color
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
            }.frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).clipShape(Squircle())
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView(color: .green)
    }
}
