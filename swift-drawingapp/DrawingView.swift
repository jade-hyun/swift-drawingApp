//
//  DrawingView.swift
//  swift-drawingapp
//
//  Created by jade.h on 2022/07/04.
//

import UIKit

class DrawingView: UIView {

    private var drawables: [(PathDrawable, UIColor)] = []
    private var selectedDrawable: PathDrawable?

    func addDrawable(_ drawable: PathDrawable, color: UIColor) {
        drawables.append((drawable, color))

        if let layer = findLayer(for: drawable) {
            update(layer: layer, path: drawable.path().cgPath)
        } else {
            draw(path: drawable.path().cgPath, color: color)
        }
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

    private func update(layer: CAShapeLayer, path: CGPath) {
        layer.path = path
        layer.displayIfNeeded()
    }

    func highlight(path: PathDrawable) {
        guard let selectedLayer = findLayer(for: path) else {
            return
        }

        selectedLayer.strokeColor = UIColor.systemRed.cgColor
        selectedLayer.lineWidth = 3
        selectedLayer.displayIfNeeded()
    }

    func dehighlight(path: PathDrawable) {
        guard let selectedLayer = findLayer(for: path) else {
            return
        }

        selectedLayer.strokeColor = UIColor.clear.cgColor
        selectedLayer.lineWidth = .zero
        selectedLayer.displayIfNeeded()
    }

    private func findLayer(for path: PathDrawable) -> CAShapeLayer? {
        return layer.sublayers?.compactMap({ $0 as? CAShapeLayer }).first(where: { $0.path == path.path().cgPath })
    }
}
