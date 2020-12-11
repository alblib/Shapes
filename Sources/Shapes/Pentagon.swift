//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/11.
//

import SwiftUI

/**
 regular pentagon
 */

extension CGRect{
    var center: CGPoint{
        CGPoint(x: self.midX, y: self.midY)
    }
}

struct Pentagon: Shape {
    private let isCenterAligned: Bool
    private init(centerAligned: Bool){
        self.isCenterAligned = centerAligned
    }
    init(){
        self.isCenterAligned = false
    }
    func path(in rect: CGRect) -> Path {
        let centre: CGPoint
        let radius: CGFloat
        if isCenterAligned{
            radius = min(rect.width, rect.height)/2
            centre = rect.center
        }else{
            let radiusToTop: CGFloat = 1
            let radiusToBottom: CGFloat = (1 + sqrt(5)) / 4
            let radiusToLeft: CGFloat = sqrt((5 + sqrt(5)) / 8)
            let radiusToRight = radiusToLeft
            let widthToRadius = rect.width / (radiusToLeft + radiusToRight)
            let heightToRadius = rect.height / (radiusToTop + radiusToBottom)
            radius = min(heightToRadius, widthToRadius)
            if widthToRadius <= rect.height / 2{
                centre = CGPoint(x: rect.midX, y: rect.midY)
            }else{
                centre  = CGPoint(x: rect.midX, y: rect.minY + radius)
            }
        }
        return Path{ path in
            path.move(to: centre + CGVector(dx: 0, dy: -radius))
            for i in 1...4{
                path.addLine(to: centre + CGVector(dx: radius * sin(CGFloat(2.0)*CGFloat.pi/CGFloat(5.0)*CGFloat(i)), dy: -radius * cos(CGFloat(2)*CGFloat.pi/CGFloat(5)*CGFloat(i))))
            }
        }
    }
    func centerAligned() -> some Shape{
        Pentagon(centerAligned: true)
    }
}

struct Pentagon_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Pentagon()
            Pentagon().centerAligned()
        }
    }
}
