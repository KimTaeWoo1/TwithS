//
//  TourInfoTourVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 31..
//  Copyright © 2018년 Hanyang University Software Studio 1 TwithS Team. All rights reserved.
//

import UIKit
import Firebase

class TourInfoTourVC: UITableViewController {
    @IBOutlet var imgView: UIImageView!
    var ThisTour:Tour_ = Tour_()
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TITourInfo", for: indexPath)

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
            cell.textLabel?.text = "만든 날짜:"
            cell.detailTextLabel?.text = "\(ThisTour.createDate)"
            break
        case 4:
            cell.textLabel?.text = "수정한 날짜:"
            cell.detailTextLabel?.text = "\(ThisTour.updateDate)"
            break
        case 5:
            cell.textLabel?.text = "제한시간:"
            cell.detailTextLabel?.text = "\(ThisTour.timeLimit / 1440)일 \((ThisTour.timeLimit / 60) % 24)시간 \(ThisTour.timeLimit % 60)분"
            break
        case 6:
            cell.textLabel?.text = "대표 사진"
            cell.imageView?.image = UIImage(named: ThisTour.image)
            cell.detailTextLabel?.text = ""
            break
        case 7:
            cell.textLabel?.text = "투어 정보:"
            cell.detailTextLabel?.text = ThisTour.detail
            break
        case 8:
            /* Tour_ 클래스에 Review 배열이 없으므로 리뷰 목록에서 직접 찾아야 하는데,
             전체 리뷰 목록을 저장하는 자료구조가 Model.swift에 없으므로 보류 */
            cell.textLabel?.text = "별점:"
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
