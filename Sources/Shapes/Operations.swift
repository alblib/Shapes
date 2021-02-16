//
//  Operations.swift
//  
//
//  Created by Albertus Liberius on 2021/02/04.
//

import SwiftUI

extension CGSize{
    var leastDimension : CGFloat{
        min(self.width, self.height)
    }
    var greatestDimension: CGFloat{
        max(self.width, self.height)
    }
    var aspectRatio: CGFloat{
        self.width / self.height
    }
}

extension View{
    func font(point: CGFloat) -> some View{
        if point <= 0{
            return AnyView(EmptyView())
        }else{
            return AnyView(self.font(.system(size: point)))
        }
    }
}

extension CGVector{
    init(dx: CGFloat){
        self.init(dx: dx, dy: 0)
    }
    init(dy: CGFloat){
        self.init(dx: 0, dy: dy)
    }
}

extension CGRect{
    
    /** Creates a rectangle with specified boundaries. */
    init(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat){
        self.init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    /** Creates a rectangle with specified boundaries. */
    init(x: ClosedRange<CGFloat>, y: ClosedRange<CGFloat>){
        self.init(x: x.lowerBound, y: y.lowerBound, width: x.upperBound - x.lowerBound, height: y.upperBound - y.lowerBound)
    }
    
    init(withZeroOriginAndSize: CGSize){
        self.init(origin: .zero, size: withZeroOriginAndSize)
    }
    /**
     The center point of the frame.
     */
    var center: CGPoint{
        CGPoint(x: self.midX, y: self.midY)
    }
    
    
    func inscribedRect(with aspectRatio: CGFloat, alignment: Alignment) -> CGRect?{
        // using flipped-coordinate space i.e. iOS (SwiftUI) System.
        let size = CGSize(width: min(self.size.width, self.size.height * aspectRatio), height: min(self.size.height, self.size.width / aspectRatio))
        let x : CGFloat?
        let y : CGFloat?
        switch alignment.horizontal{
        case .leading:
            x = self.minX
        case .trailing:
            x = self.maxX - size.width
        case .center:
            x = self.midX - size.width / 2
        default:
            x = nil
        }
        switch alignment.vertical{
        case .top:
            y = self.minY
        case .bottom:
            y = self.maxY - size.height
        case .center:
            y = self.midY - size.height / 2
        default:
            y = nil
        }
        guard x != nil && y != nil else{
            return nil
        }
        return CGRect(origin: .init(x: x!, y: y!), size: size)
    }
}

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
