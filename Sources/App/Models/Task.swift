//
//  Task.swift
//  App
//
//  Created by Emil Jimenez on 10/14/17.
//

import Foundation
import JSON

final class Task: JSONConvertible {
    enum Error: Swift.Error {
        case expectedJSONData
    }
    
    let id: String
    var description: String
    var category: String
    
    init(id: String, description: String, category: String) {
        self.id = id
        self.description = description
        self.category = category
    }
    
    required init(json: JSON) throws {
        guard let description = json["description"]?.string,
            let category = json["category"]?.string else {
                throw Error.expectedJSONData
        }
        
        self.description = description
        self.category = category
        
        if let id = json["id"]?.string {
            self.id = id
        } else {
            self.id = UUID().uuidString
        }
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("category", category)
        return json
    }
}

