//
//  TourInfoVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//

import UIKit
import Firebase

class TourInfoVC: UITableViewController {
    
    let db = Firestore.firestore()
    let cal = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
    var ThisTour = Tour_()
    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
        let imgName = ThisTour.image
        let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
        
        // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
        storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
            if Error != nil {
                // 오류가 발생함.
            } else {
                self.imgView.image = UIImage(data: Data!)
            }
        }

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
        return 9
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourInfo_Table", for: indexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "투어 이름:"
            cell.detailTextLabel?.text = ThisTour.name
            break
        case 1:
            cell.textLabel?.text = "테마:"
            cell.detailTextLabel?.text = ""
            break
        case 2:
            cell.textLabel?.text = "만든이:"
            cell.detailTextLabel?.text = ThisTour.creator
            break
        case 3:
            let date = ThisTour.createDate
            let year = cal!.component(NSCalendar.Unit.year, from: date)
            let month = cal!.component(NSCalendar.Unit.month, from: date)
            let day = cal!.component(NSCalendar.Unit.day, from: date)
            
            cell.textLabel?.text = "만든 날짜:"
            cell.detailTextLabel?.text = "\(year)년 \(month)월 \(day)일"
            break
        case 4:
            let date = ThisTour.updateDate
            let year = cal!.component(NSCalendar.Unit.year, from: date)
            let month = cal!.component(NSCalendar.Unit.month, from: date)
            let day = cal!.component(NSCalendar.Unit.day, from: date)
            
            cell.textLabel?.text = "수정한 날짜:"
            cell.detailTextLabel?.text = "\(year)년 \(month)월 \(day)일"
            break
        case 5:
            cell.textLabel?.text = "제한시간:"
            cell.detailTextLabel?.text = "\(ThisTour.timeLimit / 1440)일 \((ThisTour.timeLimit / 60) % 24)시간 \(ThisTour.timeLimit % 60)분"
            break
        case 6:
            cell.textLabel?.text = "투어 정보:"
            cell.detailTextLabel?.text = ThisTour.detail
            break
        case 7:
            cell.textLabel?.text = "별점:"
            /*
            let stars:[Int] = This_Tour.Reviews.map({$0.Stars})
            let sum:Int = stars.reduce(0, +)
            var avg:Double = 0.0
            if stars.count > 0 { avg = Double(sum) / Double(stars.count) }
            cell.detailTextLabel?.text = "\(avg) / 5.0 (\(This_Tour.Reviews.count)개의 리뷰)"
            */
            break
        case 8:
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
