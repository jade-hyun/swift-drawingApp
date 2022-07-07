//
//  DrawingView.swift
//  swift-drawingapp
//
//  Created by jade.h on 2022/07/04.
//

import UIKit

protocol DrawingViewDelegate: AnyObject {
    func touchBegan(_ drawingView: DrawingView, cgPoint: CGPoint) -> Bool
    func touchMoved(_ drawingView: DrawingView, cgPoint: CGPoint) -> Bool
    func touchCancelled(_ drawingView: DrawingView, cgPoint: CGPoint) -> Bool
    func touchEnded(_ drawingView: DrawingView, cgPoint: CGPoint) -> Bool
}

class DrawingView: UIView {

    private var drawables: [(PathDrawable, UIColor)] = []
    private var selectedDrawable: PathDrawable?

    weak var delegate: DrawingViewDelegate?

    func addDrawable(_ drawable: PathDrawable, color: UIColor) {
        drawables.append((drawable, color))

        draw(path: drawable.path().cgPath, color: color)
    }

    private func draw(path: CGPath, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path

        if path.isRect(nil) {
            shapeLayer.fillColor = color.cgColor
        } else {
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = 3
            shapeLayer.lineCap = .square
            shapeLayer.lineJoin = .round
        }

        layer.addSublayer(shapeLayer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            super.touchesBegan(touches, with: event)
            return
        }

        let selectedDrawable = drawables.reversed().map({ $0.0 }).first(where: {
            let path = $0.path().cgPath

            return path.isRect(nil) && path.contains(point)
        })


        self.selectedDrawable = selectedDrawable

        guard delegate?.touchBegan(self, cgPoint: point) ?? false else {
            super.touchesBegan(touches, with: event)
            return
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            super.touchesMoved(touches, with: event)
            return
        }

        guard delegate?.touchMoved(self, cgPoint: point) ?? false else {
            super.touchesMoved(touches, with: event)
            return
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            super.touchesCancelled(touches, with: event)
            return
        }

        guard selectedDrawable == nil else {
            selectedDrawable = nil
            return
        }

        guard delegate?.touchCancelled(self, cgPoint: point) ?? false else {
            super.touchesCancelled(touches, with: event)
            return
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {
            super.touchesEnded(touches, with: event)
            return
        }

        guard selectedDrawable == nil else {
            if let selectedLayer = layer.sublayers?.compactMap({ $0 as? CAShapeLayer }).first(where: { $0.path == selectedDrawable?.path().cgPath }) {
                selectedLayer.strokeColor = UIColor.systemRed.cgColor
                selectedLayer.lineWidth = 3
                selectedLayer.displayIfNeeded()
            }

            selectedDrawable = nil

            return
        }

        guard delegate?.touchEnded(self, cgPoint: point) ?? false else {
            super.touchesEnded(touches, with: event)
            return
        }
    }
}
