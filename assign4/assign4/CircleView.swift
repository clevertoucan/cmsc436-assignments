//
//  circleView.swift
//  assign4
//
//  Created by Josh on 4/25/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var circleContainer: CircleContainer?
    
    override func draw(_ rect: CGRect) {
        if let container = circleContainer {
            let path = UIBezierPath()
//            container.circles.append(Circle(c: CGPoint(x: 100, y: 100), r: 45))
            for c in container.circles {
                path.append(UIBezierPath(arcCenter: c.center, radius: c.radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true))
            }
            UIColor.green.setStroke()
            path.lineWidth = 2
            path.stroke()
        }
    }


}
