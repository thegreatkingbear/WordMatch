//
//  WordHelper.swift
//  WordMatch
//
//  Created by Mookyung Kwak on 2017-01-10.
//  Copyright © 2017 Mookyung Kwak. All rights reserved.
//

import Foundation
import RealmSwift

class WordHelper {
    class func all() -> Results<Word>? {
        let realm = try! Realm()
        return realm.objects(Word.self)
    }
    
    class func allCount() -> Int {
        if let all = all() {
            return all.count
        }
        return 0
    }
    
    class func add(spelling: String, completion:@escaping(Bool) -> Void) {
        let realm = try! Realm()
        let word = Word()
        word.content = spelling
        do {
            try realm.write {
                realm.add(word)
            }
            completion(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    class func delete(word: Word, completion:@escaping(Bool) -> Void) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(word)
            }
            completion(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    class func updateSelectable(word: Word, selectable: Bool) {
        let realm = try! Realm()
        do {
            try realm.write {
                word.isSelectable = selectable
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    class func allSelectable() -> Results<Word>? {
        let realm = try! Realm()
        return realm.objects(Word.self).filter("isSelectable == true")
    }
    
    class func shuffledOf(draw: Int) -> [Word]? {
        if let selectable = allSelectable() {
            return Array(selectable).choose(draw)
        }
        return nil
    }
}

extension Array {
    /// Returns an array containing this sequence shuffled
    var shuffled: Array {
        var elements = self
        return elements.shuffle()
    }
    /// Shuffles this sequence in place
    @discardableResult
    mutating func shuffle() -> Array {
        indices.dropLast().forEach {
            guard case let index = Int(arc4random_uniform(UInt32(count - $0))) + $0, index != $0 else { return }
            swap(&self[$0], &self[index])
        }
        return self
    }
    var chooseOne: Element { return self[Int(arc4random_uniform(UInt32(count)))] }
    func choose(_ n: Int) -> Array { return Array(shuffled.prefix(n)) }
}
