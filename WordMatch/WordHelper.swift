//
//  WordHelper.swift
//  WordMatch
//
//  Created by Mookyung Kwak on 2017-01-10.
//  Copyright © 2017 Mookyung Kwak. All rights reserved.
//

import Foundation
import RealmSwift
import SDCAlertView

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
        if let _ = realm.object(ofType: Word.self, forPrimaryKey: spelling) {
            let alert = AlertController(title: "같은 단어가 있습니다", message: "새로운 단어를 입력해주세요", preferredStyle: .alert)
            let okAction = AlertAction(title: "확인", style: .normal, handler: { (action) in
                completion(false)
            })
            alert.add(okAction)
            alert.present()
        } else {
            let word = Word()
            word.content = spelling
            do {
                try realm.write {
                    realm.add(word, update: false)
                }
                completion(true)
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(false)
            }
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
        let realm = try! Realm()
        if let selectable = allSelectable() {
            let chosenArray = Array(selectable).choose(draw)
            for chosen in chosenArray {
                let count = chosen.selectedCount
                try! realm.write {
                    chosen.selectedCount = count + 1
                }
            }
            return chosenArray
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
