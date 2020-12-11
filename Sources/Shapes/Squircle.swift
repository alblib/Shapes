//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/11.
//

import SwiftUI

/**
 Creates a squircle, a shape between square and circle. Its equation is |x|^n+|y|^n=1 with exponent n.
 */
struct Squircle: Shape {
    enum Exponent: Int{
        case circle = 2
        case appleAppShape = 5
    }
    let exponent: CGFloat
    let renderingResolution: Int = 32
    init(_ exponentInt: Exponent){
        self.exponent = CGFloat(exponentInt.rawValue)
    }
    init(exponent: CGFloat = 5){
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
                path.addQuadCurve(to: relToAbs(rel: list[i].point, in: rect), control: relToAbs(rel: list[i-1] && list[i], in: rect))
            }
        }
    }
}

struct Squircle_Previews: PreviewProvider {
    static var previews: some View {
        Squircle(exponent:5).stroke()
    }
}
