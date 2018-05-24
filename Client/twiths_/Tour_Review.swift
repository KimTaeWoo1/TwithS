//
//  Tour_Review.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 21..
//

import UIKit

class Tour_Review: UITableViewController {
    @IBOutlet var tour_title: UINavigationItem!
    
    @IBOutlet var TV_Review: UITableView!
    
    @IBOutlet var BottomTitle: UINavigationItem!
    var ID:Int = 0
    var This_Tour:Tour = Empty_Tour
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tour_title.title = This_Tour.Name
        BottomTitle.title = "\(This_Tour.Reviews.count)개의 리뷰"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return This_Tour.Reviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "T_Review", for: indexPath)

        let Review = This_Tour.Reviews[indexPath.row]
        
        var StarString = ""
        
        for _ in 0..<Review.Stars { StarString += "★" }
        for _ in Review.Stars..<5 { StarString += "☆" }
        cell.textLabel?.text = "\(Review.WriteUser.Nickname) (\(StarString))"
        
        cell.detailTextLabel?.text = Review.Content
        if Review.ReviewImage.count > 0 {
            cell.imageView?.image = UIImage(named: Review.ReviewImage[0])
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tour_course_show" {
            let dest = segue.destination as! Tour_Landmarks
            dest.ID = ID
            dest.This_Tour = find_tour(tourID: ID)
            dest.Landmark_List = Tour_LandmarkList(A: dest.This_Tour)
        }
        else if segue.identifier == "tour_map_show" {
            let dest = segue.destination as! Tour_Map
            dest.ID = ID
            dest.This_Tour = find_tour(tourID: ID)
            dest.Landmark_List = Tour_LandmarkList(A: dest.This_Tour)
        }
        else if segue.identifier == "go_tourinfo3" {
            let dest = segue.destination as! TourInfo
            dest.This_Tour = find_tour(tourID: ID)
        }
    }

}
