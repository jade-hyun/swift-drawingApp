//
//  ViewController.swift
//  swift-drawingapp
//
//  Created by JK on 2022/07/04.
//

import UIKit

final class ViewController: UIViewController, PresenterPort {

    private let bottomStackView = UIStackView()
    private let squareButton = UIButton(type: .system)
    private let lineButton = UIButton(type: .system)

    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
    private lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture))

    private let drawingView = DrawingView()

    private var currentDrawable: PathDrawable?
    private var isLineMode = false

    private var selection: SelectionUsecase?
    private var drawing: DrawingUsecase?

    var canvasSize: Point {
        let size = self.drawingView.bounds.size
        return Point(x: size.width, y: size.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        squareButton.setTitle("사각형", for: .normal)
        lineButton.setTitle("선그리기", for: .normal)

        bottomStackView.axis = .horizontal
        bottomStackView.spacing = 16

        bottomStackView.addArrangedSubview(squareButton)
        bottomStackView.addArrangedSubview(lineButton)

        squareButton.addTarget(self, action: #selector(addSquare), for: .touchUpInside)
        lineButton.addTarget(self, action: #selector(lineMode), for: .touchUpInside)

        view.addSubview(bottomStackView)
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

        view.addSubview(drawingView)
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        drawingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        drawingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        drawingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        drawingView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -16).isActive = true

        view.addGestureRecognizer(tapGestureRecognizer)
        view.addGestureRecognizer(panGestureRecognizer)
    }

    func setSelectionUsecase(_ selection: SelectionUsecase) {
        self.selection = selection
    }

    func setDrawingUsecase(_ drawing: DrawingUsecase) {
        self.drawing = drawing
    }

    @objc
    func tapGesture(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: drawingView)
        let point = Point(x: Double(location.x), y: Double(location.y))

        selection?.tapped(at: point)
    }

    @objc
    func panGesture(_ sender: UIPanGestureRecognizer) {
        guard isLineMode else {
            return
        }

        let location = sender.location(in: drawingView)
        let point = Point(x: Double(location.x), y: Double(location.y))

        switch sender.state {
        case .possible:
            break
        case .began:
            drawing?.lineStart(at: point)
        case .changed:
            drawing?.lineMove(at: point)
        case .ended, .cancelled, .failed:
            drawing?.lineEnd(at: point)
        @unknown default:
            drawing?.lineEnd(at: point)
        }
    }

    @objc
    private func addSquare() {
        drawing?.addRectangle()
    }

    @objc
    private func lineMode() {
        isLineMode.toggle()
        lineButton.isSelected = isLineMode
    }

    func show(path: PathDrawable, color: UIColor) {
        drawingView.addDrawable(path, color: color)
    }

    func select(path: PathDrawable) {
        drawingView.highlight(path: path)
    }

    func deselect(path: PathDrawable) {
        drawingView.dehighlight(path: path)
    }
}

