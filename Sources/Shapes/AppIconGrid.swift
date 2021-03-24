//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/15.
//

import SwiftUI

struct AppIconGrid: Shape {
    let strokeStyle: StrokeStyle
    let extraStrokeStyle: StrokeStyle = .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [10,10], dashPhase: 0)
    let existsExternalFrame: Bool = true
    let existsTool: Bool = true
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2 * (existsExternalFrame ? 216/268 : 1)
        let subSquareRadii: [CGFloat] = [pow(2, -0.2), CGFloat(80) / CGFloat(216)]
        let subSquareRadius1toR: CGFloat = pow(14248907, 0.2) / 27
        let subCircleRadii = [subSquareRadii[0], subSquareRadii[1] * sqrt(2), subSquareRadii[1]]
        var path = Path()
        if existsExternalFrame{
            let firstExp = -1 / log2((13 + 54 * pow(2, 0.3)) / (67 * sqrt(2)))
            let secondExp = -1 / log2((13 + 108 * pow(2, 0.3)) / (121 * sqrt(2)))
            path.addPath(Squircle(exponent:CGFloat(firstExp)).path(in: CGRect(minX: rect.midX - radius * 268/216, maxX: rect.midX + radius * 268/216, minY: rect.midY - radius * 268/216, maxY: rect.midY + radius * 268/216)))
            path.addPath(Squircle(exponent:CGFloat(secondExp)).path(in: CGRect(minX: rect.midX - radius * 242/216, maxX: rect.midX + radius * 242/216, minY: rect.midY - radius * 242/216, maxY: rect.midY + radius * 242/216)))
        }
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
        var output = path.strokedPath(strokeStyle)
        var dashpath = Path()
        dashpath.addRect(rect)
        output.addPath(dashpath.strokedPath(extraStrokeStyle))
        return output
    }
}

struct AppIconGrid_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            AppIconGrid(strokeStyle: .init())
            Spacer()
            AppIconGrid(strokeStyle: .init())
        }
    }
}
