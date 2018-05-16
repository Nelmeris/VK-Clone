//
//  Model.swift
//  VKService
//
//  Created by Артем on 16.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import SwiftyJSON
import RealmSwift

// Родитель всех типов запросов
open class Models: Object {
    required convenience public init(json: JSON) {
        self.init()
    }
}
