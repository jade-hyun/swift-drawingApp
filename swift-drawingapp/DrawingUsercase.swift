//
//  DrawingUsecase.swift
//  swift-drawingapp
//
//  Created by jade.h on 2022/07/11.
//

import Foundation

protocol DrawingUsecase {
    func addRectangle()
    func lineStart(at: Point)
    func lineMove(at: Point)
    func lineEnd(at: Point)
}
