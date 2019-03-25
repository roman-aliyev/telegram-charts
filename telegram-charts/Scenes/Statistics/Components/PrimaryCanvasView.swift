//
//  PrimaryCanvasView.swift
//  telegram-charts
//
//  Created by Roman Aliyev on 3/22/19.
//  Copyright © 2019 Roman Aliyev. All rights reserved.
//

import UIKit

protocol PrimaryCanvasViewDelegate {
    func selectionDidChange(sender: UIView, leftOffset: CGFloat, rightOffset: CGFloat)
}

class PrimaryCanvasView: CanvasView, UIGestureRecognizerDelegate {
    var delegate: PrimaryCanvasViewDelegate?
    
    var selectorLeftOffset: CGFloat {
        get {
            return self.leftDimmingViewWidthConstraint.constant
        }
        set {
            self.leftDimmingViewWidthConstraint.constant = newValue
        }
    }
    var selectorRightOffset: CGFloat {
        get {
            return self.rightDimmingViewWidthConstraint.constant
        }
        set {
            self.rightDimmingViewWidthConstraint.constant = newValue
        }
    }
    
    private lazy var leftDimmingViewWidthConstraint = self.leftDimmingView.widthAnchor.constraint(equalToConstant: 100)
    private lazy var rightDimmingViewWidthConstraint = self.rightDimmingView.widthAnchor.constraint(equalToConstant: 100)
    
    private let leftDimmingView = UIView()
    private let selectorView = SelectorView()
    private let rightDimmingView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.leftDimmingView.backgroundColor = UIColor(white: 0.95, alpha: 0.7)
        self.addSubview(self.leftDimmingView)
        
        self.rightDimmingView.backgroundColor = UIColor(white: 0.95, alpha: 0.7)
        self.addSubview(self.rightDimmingView)
        
        self.addSubview(selectorView)
        
        var constraints = [
            self.leftDimmingViewWidthConstraint,
            self.rightDimmingViewWidthConstraint
        ]
        
        let views = [
            "leftDimmingView": self.leftDimmingView,
            "selectorView": self.selectorView,
            "rightDimmingView": self.rightDimmingView
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
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    var l: CGFloat = 0, r: CGFloat = 0
    
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
            self.l = self.selectorLeftOffset
            self.r = self.selectorRightOffset
            if location.x < self.selectorView.frame.minX + 22 {
                self.selectorMovingState = .left
            } else if location.x > self.selectorView.frame.maxX - 22 {
                self.selectorMovingState = .right
            } else {
                self.selectorMovingState = [.left, .right]
            }
        }
        
        if self.selectorMovingState == .left {
            self.selectorLeftOffset = min(self.l + translation.x, self.bounds.width - self.selectorRightOffset - 88)
        } else if self.selectorMovingState == .right {
            self.selectorRightOffset = min(self.r - translation.x, self.bounds.width - self.selectorLeftOffset - 88)
        } else if self.selectorMovingState == [.left, .right] {
            self.selectorLeftOffset = self.l + translation.x
            self.selectorRightOffset = self.r - translation.x
        }
        
        if self.selectorLeftOffset < 0 {
            if self.selectorMovingState.contains(.right) {
                self.selectorRightOffset += self.selectorLeftOffset
            }
            self.selectorLeftOffset = 0
        } else if self.selectorRightOffset < 0 {
            if self.selectorMovingState.contains(.left) {
                self.selectorLeftOffset += self.selectorRightOffset
            }
            self.selectorRightOffset = 0
        }
        self.setNeedsLayout()
        self.delegate?.selectionDidChange(sender: self, leftOffset: self.selectorLeftOffset, rightOffset: self.selectorRightOffset)
    }
    
    override func configure(legendItems: [StatisticsViewModel.LegendItem]) {
        super.configure(legendItems: legendItems)
        self.bringSubviewToFront(self.leftDimmingView)
        self.bringSubviewToFront(self.rightDimmingView)
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
        return self.selectorView.frame.insetBy(dx: -22, dy: 0).contains(location)
    }
}

private class SelectorView: UIView {
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 0
        shapeLayer.fillColor = UIColor(white: 0.9, alpha: 1).cgColor
        shapeLayer.strokeColor = nil
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: self.bounds.width, height: 1))
        path.addRect(CGRect(x: 0, y: self.bounds.height - 1, width: self.bounds.width, height: 1))
        path.addRect(CGRect(x: 0, y: 1, width: 5, height: self.bounds.height - 2))
        path.addRect(CGRect(x: self.bounds.width - 5, y: 1, width: 5, height: self.bounds.height - 2))
        self.shapeLayer.path = path
    }
}
