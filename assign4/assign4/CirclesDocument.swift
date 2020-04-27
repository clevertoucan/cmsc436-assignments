//
//  Document.swift
//  assign4
//
//  Created by Josh on 4/25/20.
//  Copyright © 2020 Josh. All rights reserved.
//

import UIKit

class CirclesDocument: UIDocument {
    var container: CircleContainer?

    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return container?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let data = contents as? Data {
            container = CircleContainer(json: data)
        }
    }
}

