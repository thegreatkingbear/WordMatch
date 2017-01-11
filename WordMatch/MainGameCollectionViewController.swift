//
//  MainGameCollectionViewController.swift
//  WordMatch
//
//  Created by Mookyung Kwak on 2017-01-09.
//  Copyright © 2017 Mookyung Kwak. All rights reserved.
//

import UIKit
import GameplayKit

private let reuseIdentifier = "WordCard"

class MainGameCollectionViewController: UICollectionViewController {

    let baseWords = ["water", "melon", "pencil", "school", "watch", "book", "piano", "candy", "kitchen", "game", "flower", "road", "run", "walk", "what", "chair"]
    let basePlayers = ["아빠", "엄마", "나"]
    
    var doubled = [String]()
    var shuffled = [String]()
    
    var shuffledPlayers = [String]()
    var thePlayers = [Player]()
    
    var flippedWords = [CardCollectionViewCell]() {
        didSet {
            checkFlippedWords()
        }
    }
    
    @IBOutlet weak var player1: UIBarButtonItem?
    @IBOutlet weak var player2: UIBarButtonItem?
    @IBOutlet weak var player3: UIBarButtonItem?
    
    var point: Int = 0
    var currentOrder: Int = 0
    
    var clearedCells = [CardCollectionViewCell]()
    
    var timer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Logics
    func reset() {
        // 단어를 두 배로 뻥튀기 한 다음에 섞어 준다
        doubled.removeAll()
        doubled.append(contentsOf: baseWords)
        doubled.append(contentsOf: baseWords)
        print(doubled)
        shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: doubled) as! [String]
        print(shuffled)
        
        // 플레이어를 섞은 다음에 셋팅한다
        shuffledPlayers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: basePlayers) as! [String]
        print(shuffledPlayers)
        thePlayers.removeAll()
        for shuffled in shuffledPlayers {
            let player = Player()
            player.name = shuffled
            thePlayers.append(player)
        }
        print(thePlayers)
        currentOrder = 0
        updatePlayerPoints()
        highlightCurrentPlayer()
        collectionView?.reloadData()
    }
    
    func checkFlippedWords() {
        if flippedWords.count > 1 {
            if flippedWords[0].theWord! == flippedWords[1].theWord! {
                thePlayers[currentOrder].currentPoint += 1
                updatePlayerPoints()
                self.flippedWords[0].isCleared = true
                self.flippedWords[1].isCleared = true
                clearedCells.append(flippedWords[0])
                clearedCells.append(flippedWords[1])
                flippedWords.removeAll()
            } else {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                    self.nextTurn()
                    self.flippedWords[0].flipCardAnimation(isForward: false)
                    self.flippedWords[1].flipCardAnimation(isForward: false)
                    self.flippedWords.removeAll()
                })
            }
        }
    }
    
    func updatePlayerPoints() {
        player1?.title = "\(thePlayers[0].name) : \(thePlayers[0].currentPoint)"
        player2?.title = "\(thePlayers[1].name) : \(thePlayers[1].currentPoint)"
        player3?.title = "\(thePlayers[2].name) : \(thePlayers[2].currentPoint)"
    }
    
    func nextTurn() {
        // 숫자를 올려주고
        currentOrder = currentOrder + 1
        if currentOrder > 2 {
            currentOrder = 0
        }
        
        // 해당 플레이어를 하이라이트 시켜주자
        highlightCurrentPlayer()
    }
    
    func highlightCurrentPlayer() {
        switch currentOrder {
        case 0:
            player1?.tintColor = UIColor.blue
            player2?.tintColor = UIColor.lightGray
            player3?.tintColor = UIColor.lightGray
        case 1:
            player1?.tintColor = UIColor.lightGray
            player2?.tintColor = UIColor.blue
            player3?.tintColor = UIColor.lightGray
        case 2:
            player1?.tintColor = UIColor.lightGray
            player2?.tintColor = UIColor.lightGray
            player3?.tintColor = UIColor.blue
        default:
            break
        }
    }
    
    func popClearedCell() {
        if clearedCells.count > 0 {
            let popped = clearedCells.removeLast()
            popped.flipCardAnimation(isForward: false)
            popped.isCleared = false
        } else {
            timer?.invalidate()
            reset()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return shuffled.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCollectionViewCell
    
        // Configure the cell
        cell.theWord = shuffled[indexPath.row]
        //cell.backgroundColor = UIColor.white
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        flippedWords.append(cell)
        cell.flipCardAnimation(isForward: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let cellWidth = (self.collectionView?.bounds.size.width)! / 4.0 - 15.0
        //print(cellWidth)
        let cellHeight = ((self.collectionView?.bounds.size.height)! - (self.navigationController?.navigationBar.frame.size.height)! - (self.navigationController?.toolbar.frame.size.height)! - 20.0) / 8.0 - 12.0
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // 일단 두 장 이상은 뒤집지 못하게 한다
        if flippedWords.count > 1 {
            return false
        }
        
        // 카드가 클리어된거면 뒤집지 않는다
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        if cell.isCleared {
            return false
        }
        
        // 나머지는 오케이
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    @IBAction func startButtonTapped(sender: UIButton) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(popClearedCell), userInfo: [], repeats: true)
    }
}
