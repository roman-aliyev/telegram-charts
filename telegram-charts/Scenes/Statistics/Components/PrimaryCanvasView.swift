import UIKit

protocol PrimaryCanvasViewDelegate {
    func selectionDidChange(sender: UIView, leftOffset: CGFloat, rightOffset: CGFloat)
}

class PrimaryCanvasView: CanvasView, UIGestureRecognizerDelegate {
    var delegate: PrimaryCanvasViewDelegate?
    
    var selectorLeftOffset: CGFloat {
        get {
            return leftDimmingViewWidthConstraint.constant
        }
        set {
            leftDimmingViewWidthConstraint.constant = newValue
        }
    }
    var selectorRightOffset: CGFloat {
        get {
            return rightDimmingViewWidthConstraint.constant
        }
        set {
            rightDimmingViewWidthConstraint.constant = newValue
        }
    }
    
    private lazy var leftDimmingViewWidthConstraint = leftDimmingView.widthAnchor.constraint(equalToConstant: 100)
    private lazy var rightDimmingViewWidthConstraint = rightDimmingView.widthAnchor.constraint(equalToConstant: 100)
    
    private let leftDimmingView = UIView()
    private let selectorView = SelectorView()
    private let rightDimmingView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        leftDimmingView.backgroundColor = UIColor(white: 0.95, alpha: 0.7)
        addSubview(self.leftDimmingView)
        
        rightDimmingView.backgroundColor = UIColor(white: 0.95, alpha: 0.7)
        addSubview(self.rightDimmingView)
        
        addSubview(selectorView)
        
        var constraints = [
            leftDimmingViewWidthConstraint,
            rightDimmingViewWidthConstraint
        ]
        
        let views = [
            "leftDimmingView": leftDimmingView,
            "selectorView": selectorView,
            "rightDimmingView": rightDimmingView
        ]
        
        views.values.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        constraints.append(contentsOf:
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[leftDimmingView][selectorView][rightDimmingView]|", metrics: nil, views: views) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[leftDimmingView]|", metrics: nil, views: views) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[selectorView]|", metrics: nil, views: views) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[rightDimmingView]|", metrics: nil, views: views)
        )
        
        NSLayoutConstraint.activate(constraints)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gestureRecognizerGotPanEvent(recognizer:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }
    
    private var l: CGFloat = 0, r: CGFloat = 0
    
    private struct SelectorMovingState: OptionSet {
        let rawValue: Int
        
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        static let nothing = SelectorMovingState(rawValue: 0 << 0)
        static let left = SelectorMovingState(rawValue: 1 << 0)
        static let right = SelectorMovingState(rawValue: 1 << 1)
    }
    
    private var selectorMovingState = SelectorMovingState.nothing
    
    @objc func gestureRecognizerGotPanEvent(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self)
        let translation = recognizer.translation(in: self)
        
        if recognizer.state == .began {
            l = self.selectorLeftOffset
            r = self.selectorRightOffset
            if location.x < selectorView.frame.minX + 22 {
                selectorMovingState = .left
            } else if location.x > self.selectorView.frame.maxX - 22 {
                selectorMovingState = .right
            } else {
                selectorMovingState = [.left, .right]
            }
        }
        
        if selectorMovingState == .left {
            selectorLeftOffset = min(self.l + translation.x, bounds.width - selectorRightOffset - 88)
        } else if selectorMovingState == .right {
            selectorRightOffset = min(self.r - translation.x, bounds.width - selectorLeftOffset - 88)
        } else if selectorMovingState == [.left, .right] {
            selectorLeftOffset = l + translation.x
            selectorRightOffset = r - translation.x
        }
        
        if selectorLeftOffset < 0 {
            if selectorMovingState.contains(.right) {
                selectorRightOffset += selectorLeftOffset
            }
            selectorLeftOffset = 0
        } else if selectorRightOffset < 0 {
            if selectorMovingState.contains(.left) {
                selectorLeftOffset += selectorRightOffset
            }
            selectorRightOffset = 0
        }
        
        setNeedsLayout()
        delegate?.selectionDidChange(sender: self, leftOffset: selectorLeftOffset, rightOffset: selectorRightOffset)
    }
    
    override func configure(legendItems: [StatisticsViewModel.LegendItem]) {
        super.configure(legendItems: legendItems)
        bringSubviewToFront(leftDimmingView)
        bringSubviewToFront(rightDimmingView)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        let translation = panGestureRecognizer.translation(in: self)
        guard abs(translation.x) > abs(translation.y) else {
            return false
        }
        let location = panGestureRecognizer.location(in: self)
        
        return selectorView.frame.insetBy(dx: -22, dy: 0).contains(location)
    }
}

private class SelectorView: UIView {
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = UIColor(white: 0.9, alpha: 1).cgColor
        shapeLayer.strokeColor = nil
        layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: bounds.width, height: 1))
        path.addRect(CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1))
        path.addRect(CGRect(x: 0, y: 1, width: 5, height: bounds.height - 2))
        path.addRect(CGRect(x: bounds.width - 5, y: 1, width: 5, height: bounds.height - 2))
        shapeLayer.path = path
    }
}
