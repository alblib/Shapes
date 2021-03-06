//
//  Line.swift
//  
//
//  Created by Albertus Liberius on 2020/12/11.
//

import SwiftUI

/**
 Creates an infinite straight line with StrokeStyle. Also, it can be used as an object to calculate intersection between two lines.
 */
struct Line: Shape, CustomStringConvertible{
    
    let point : CGPoint
    let vector : CGVector
    
    var description: String{
        "(" + point.x.description + ", " + point.y.description + ") + x * (" + vector.dx.description + ", " + vector.dy.description + ")"
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

struct LineSegment: Shape, CustomStringConvertible{
    
    let pt1: CGPoint
    let pt2: CGPoint
    let strokeStyle: StrokeStyle
    
    var description: String{
        "(" + pt1.x.description + ", " + pt1.y.description + ") to (" + pt2.x.description + ", " + pt2.y.description + ")"
    }
    
    func path(in rect: CGRect) -> Path {
        Path{path in
            path.addLines([pt1,pt2])
        }
    }
    var extendedLine: Line{
        Line(pt1: pt1, pt2: pt2, style: strokeStyle)
    }
    
}

func intersection(_ a1: Line, _ a2: Line) -> CGPoint{
    
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
func intersection(_ a1: LineSegment, _ a2: Line) -> CGPoint?{
    let result = intersection(a1.extendedLine, a2)
    if a1.pt1.x == a1.pt2.x{
        if a1.pt1.y == a1.pt2.y{
            return nil
        }else if (a1.pt1.y ... a1.pt2.y).contains(result.y){
            return result
        }else{
            return nil
        }
    }else if (a1.pt1.x ... a1.pt2.x).contains(result.x){
        return result
    }else{
        return nil
    }
}
func intersection(_ a2: Line, _ a1: LineSegment) -> CGPoint?{
    intersection(a1,a2)
}
func intersection(_ a1: LineSegment, _ a2: LineSegment) -> CGPoint?{
    guard let result = intersection(a1, a2.extendedLine) else {
        return nil
    }
    if a2.pt1.x == a2.pt2.x{
        if a2.pt1.y == a2.pt2.y{
            return nil
        }else if (a2.pt1.y ... a2.pt2.y).contains(result.y){
            return result
        }else{
            return nil
        }
    }else if (a2.pt1.x ... a2.pt2.x).contains(result.x){
        return result
    }else{
        return nil
    }
}
/*
func && (_ a1: Line, _ a2: Line) -> CGPoint {
    return intersection(a1, a2)
}
func && (_ a1: LineSegment, _ a2: Line) -> CGPoint? {
    return intersection(a1, a2)
}
func && (_ a1: Line, _ a2: LineSegment) -> CGPoint? {
    return intersection(a1, a2)
}
func && (_ a1: LineSegment, _ a2: LineSegment) -> CGPoint? {
    return intersection(a1, a2)
}
*/
struct Line_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.white
            Line(pt1: .init(x: 10, y: 10), pt2: .init(x: 20, y: 20))//.stroke()//.stroke()
            Rectangle().frame(width:100, height:100)
        }
    }
}
