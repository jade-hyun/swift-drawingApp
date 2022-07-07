//
//  ColorSet.swift
//  swift-drawingapp
//
//  Created by jade.h on 2022/07/04.
//

import UIKit

protocol RandomColorFactory {
    func randomColor() -> UIColor
}

struct ColorSet: RandomColorFactory {
    
    private let set: Set<UIColor>

    init() {
        let colors: [UIColor] = [.blue, .black, .brown, .cyan, .gray, .green, .magenta, .orange, .purple]

        self.set = Set(colors.map({ $0.withAlphaComponent(0.7) }))
    }

    func randomColor() -> UIColor {
        return set.randomElement() ?? .black
    }
}
