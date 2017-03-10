//
//  StorySelectionViewController.swift
//  StoryTime
//
//  Created by Nguyen Duc Tam on 2017/03/03.
//  Copyright © 2017年 Tammy Coron. All rights reserved.
//

import UIKit

class StorySelectionViewController: UITableViewController {
    var stories: [Array<Story>]! = nil
    var categoryName : [String] = [String]()
    
    fileprivate func setupEmptyStories() {
        stories = [Array<Story>]()
        stories.append([Story]()) // zombie stories
        stories.append([Story]()) // vampire stories
        stories.append([Story]()) // alien stories
     }
    //MARK: - UNWIND SEGUE
    @IBAction func close(seque: UIStoryboardSegue) {
        saveData()
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        saveData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryName.append("Zombie Stories")
        categoryName.append("Vampire Stories")
        categoryName.append("Alien Stories")
        loadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= stories[indexPath.section].count {
            guard let storyType = StoryType(rawValue: indexPath.section) else {
                return
            }
            let story = Story(type: storyType)
            stories[indexPath.section].append(story)
            let insertPoint = IndexPath(row: 0, section: indexPath.section)
            tableView.insertRows(at: [insertPoint], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row < stories[indexPath.section].count {
            return .delete
        } else {
            return .none
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < stories[indexPath.section].count {
            stories[indexPath.section].remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categoryName.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categoryName[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stories[section].count + 1
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTimeCell", for: indexPath)
        if indexPath.row < stories[indexPath.section].count {
            cell.textLabel?.text = stories[indexPath.section][indexPath.row].titles
        } else {
            switch indexPath.section {
            case 0:
                cell.textLabel?.text = "add a zombie story"
            case 1:
                cell.textLabel?.text = "add a vampire story"
            case 2:
                cell.textLabel?.text = "add an alien story"
            default :
                break
            }

        }
               // Configure the cell...

        return cell
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GenerateStory" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let storyViewController = segue.destination as! StoryViewController
                if indexPath.row < stories[indexPath.section].count {
                    storyViewController.currentStory = stories[indexPath.section][indexPath.row]
                }
            }
        }
    }
    
    // MARK: Saving & loading Data
    fileprivate func urlForData() -> URL? {
        let fileManager = FileManager.default
        var url: URL?
        do {
            url = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            url = url?.appendingPathComponent("stories.dat")
        } catch {
            
        }
        return url
    }
    
    fileprivate func saveData() {
        guard let saveFile = urlForData() else {
            return
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: stories)
        do {
            try data.write(to: saveFile)
        } catch {
            
        }
    }
    
    fileprivate func loadData() {
        guard let saveFile = urlForData() else {
            setupEmptyStories()
            return
        }
        do {
            let data = try Data(contentsOf:  saveFile)
            let userStories  = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Array<Story>]
            if userStories != nil {
                stories = userStories!
            }
        } catch {
            
        }
        if stories == nil {
            setupEmptyStories()
        }
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

}
