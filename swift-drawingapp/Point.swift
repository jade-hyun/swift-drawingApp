//
//  Point.swift
//  swift-drawingapp
//
//  Created by jade.h on 2022/07/04.
//

import Foundation

struct Point: Codable {
    
    let x: Double
    let y: Double

    func moving(byX: Double, y: Double) -> Point {
        return Point(x: self.x + byX, y: self.y + y)
    }
}
