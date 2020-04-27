//
//  CirclesModel.swift
//  assign4
//
//  Created by Josh on 4/25/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import Foundation
import UIKit

struct Circle : Codable {
    var center : CGPoint
    var radius : CGFloat
    init(c: CGPoint, r: CGFloat) {
        center = c
        radius = r
    }
}

class CircleContainer : Codable {
    var circles: [Circle]  = []
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    init?(json: Data) {
        if let decodedSelf = try? JSONDecoder().decode(CircleContainer.self, from: json) {
            self.name = decodedSelf.name
            self.circles = decodedSelf.circles
        } else {
            return nil
        }
    }

    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
