//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/15.
//

import SwiftUI

struct WatchOSAppIconGrid: Shape{
    let strokeStyle: StrokeStyle
    init(stroke: StrokeStyle = .init()){
        self.strokeStyle = stroke
    }
    func path(in rect: CGRect) -> Path{
        let sketchbook = rect.inscribedRect(aspectRatio: 1, alignment: .center)!
        var path = Path()
        path.addEllipse(in: sketchbook)
        path.addEllipse(in: sketchbook.inscribedRect(sizeRatio: 0.6, alignment: .center)!)
        let center = sketchbook.center
        let vector = sketchbook.size.multiplied(by: 1.0 / 2 / sqrt(2)).convertedToVector
        path.addLines([center - vector, center + vector])
        let vector2 = CGVector(dx: vector.dx, dy: -vector.dy)
        path.addLines([center - vector2, center + vector2])
        return path.strokedPath(strokeStyle)
    }
}

struct iOSAppIconGrid: Shape{
    let strokeStyle: StrokeStyle
    init(stroke: StrokeStyle = .init()){
        self.strokeStyle = stroke
    }
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let subSquareRadii: [CGFloat] = [pow(2, -0.2), CGFloat(80) / CGFloat(216)]
        let subSquareRadius1toR: CGFloat = pow(14248907, 0.2) / 27
        let subCircleRadii = [subSquareRadii[0], subSquareRadii[1] * sqrt(2), subSquareRadii[1]]
        var path = Path()
        path.addPath(Squircle(.appleAppShape).path(in: CGRect(minX: rect.midX - radius, maxX: rect.midX + radius, minY: rect.midY - radius, maxY: rect.midY + radius)))
        // The Square
        path.addRect(CGRect(minX: rect.midX - radius * subSquareRadii[0], maxX: rect.midX + radius * subSquareRadii[0], minY: rect.midY - radius * subSquareRadii[0], maxY: rect.midY + radius * subSquareRadii[0]))
        path.addLines([rect.center + CGVector(dx: radius * subSquareRadii[1], dy: radius * subSquareRadius1toR), rect.center + CGVector(dx: radius * subSquareRadii[1], dy: -radius * subSquareRadius1toR)])
        path.addLines([rect.center + CGVector(dx: -radius * subSquareRadii[1], dy: -radius * subSquareRadius1toR), rect.center + CGVector(dx: -radius * subSquareRadii[1], dy: radius * subSquareRadius1toR)])
        path.addLines([rect.center + CGVector(dx: radius * subSquareRadius1toR, dy: radius * subSquareRadii[1]), rect.center + CGVector(dx: -radius * subSquareRadius1toR, dy: radius * subSquareRadii[1])])
        path.addLines([rect.center + CGVector(dx: -radius * subSquareRadius1toR, dy: -radius * subSquareRadii[1]), rect.center + CGVector(dx: radius * subSquareRadius1toR, dy: -radius * subSquareRadii[1])])
        // Circles
        for rationalRadius in subCircleRadii{
            path.addEllipse(in: CGRect(minX: rect.midX - radius * rationalRadius, maxX: rect.midX + radius * rationalRadius, minY: rect.midY - radius * rationalRadius, maxY: rect.midY + radius * rationalRadius))
        }
        // Diagonals
        path.addLines([rect.center + CGVector(dx: -subSquareRadii[0] * radius, dy: -subSquareRadii[0] * radius), rect.center + CGVector(dx: subSquareRadii[0] * radius, dy: subSquareRadii[0] * radius)])
        path.addLines([rect.center + CGVector(dx: subSquareRadii[0] * radius, dy: -subSquareRadii[0] * radius), rect.center + CGVector(dx: -subSquareRadii[0] * radius, dy: subSquareRadii[0] * radius)])
        // Cross
        path.addLines([rect.center + CGVector(dx: radius, dy: 0), rect.center + CGVector(dx: -radius, dy: 0)])
        path.addLines([rect.center + CGVector(dx: 0, dy: -radius), rect.center + CGVector(dx: 0, dy: radius)])
        // Output
        return path.strokedPath(strokeStyle)
    }
}

struct macOSAppIconGrid: Shape{
    let strokeStyle: StrokeStyle
    let toolStrokeStyle: StrokeStyle
    init(stroke: StrokeStyle = .init(), tool: StrokeStyle = .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [5,5], dashPhase: 0)){
        self.strokeStyle = stroke
        self.toolStrokeStyle = tool
    }
    func path(in rect: CGRect) -> Path {
        let sketchbook = rect.inscribedRect(aspectRatio: 1, alignment: .center)!
        let center = sketchbook.center
        let inside = sketchbook.inscribedRect(sizeRatio: 216.0 / 268.0, alignment: .center)!
        let shell = sketchbook.inscribedRect(sizeRatio: 242.0 / 268.0, alignment: .center)!
        var path = Path()
        path.addPath(Squircle(.appleAppInnerBoundingBox).path(in: shell))
        path.addPath(Squircle(.appleAppOuterBoundingBox).path(in: sketchbook))
        path = path.strokedPath(strokeStyle)
        path.addPath(iOSAppIconGrid(stroke: strokeStyle).path(in: inside))
        
        
        var toolPath = Path()
        let toolBottomPoint = center + CGVector(dx: -32, dy: 120) / 268 * sketchbook.height
        let toolTopPoint = center + CGVector(dx: 88, dy: -128) / 268 * sketchbook.height
    
        let toolLeftStrokeBottom = toolBottomPoint + (CGVector(dx: -248, dy: -120) + CGVector(dx: 120, dy: -248)).unitVector * (sqrt(2) * 13 / 268 * sketchbook.height)
        let toolRightStrokeBottom = toolBottomPoint + (-CGVector(dx: -248, dy: -120).unitVector + CGVector(dx: 120, dy: -248).unitVector) * 13 / 268 * sketchbook.height
        let toolLeftStrokeTop = toolTopPoint + (CGVector(dx: -248, dy: -120).unitVector - CGVector(dx: 120, dy: -248).unitVector)  * 13 / 268 * sketchbook.height
        let toolRightStrokeTop = toolTopPoint + ( -CGVector(dx: -248, dy: -120).unitVector - CGVector(dx: 120, dy: -248).unitVector) * 13 / 268 * sketchbook.height
        let toolBottomCenter = toolBottomPoint + CGVector(dx: 120, dy: -248).unitVector * (13 / 268 * sketchbook.height)
        let toolTopCenter = toolTopPoint - CGVector(dx: 120, dy: -248).unitVector * (13 / 268 * sketchbook.height)
        
        toolPath.addLines([toolBottomPoint, toolTopPoint])
        toolPath.addLines([toolLeftStrokeTop, toolLeftStrokeBottom])
        toolPath.addArc(center: toolBottomCenter, radius: (13 / 268 * sketchbook.height), startAngle: Angle(radians: Double.pi + atan(120.0/248)), endAngle: Angle(radians: atan(120.0/248)), clockwise: true)
        toolPath.addLines([toolRightStrokeBottom, toolRightStrokeTop])
        toolPath.addArc(center: toolTopCenter, radius: (13 / 268 * sketchbook.height), startAngle: Angle(radians: atan(120.0/248)), endAngle: Angle(radians: Double.pi + atan(120.0/248)), clockwise: true)
        
        path.addPath(toolPath.strokedPath(toolStrokeStyle))
 
        return path
    }
}


internal struct AppIconGrid_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            WatchOSAppIconGrid()
            iOSAppIconGrid()
            macOSAppIconGrid()
        }
    }
}
