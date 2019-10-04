import UIKit

extension CGPath {
    func boundingBox(minX: CGFloat, maxX: CGFloat) -> CGRect {
        var minY = boundingBox.maxY, maxY = boundingBox.minY
        applyWithBlock {
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
