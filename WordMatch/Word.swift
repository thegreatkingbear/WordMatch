//
//  Word.swift
//  WordMatch
//
//  Created by Mookyung Kwak on 2017-01-10.
//  Copyright © 2017 Mookyung Kwak. All rights reserved.
//

import Foundation
import RealmSwift

class Word: Object {
    dynamic var content: String = ""
    dynamic var isSelectable: Bool = true
    dynamic var selectedCount: Int = 0
}
