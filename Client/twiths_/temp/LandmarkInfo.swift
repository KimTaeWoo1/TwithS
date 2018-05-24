//
//  LandmarkInfo.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 23..
//

import UIKit

class LDMK_image_cell: UITableViewCell {
    
    @IBOutlet var LDMK_image: UIImageView!
    @IBOutlet var LDMK_label: UILabel!
}

class LandmarkInfo: UITableViewController {

    var This_Landmark:Landmark = DummyData.Landmarks[0] // temp
    
    @IBOutlet var bar1: UINavigationItem!
    @IBOutlet var LDMKInfo: UITableView!
    @IBAction func go_Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func go_Back2(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bar1.title = "랜드마크: " + This_Landmark.Name

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
        return This_Landmark.Image.count + 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row < 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkInfo_Table", for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "랜드마크 이름:"
                cell.detailTextLabel?.text = This_Landmark.Name
                break
            case 1:
                cell.textLabel?.text = "투어 이름:"
                cell.detailTextLabel?.text = This_Landmark.Tour.Name
                break
            case 2:
                cell.textLabel?.text = "랜드마크의 위치:"
                cell.detailTextLabel?.text = This_Landmark.Location
                break
            case 3:
                let GPS = This_Landmark.GPSAddress
                cell.textLabel?.text = "GPS 좌표:"
                cell.detailTextLabel?.text = "위도: \(GPS.WD), 경도: \(GPS.KD)"
                break
            case 4:
                cell.textLabel?.text = "설명:"
                cell.detailTextLabel?.text = This_Landmark.description
                break
            case 5:
                cell.textLabel?.text = "이미지"
                cell.detailTextLabel?.text = ""
                break
            default:
                cell.textLabel?.text = ""
                cell.detailTextLabel?.text = ""
                break
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkInfo_Images", for: indexPath) as! LDMK_image_cell
            cell.LDMK_image.image = UIImage(named: This_Landmark.Image[indexPath.row-6])
            cell.LDMK_label.text = This_Landmark.Image[indexPath.row-6]
            return cell
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
        if segue.identifier == "return_from_landmarkinfo" {
            let dest = segue.destination as! Tour_Landmarks
            dest.ID = This_Landmark.Tour.TourID
            dest.This_Tour = find_tour(tourID: dest.ID)
            dest.Landmark_List = Tour_LandmarkList(A: dest.This_Tour)
        }
        */
    }

}
