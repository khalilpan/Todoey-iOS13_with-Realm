//
//  Category.swift
//  Todoey
//
//  Created by khalil.panahi
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor : String = ""
//    to create a relation ship from parent(Category) to Child(Todo)
    let todos = List<Todo>()
    
}
