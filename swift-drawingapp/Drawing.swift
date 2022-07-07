//
//  Drawing.swift
//  swift-drawingapp
//
//  Created by jade.h on 2022/07/04.
//

import UIKit

protocol DrawingData: Identifiable {
    var id: UUID { get }
    var points: [Point] { get }

    func addPoint(_ point: Point)
}

protocol PathDrawable {
    func path() -> UIBezierPath
}

class Line: PathDrawable, DrawingData {
    
    private(set) var id: UUID = UUID()
    private(set) var points: [Point]

    init(points: [Point]) {
        self.points = points
    }

    func path() -> UIBezierPath {
        let bezierPath = UIBezierPath()

        guard let firstPoint = points.first else {
            return bezierPath
        }

        bezierPath.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))

        points.suffix(from: 1).forEach { point in
            bezierPath.addLine(to: CGPoint(x: point.x, y: point.y))
        }

        return bezierPath
    }

    func addPoint(_ point: Point) {
        self.points.append(point)
    }
}



class Square: Line {

    init(origin: Point) {
        super.init(points: [origin,
                            origin.moving(byX: 100, y: 0),
                            origin.moving(byX: 100, y: 100),
                            origin.moving(byX: 0, y: 100),
                            origin.moving(byX: 0, y: 0)])
    }

//    override func path() -> UIBezierPath {
//        let bezierPath = super.path()
//        bezierPath.close()
//
//        return bezierPath
//    }

    override func addPoint(_ point: Point) {
        return
    }
}
