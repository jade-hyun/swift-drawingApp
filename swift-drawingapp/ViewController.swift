//
//  ViewController.swift
//  swift-drawingapp
//
//  Created by JK on 2022/07/04.
//

import UIKit

enum DrawingMode {
    case squre
    case line
}

final class ViewController: UIViewController {

    private let colorSet = ColorSet()
    private var drawingMode: DrawingMode = .squre
    private let drawingModeSegmented = UISegmentedControl(items: ["사각형", "드로잉"])

    private var currentDrawable: PathDrawable?

    override func viewDidLoad() {
        super.viewDidLoad()

        drawingModeSegmented.selectedSegmentIndex = 0
        drawingModeSegmented.addTarget(self, action: #selector(drawingModeChanged), for: .valueChanged)

        view.addSubview(drawingModeSegmented)
        drawingModeSegmented.translatesAutoresizingMaskIntoConstraints = false
        drawingModeSegmented.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        drawingModeSegmented.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

        let drawingView = DrawingView()
        drawingView.delegate = self

        view.addSubview(drawingView)
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        drawingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        drawingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        drawingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        drawingView.bottomAnchor.constraint(equalTo: drawingModeSegmented.topAnchor, constant: -16).isActive = true
    }

    @objc
    private func drawingModeChanged() {
        if drawingModeSegmented.selectedSegmentIndex == 0 {
            drawingMode = .squre
        } else {
            drawingMode = .line
        }
    }
}

extension ViewController: DrawingViewDelegate {
    func touchBegan(_ drawingView: DrawingView, cgPoint: CGPoint) -> Bool {
        return true
    }

    func touchMoved(_ drawingView: DrawingView, cgPoint: CGPoint) -> Bool {
        return true
    }

    func touchCancelled(_ drawingView: DrawingView, cgPoint: CGPoint) -> Bool {
        return true
    }

    func touchEnded(_ drawingView: DrawingView, cgPoint: CGPoint) -> Bool {
        switch drawingMode {
        case .squre:
            let point = Point(x: cgPoint.x, y: cgPoint.y)
            drawingView.addDrawable(Square(origin: point), color: colorSet.randomColor())
        case .line:
            break
        }
        return true
    }


}

