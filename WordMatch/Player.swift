//
//  Player.swift
//  WordMatch
//
//  Created by Mookyung Kwak on 2017-01-09.
//  Copyright © 2017 Mookyung Kwak. All rights reserved.
//

import Foundation
import RealmSwift

class Player: Object {
    dynamic var name: String = ""
    dynamic var currentPoint: Int = 0
    dynamic var totalPoint: Int = 0
}
