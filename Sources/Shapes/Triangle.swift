//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/11.
//

import SwiftUI

/**
 Creates an isosceles triangle.
 */
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
    }
}

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        Triangle()
    }
}
