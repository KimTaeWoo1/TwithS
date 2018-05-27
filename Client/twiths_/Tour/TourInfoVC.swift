//
//  TourInfoVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//

import UIKit

class MapImageCell: UITableViewCell {
    
    @IBOutlet var MapImg: UIImageView!
}

class TourInfoVC: UITableViewController {
    
    var This_Tour:Tour = Empty_Tour

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 11
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TourInfo_Table", for: indexPath)
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "투어 이름:"
                cell.detailTextLabel?.text = This_Tour.Name
                break
            case 1:
                cell.textLabel?.text = "테마:"
                cell.detailTextLabel?.text = ""
                break
            case 2:
                cell.textLabel?.text = "만든이:"
                cell.detailTextLabel?.text = This_Tour.Admin.Nickname
                break
            case 3:
                cell.textLabel?.text = "만든 날짜:"
                cell.detailTextLabel?.text = "\(This_Tour.Created.year)/\(This_Tour.Created.month)/\(This_Tour.Created.day)"
                break
            case 4:
                cell.textLabel?.text = "수정한 날짜:"
                cell.detailTextLabel?.text = "\(This_Tour.Updated.year)/\(This_Tour.Updated.month)/\(This_Tour.Updated.day)"
                break
            case 5:
                cell.textLabel?.text = "제한시간:"
                cell.detailTextLabel?.text = "\(This_Tour.TimeLimit / 60)시간 \(This_Tour.TimeLimit % 60)분"
                break
            case 6:
                cell.textLabel?.text = "대표 사진"
                if This_Tour.Image.count > 0 {
                    cell.imageView?.image = UIImage(named: This_Tour.Image[0])
                    cell.detailTextLabel?.text = ""
                }
                else {
                    cell.detailTextLabel?.text = "사진 없음"
                }
                break
            case 7:
                cell.textLabel?.text = "투어 정보:"
                cell.detailTextLabel?.text = This_Tour.description
                break
            case 8:
                cell.textLabel?.text = "별점:"
                let stars:[Int] = This_Tour.Reviews.map({$0.Stars})
                let sum:Int = stars.reduce(0, +)
                var avg:Double = 0.0
                if stars.count > 0 { avg = Double(sum) / Double(stars.count) }
                cell.detailTextLabel?.text = "\(avg) / 5.0 (\(This_Tour.Reviews.count)개의 리뷰)"
                break
            case 9:
                cell.textLabel?.text = "투어 지도"
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Tour_MapImage", for: indexPath) as! MapImageCell
            cell.MapImg.image = UIImage(named: This_Tour.MapImage)
            
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
