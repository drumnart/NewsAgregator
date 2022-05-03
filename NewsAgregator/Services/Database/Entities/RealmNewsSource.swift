//
//  RealmNewsSource.swift
//  NewsAgregator
//
//  Created by Sergey Gorin on 28.04.2022.
//

import Foundation
import RealmSwift

class RealmNewsSource: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
} 
