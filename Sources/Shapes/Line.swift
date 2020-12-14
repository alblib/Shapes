//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/11.
//

import SwiftUI

func * (_ a: CGVector, _ b: CGVector) -> CGFloat{
    a.dx * b.dx + a.dy * b.dy
}

func / (_ v: CGVector, _ s: CGFloat) -> CGVector{
    CGVector(dx: v.dx / s, dy: v.dy / s)
}
func * (_ v: CGVector, _ s: CGFloat) -> CGVector{
    CGVector(dx: v.dx * s, dy: v.dy * s)
}
func * (_ s: CGFloat, _ v: CGVector) -> CGVector{
    CGVector(dx: s * v.dx, dy: s * v.dy)
}

func + (_ p: CGPoint, _ v: CGVector) -> CGPoint{
    CGPoint(x: p.x + v.dx, y: p.y + v.dy)
}
func + (_ v: CGVector, _ p: CGPoint) -> CGPoint{
    CGPoint(x: v.dx + p.x, y: v.dy + p.y)
}
func - (_ p: CGPoint, _ v: CGVector) -> CGPoint{
    CGPoint(x: p.x - v.dx, y: p.y - v.dy)
}
func - (_ p1: CGPoint, _ p2: CGPoint) -> CGVector{
    CGVector(dx: p1.x - p2.x, dy: p1.y - p2.y)
}
prefix func - (_ v: CGVector) -> CGVector{
    CGVector(dx: -v.dx, dy: -v.dy)
}

/**
 Creates an infinite straight line with StrokeStyle. Also, it can be used as an object to calculate intersection between two lines.
 */
struct Line: Shape, CustomStringConvertible{
    
    let point : CGPoint
    let vector : CGVector
    
    var description: String{
        "(" + point.x.description + ", " + point.y.description + ") + x * (" + vector.dx.description + ", " + vector.dy.description + ")"
    }
    
    static func intersection(_ a1: Line, _ a2: Line) -> CGPoint{
        
        if a1.vector * a1.vector == 0{
            return a1.point
        }
        if a2.vector * a2.vector == 0{
            return a2.point
        }
        
        let det = a1.vector.dx * a2.vector.dy - a1.vector.dy * a2.vector.dx
        
        if det == 0{
            return CGPoint(x: (a1.point.x + a2.point.x)/2 , y: (a1.point.y + a2.point.y)/2)
        }
        
        let xtop = a1.vector.dx * ( a2.vector.dx * (a1.point.y - a2.point.y) + a2.point.x * a2.vector.dy ) - a1.point.x * a1.vector.dy * a2.vector.dx
        let ytop = (a1.point.y * a1.vector.dx + (a2.point.x - a1.point.x) * a1.vector.dy) * a2.vector.dy - a2.point.y * a1.vector.dy * a2.vector.dx
        return .init(x: xtop / det, y: ytop / det)
    }
    static func && (_ a1: Line, _ a2: Line) -> CGPoint {
        return intersection(a1, a2)
    }
    init(point: CGPoint, vector: CGVector){
        self.point = point
        self.vector = vector
        self.style = StrokeStyle()
    }
    init(point: CGPoint, vector: CGVector, style: StrokeStyle){
        self.point = point
        self.vector = vector
        self.style = style
    }
    init(pt1: CGPoint, pt2: CGPoint){
        self.point = pt1
        self.vector = CGVector(dx: pt2.x - pt1.x, dy: pt2.y - pt1.y)
        self.style = StrokeStyle()
    }
    init(pt1: CGPoint, pt2: CGPoint, style: StrokeStyle){
        self.point = pt1
        self.vector = CGVector(dx: pt2.x - pt1.x, dy: pt2.y - pt1.y)
        self.style = style
    }
    
    
    let style: StrokeStyle
    func path(in rect: CGRect) -> Path {
        let pt1: CGPoint
        let pt2: CGPoint
        let pt1cand = (rect.maxX - point.x) / vector.dx * vector + point
        if pt1cand.y > rect.maxY {
            pt1 = (rect.maxY - point.y) / vector.dy * vector + point
        }else if pt1cand.y < rect.minY{
            pt1 = (rect.minY - point.y) / vector.dy * vector + point
        }else{
            pt1 = pt1cand
        }
        let pt2cand = (rect.minX - point.x) / vector.dx * vector + point
        if pt2cand.y > rect.maxY {
            pt2 = (rect.maxY - point.y) / vector.dy * vector + point
        }else if pt2cand.y < rect.minY{
            pt2 = (rect.minY - point.y) / vector.dy * vector + point
        }else{
            pt2 = pt2cand
        }
        return Path{path in
            path.move(to: pt1)
            path.addLine(to: pt2)
        }.strokedPath(style)
    }
    func style(_ style: StrokeStyle) -> Self{
        Self.init(point: self.point, vector: self.vector, style: style)
    }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.white
            Line(pt1: .init(x: 10, y: 10), pt2: .init(x: 20, y: 20))//.stroke()//.stroke()
            Rectangle().frame(width:100, height:100)
        }
    }
}
