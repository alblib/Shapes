//
//  Operations.swift
//  
//
//  Created by Albertus Liberius on 2021/02/04.
//

import SwiftUI

extension Angle{
    init(x: CGFloat, y: CGFloat){
        self.init(radians: atan2( Double(y) , Double(x) ))
    }
    init(x: Double, y: Double){
        self.init(radians: atan2( y,x))
    }
}

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
    /** Gives multiplied size of self by given ratio (in size sense, not area sense). */
    func multiplied(by ratio: CGFloat) -> CGSize{
        return CGSize(width: self.width * ratio, height: self.height * ratio)
    }
    /**
     Gives vector diectly converted from self. Use this to add CGSize to CGRect.
            
     In this package, CGSize is not meant to add or substract from CGRect. CGVector is.
     However, in Apple's API, CGSize is used with exactly such purpose.
     In such case, use this function to convert CGSize to CGVector and conveniently add or substract to CGRect by predefined operator provided by this package.
     */
    var convertedToVector: CGVector{
        CGVector(dx: self.width, dy: self.height)
    }
}

extension View{
    // because when font goes zero, glitch occurs.
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
    var unitVector: CGVector{
        self / sqrt(self.dx * self.dx + self.dy * self.dy)
    }
    static prefix func + (_ v: CGVector) -> CGVector{
        return v
    }
    static prefix func - (_ v: CGVector) -> CGVector{
        CGVector(dx: -v.dx, dy: -v.dy)
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
    
    /**
     Gives CGRect with given size inscribed in self.
     
     This uses flipped-coordinate space i.e. iOS (SwiftUI) System. Okay to use with SwiftUI in macOS (AppKit, not Catalyst) but do not use in CoreGraphics with AppKit.
     
     Alignment other than predefine value gives nil.
     Using predefined alignment guarantees a non-nil result.
        
     - Parameters:
        - size: The size of the result CGRect.
        - alignment: Alignment of the result inside self. Use predefined values only.
     */
    func inscribedRect(size: CGSize, alignment: Alignment) -> CGRect?{
        // using flipped-coordinate space i.e. iOS (SwiftUI) System.
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
    
    /**
     Gives CGRect with given aspect ratio inscribed in self.
     
     This uses flipped-coordinate space i.e. iOS (SwiftUI) System. Okay to use with SwiftUI in macOS (AppKit, not Catalyst) but do not use in CoreGraphics with AppKit.
     
     Alignment other than predefine value gives nil.
     Using predefined alignment guarantees a non-nil result.
        
     - Parameters:
        - aspectRatio: The ratio of width to height to use for the resulting view.
        - alignment: Alignment of the result inside self. Use predefined values only.
     */
    func inscribedRect(aspectRatio: CGFloat, alignment: Alignment) -> CGRect?{
        // using flipped-coordinate space i.e. iOS (SwiftUI) System.
        let size = CGSize(width: min(self.size.width, self.size.height * aspectRatio), height: min(self.size.height, self.size.width / aspectRatio))
        return inscribedRect(size: size, alignment: alignment)
    }
    
   /**
    Gives CGRect with given size ratio to self, inscribed in self.
    
    This uses flipped-coordinate space i.e. iOS (SwiftUI) System. Okay to use with SwiftUI in macOS (AppKit, not Catalyst) but do not use in CoreGraphics with AppKit.
    
    Alignment other than predefine value gives nil.
    Using predefined alignment guarantees a non-nil result.
       
    - Parameters:
       - sizeRatio: The size ratio of the result to self.
       - alignment: Alignment of the result inside self. Use predefined values only.
    */
    func inscribedRect(sizeRatio: CGFloat, alignment: Alignment) -> CGRect?{
        let size = CGSize(width: self.size.width * sizeRatio, height: self.size.height * sizeRatio)
        return inscribedRect(size: size, alignment: alignment)
    }
}


func + (_ a: CGVector, _ b: CGVector) -> CGVector{
    CGVector(dx: a.dx + b.dx, dy: a.dy + b.dy)
}
func - (_ a: CGVector, _ b: CGVector) -> CGVector{
    CGVector(dx: a.dx - b.dx, dy: a.dy - b.dy)
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
