//
//  File.swift
//  
//
//  Created by Albertus Liberius on 2020/12/15.
//

import CoreGraphics

struct RelativeBounds{
    let relativeMinX: CGFloat
    let relativeMaxX: CGFloat
    let relativeMinY: CGFloat
    let relativeMaxY: CGFloat
    
    init(relativeMinX: CGFloat = -1, relativeMaxX: CGFloat = 1, relativeMinY: CGFloat = -1, relativeMaxY: CGFloat = 1){
        self.relativeMinX = relativeMinX
        self.relativeMaxX = relativeMaxX
        self.relativeMinY = relativeMinY
        self.relativeMaxY = relativeMaxY
    }
    
    func inscribed(in rect: CGRect, preferAlignOriginTo absoluteReferencePoint: CGPoint) -> RelativeFrame{
        return inscribed(in: rect, preferAlign: .originalReferencePoint, to: absoluteReferencePoint)
    }
    func inscribed(in rect: CGRect, mustAlignOriginTo absoluteReferencePoint: CGPoint) -> RelativeFrame{
        inscribed(in: rect, mustAlign: .originalReferencePoint, to: absoluteReferencePoint)
    }
    func inscribed(in rect: CGRect, preferAlign relativeReferencePoint: RelativePoint, to absoluteReferencePoint: CGPoint) -> RelativeFrame{
        let scale: CGFloat = min(
            rect.width / (relativeMaxX - relativeMinX),
            rect.height / (relativeMaxY - relativeMinY))
        let X : CGFloat = min(
            max((relativeReferencePoint.relativeX - relativeMinX) * scale + rect.minX,
                absoluteReferencePoint.x),
            rect.maxX + scale * (relativeReferencePoint.relativeX - relativeMaxX))
        let Y : CGFloat = min(
            max((relativeReferencePoint.relativeY - relativeMinY) * scale + rect.minY,
                absoluteReferencePoint.y),
            rect.maxY + scale * (relativeReferencePoint.relativeY - relativeMaxY))
        return RelativeFrame(origin: .init(x: X, y: Y), scale: scale)
    }
    func inscribed(in rect: CGRect, mustAlign relativeReferencePoint: RelativePoint, to absoluteReferencePoint: CGPoint) -> RelativeFrame{
        let scale: CGFloat = min(
            (rect.minX - absoluteReferencePoint.x) / (relativeMinX - relativeReferencePoint.relativeX),
            (rect.minY - absoluteReferencePoint.y) / (relativeMinY - relativeReferencePoint.relativeY),
            (rect.maxX - absoluteReferencePoint.x) / (relativeMaxX - relativeReferencePoint.relativeX),
            (rect.maxY - absoluteReferencePoint.y) / (relativeMaxY - relativeReferencePoint.relativeY)
        )
        return RelativeFrame(origin: absoluteReferencePoint, scale: scale)
    }
}

struct RelativeFrame{
    let origin: CGPoint
    let scale: CGFloat
}

struct RelativePoint{
    let relativeX: CGFloat
    let relativeY: CGFloat
    init(x: CGFloat, y: CGFloat){
        relativeX = x
        relativeY = y
    }
    init(){
        relativeX = 0
        relativeY = 0
    }
    static let originalReferencePoint = RelativePoint()
    func toAbsolute(frame: RelativeFrame) -> CGPoint{
        CGPoint(x: frame.origin.x + relativeX * frame.scale, y: frame.origin.y + relativeY * frame.scale)
    }
}
