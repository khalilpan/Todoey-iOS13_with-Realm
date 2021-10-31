//
//  Todo.swift
//  Todoey
//
//  Created by khalil.panahi on 
//

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date = Date()
    
    //    to Link the objects from Child(Todo) to parent(Category)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "todos")
}
