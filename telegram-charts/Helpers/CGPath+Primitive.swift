//
//  CGPath+Primitive.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/25/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

extension CGPath {
    func boundingBox(minX: CGFloat, maxX: CGFloat) -> CGRect {
        var minY = self.boundingBox.maxY, maxY = self.boundingBox.minY
        self.applyWithBlock {
            pathElement in
            let p = pathElement.pointee.points.pointee
            if p.x >= minX && p.x <= maxX {
                if p.y < minY {
                    minY = p.y
                }
                if p.y > maxY {
                    maxY = p.y
                }
            }
        }
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}
