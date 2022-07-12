//
//  PresenterPort.swift
//  swift-drawingapp
//
//  Created by jade.h on 2022/07/11.
//

import UIKit

protocol PresenterPort {
    var canvasSize: Point { get }

    func show(path: PathDrawable, color: UIColor)
    func select(path: PathDrawable)
    func deselect(path: PathDrawable)
}
