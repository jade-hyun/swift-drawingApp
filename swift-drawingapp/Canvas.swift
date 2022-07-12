//
//  Canvas.swift
//  swift-drawingapp
//
//  Created by jade.h on 2022/07/11.
//

import Foundation
import UIKit

class Canvas: SelectionUsecase, DrawingUsecase {

    private var presenter: PresenterPort?

    private var squares: [Square] = []
    private var currentLine: (Line, UIColor)?
    private let colorSet = ColorSet()

    func setPresenter(_ presenter: PresenterPort) {
        self.presenter = presenter
    }

    func tapped(at point: Point) {
        guard let selectedSquare = findSquare(at: point) else {
            return
        }

        if selectedSquare.isSelected {
            presenter?.deselect(path: selectedSquare)
        } else {
            presenter?.select(path: selectedSquare)
        }

        selectedSquare.isSelected.toggle()
    }

    private func findSquare(at point: Point) -> Square? {
        return squares.reversed().first(where: { pathDrawable in
            pathDrawable.path().cgPath.contains(.init(x: point.x, y: point.y))
        })
    }

    func addRectangle() {
        guard let presenter = presenter else {
            return
        }

        let randomPoint = randomPoint(size: presenter.canvasSize)
        let square = Square(origin: randomPoint)

        presenter.show(path: square, color: colorSet.randomColor())

        squares.append(square)
    }

    func lineStart(at point: Point) {
        let line = Line(points: [point])
        let color = colorSet.randomColor()

        currentLine = (line, color)

        presenter?.show(path: line, color: color)
    }

    func lineMove(at point: Point) {
        guard let (line, color) = currentLine else {
            return
        }

        line.addPoint(point)

        presenter?.show(path: line, color: color)
    }

    func lineEnd(at point: Point) {
        guard let (line, color) = currentLine else {
            return
        }

        line.addPoint(point)

        presenter?.show(path: line, color: color)

        self.currentLine = nil
    }

    private func randomPoint(size: Point) -> Point {
        let drawableSize = size.moving(byX: -100, y: -100)
        let x: Double = .random(in: Double.zero..<drawableSize.x)
        let y: Double = .random(in: Double.zero..<drawableSize.y)

        return Point(x: x, y: y)
    }

}
