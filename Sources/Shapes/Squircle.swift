//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/11.
//

import SwiftUI

/**
 Creates a squircle, a shape between square and circle. Its equation is |x|ⁿ+|y|ⁿ=1 with exponent n.
 */
struct Squircle: Shape {
    enum Exponent: Double{
        case circle = 2
        /**
         Returns exponent expressing curvature of outer bounding box of macOS app icon.
         
         This shape is the shape of the "Outer bounding box" in macOS App Icon design guideline:
         [Human Interface Guideline](https://developer.apple.com/design/human-interface-guidelines/macos/icons-and-images/app-icon/). This shape is defined as the concentric shape to the App Icon shape (exponent = 5) with size ratio 268/216. Considering the Squircle equation |x|ⁿ+|y|ⁿ=1, this value is exactly ```-1 / log2((13 + 108 * pow(2, 0.3)) / (121 * sqrt(2)))```
         */
        case appleAppOuterBoundingBox = 3.944204014882778343811377790673765375874 // -1 / log2((13 + 108 * pow(2, 0.3)) / (121 * sqrt(2)))
        /**
         Returns exponent expressing curvature of inner bounding box of macOS app icon.
         
         This shape is the shape of the "Outer bounding box" in macOS App Icon design guideline:
         [Human Interface Guideline](https://developer.apple.com/design/human-interface-guidelines/macos/icons-and-images/app-icon/). This shape is defined as the concentric shape to the App Icon shape (exponent = 5) with size ratio 242/216. Considering the Squircle equation |x|ⁿ+|y|ⁿ=1, this value is exactly ```-1 / log2((13 + 54 * pow(2, 0.3)) / (67 * sqrt(2)))```
         */
        case appleAppInnerBoundingBox = 4.359227512893827563100574643675730192911 // -1 / log2((13 + 54 * pow(2, 0.3)) / (67 * sqrt(2)))
        case appleAppShape = 5
    }
    /**
     Returns exponent parameter to draw the squircle.
     
     This value is not allowed to be equal or below zero to draw one continuous valid shape.
     */
    let exponent: CGFloat
    /**
     Returns the number of points to render this shape.
     
     All the points are already in the optimal position so sharp vertex in the shape also can be rendered properly. This value set to be small enough to save computing power but large enough that the rendering result have almost no error in human eye. Quadratic Bezier curve is drawn between all rendering points.
     */
    let renderingResolution: Int = 32
    init(_ exponentInt: Exponent){
        self.exponent = CGFloat(exponentInt.rawValue)
    }
    init?(_ exponentInt: Exponent?){
        guard let exponentInt = exponentInt else{
            return nil
        }
        self.exponent = CGFloat(exponentInt.rawValue)
    }
    init?(exponent: CGFloat = 5){
        if exponent < CGFloat.leastNormalMagnitude{
            return nil
        }
        self.exponent = exponent
    }
    private func unitShape(_ theta: CGFloat) -> Line{
        let c = cos(theta)
        let s = sin(theta)
        let sgn_c: CGFloat = c.sign == .minus ? -1 : 1
        let sgn_s: CGFloat = s.sign == .minus ? -1 : 1
        let abs_c = abs(c)
        let abs_s = abs(s)
        let pt = CGPoint(x: pow(abs_c,2/exponent) * sgn_c, y: pow(abs_s,2/exponent) * sgn_s)
        let vec: CGVector
        if exponent > 0 && exponent < 2{ // 0<=exp<=2
            vec = CGVector(dx: -s * pow(abs_c, 2/exponent-1), dy: c * pow(abs_s, 2/exponent-1))
        }else{ // exp <= 0 or exp >= 1
            vec = CGVector(dx: -sgn_s * pow(abs_s, 2-2/exponent), dy: sgn_c * pow(abs_c, 2-2/exponent))
        }
        return Line(point: pt, vector: vec)
    }
    private func relToAbs(rel: CGPoint, in rect: CGRect) -> CGPoint{
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        return CGPoint(x: centre.x + radius * rel.x, y: centre.y + radius * rel.y)
    }
    func path(in rect: CGRect) -> Path {
        let list = Array<Int>(0...renderingResolution).map{unitShape(2 * CGFloat.pi * CGFloat($0) / CGFloat(renderingResolution))}
        return Path{ path in
            path.move(to: relToAbs(rel: list[0].point, in: rect))
            for i in 1...renderingResolution{
                path.addQuadCurve(to: relToAbs(rel: list[i].point, in: rect), control: relToAbs(rel: intersection(list[i-1], list[i]), in: rect))
            }
        }
    }
    func concentric(ratio: CGFloat) -> Squircle?{
        switch self.exponent {
        case 1:
            return Squircle(exponent: 1)
        case 2:
            return Squircle(exponent: 2)
        case 2...:
            if ratio <= exp2(-1 / exponent) * (1 + sqrt(2)) * (sqrt(2) - exp2(1 / exponent)){
                return nil
            }else{
                return Squircle(exponent: -1 / log2(exp2(-1 / exponent) - (1-ratio)/sqrt(2)))
            }
        default:
            return nil
        }
    }
}

private struct Squircle_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Squircle(exponent:5)!.stroke()
            //Squircle(exponent:1).stroke()
        }
    }
}
