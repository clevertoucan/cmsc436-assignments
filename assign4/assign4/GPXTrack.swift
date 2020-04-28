//
//  GPXTrack.swift
//  assign4
//
//  Created by Josh on 4/27/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import Foundation
import UIKit
import MapKit



public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)

        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))

        return coords
    }
}

struct Coordinate: Codable {
    var x : Double
    var y : Double
    
}

class GPXTrack : Codable {
    var path: [Coordinate]
    
    init(poly: MKPolyline) {
        self.path = poly.coordinates.map { Coordinate(x: $0.latitude, y: $0.longitude) }
    }
    
    init?(json: Data) {
        if let decodedSelf = try? JSONDecoder().decode(GPXTrack.self, from: json) {
            self.path = decodedSelf.path
        } else {
            return nil
        }
    }

    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
