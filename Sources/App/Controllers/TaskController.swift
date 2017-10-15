//
//  TaskController.swift
//  App
//
//  Created by Emil Jimenez on 10/15/17.
//

import Vapor
import JSON

var tasksByID = [String: Task]()

extension Task: Parameterizable {
    
    static var uniqueSlug: String {
        return "task"
    }
    
    // returns the found model for the resolved url parameter
    static func make(for parameter: String) throws -> Task {
        
        guard let task = tasksByID[parameter] else {
            throw Abort.notFound
        }
        return task
    }
}

final class TaskController: ResourceRepresentable, EmptyInitializable {
    typealias Model = Task
    typealias Multiple = (Request) throws -> ResponseRepresentable
    typealias Item = (Request, Model) throws -> ResponseRepresentable
    
    func index(request: Request) throws -> ResponseRepresentable {
        return try tasksByID.values.makeJSON()
    }
    
    func create(request: Request) throws -> ResponseRepresentable {
        guard let json = request.json else {
            throw Abort.badRequest
        }
        
        let task = try Task(json: json)
        tasksByID[task.id] = task
        return try task.makeJSON()
    }
    
    func show(request: Request, task: Task) throws -> ResponseRepresentable {
        return try task.makeJSON()
    }
    
    func makeResource() -> Resource<Task> {
        return Resource(index: index, store: create, show: show)
    }
}
