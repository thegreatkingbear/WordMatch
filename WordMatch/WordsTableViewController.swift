//
//  WordsTableViewController.swift
//  WordMatch
//
//  Created by Mookyung Kwak on 2017-01-10.
//  Copyright © 2017 Mookyung Kwak. All rights reserved.
//

import UIKit
import RealmSwift

class WordsTableViewController: UITableViewController {

    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        // realm의 fine grained notification 사용
        self.notificationToken = WordHelper.all()?.addNotificationBlock({ (changes) in
            print(changes)
            switch changes {
            case .initial: self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                let fromRow = {(row: Int) in
                    return IndexPath(row: row, section: 0)}
                
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: deletions.map(fromRow), with: .left)
                self.tableView.insertRows(at: insertions.map(fromRow), with: .right)
                self.tableView.reloadRows(at: updates.map(fromRow), with: .none)
                self.tableView.endUpdates()
            default: break
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WordHelper.allCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath) as! WordTableViewCell

        // Configure the cell...
        if let word = WordHelper.all()?[indexPath.row] {
            if word.isSelectable {
                cell.selectableButton?.setBackgroundImage(UIImage(named: "right"), for: .normal)
            } else {
                cell.selectableButton?.setBackgroundImage(UIImage(named: "wrong"), for: .normal)
            }
            cell.spelling?.text = word.content
            cell.selectedCount?.text = "\(word.selectedCount)"
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: 버튼 액션들
    @IBAction func addWordButtonTapped(sender: UIButton) {
        let alert = UIAlertController(title: "단어를 추가합니다", message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "추가", style: .default) { action in
            let spellingTextField = alert.textFields![0] as UITextField
            let spelling = spellingTextField.text!
            WordHelper.add(spelling: spelling, completion: { (isSuccess) in
                
            })
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        alert.addTextField { (textField) in
            textField.placeholder = "스펠링을 적어주세요"
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
