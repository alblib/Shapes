//
//  SwiftUIView.swift
//  
//
//  Created by Albertus Liberius on 2020/12/11.
//

import SwiftUI

extension CGRect{
    init(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat){
        self.init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    /**
     The center point of the frame.
     */
    var center: CGPoint{
        CGPoint(x: self.midX, y: self.midY)
    }
}

struct RegularPolygon: Shape {
    /**
     The number of sides of the polygon.
     */
    let numberOfSides: Int
    /**
     Argument angle of the polygon rotated from its default shape (in radian).
     
     The default argument (zero angle) meaning that the first vertex of the polygon is at the center of the top. Positive angle means clockwise rotation of the polygon.
     */
    let argument: Double
    /**
     Indicates whether the centeroid of the polygon is guaranteed to be aligned to the center of the frame.
     
     This value to be false does not mean that the centeroid may be misaligned to the center of the frame, but to be true always guarantee the alignment. This value can be set to true automatically in the initialization function if the given conditions in the function guarantees the alignment of the centeroid.
     */
    let isCenterAligned: Bool
    /**
     Whether makes an excircle of the polygon inscribed of the frame.
     
     This to be true also guarantees `isCenterAligned` to be true, as guarantees the centeroid is aligned to the center of the frame.
     */
    let circumscribedByCircle: Bool
    
    init(numberOfSides: Int, flatOnBottom: Bool = true, mustCenterAligned: Bool = false){
        self.numberOfSides = numberOfSides
        self.argument = (numberOfSides % 2 == 0) == flatOnBottom ? Double.pi / Double(numberOfSides) : 0
        self.isCenterAligned = numberOfSides % 2 == 0 || mustCenterAligned
        self.circumscribedByCircle = false
    }
    
    init(numberOfSides: Int, argument: Double, circumscribedByCircle: Bool){
        self.numberOfSides = numberOfSides
        self.circumscribedByCircle = circumscribedByCircle
        self.isCenterAligned = circumscribedByCircle
        self.argument = argument
    }
    
    func path(in rect: CGRect) -> Path {
        if numberOfSides <= 2 {
            return Path()
        }
        let relPts: [CGPoint]
            = Array<Int>(0..<numberOfSides).map
            { (i: Int) -> Double in
                Double.pi / Double(numberOfSides)
                    * Double(2 * i) + argument
            }.map {
                CGPoint(x: sin($0), y: -cos($0))
            }
        
        let centre : CGPoint
        let radius : CGFloat
        
        if circumscribedByCircle{
            centre = rect.center
            radius = min(rect.width, rect.height) / 2
            
        }else if isCenterAligned{
            // make the minimal concentric external box.
            centre = rect.center
            let xRelRadius = relPts.map{abs($0.x)}.max() ?? 0
            let yRelRadius = relPts.map{abs($0.y)}.max() ?? 0
            // get fittest side between horizontal and vertical dimension.
            radius = min(rect.width / xRelRadius, rect.height / yRelRadius) / 2
            
        }else{
            let relXs = relPts.map{$0.x}
            let relYs = relPts.map{$0.y}
            
            let relBounds = CGRect(
                minX: relXs.min() ?? 0, maxX: relXs.max() ?? 0,
                minY: relYs.min() ?? 0, maxY: relYs.max() ?? 0)
            
            radius = min(rect.width / relBounds.width, rect.height / relBounds.height)
            centre = CGPoint(x: min(max(rect.minX - radius * relBounds.minX, rect.midX), rect.maxX - radius * relBounds.maxX), y: min(max(rect.minY - radius * relBounds.minY, rect.midY), rect.maxY - radius * relBounds.maxY))
            
        }
        // ignore zero area for error-proof.
        if !radius.isNormal{
            return Path()
        }
        
        let points = relPts.map{
            CGPoint(x: centre.x + radius * $0.x,
                    y: centre.y + radius * $0.y)
        }
        
        return Path{path in
            path.addLines(points)
        }
    }
    
}

struct RegularPolygon_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ZStack{
                Color.blue
                RegularPolygon(numberOfSides: 5)
            }
            RegularPolygon(numberOfSides: 3)
        }
    }
}