//
//  LandmarkListVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//
// 임시로 이전 데이터베이스 양식을 이용하므로 나중에 수정이 필요함.

import UIKit

class LandmarkCell: UITableViewCell {
    @IBOutlet var LandmarkImage: UIImageView!
    @IBOutlet var LandmarkTitle: UILabel!
    @IBOutlet var LandmarkDescription: UILabel!
}

class LandmarkListVC: UITableViewController {

    var ID:Int = 0
    var userTourRelation = UserTourRelation_()
    
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
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LandmarkListREUSE", for: indexPath) as! LandmarkCell

        
        // 실제로 이미지를 적용하려면 Assets.xcassets에 추가해야 함
        

        return cell
    }
    
    // 테이블 뷰 셀의 세로 길이 설정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 127.0
    }
    
    @IBAction func TourListToLandmarkInfo(segue: UIStoryboardSegue){
        
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
        
        // 투어 정보 보기
        if segue.identifier == "TourInfoGO" {
            let dest = segue.destination as! UINavigationController
            let destTarget = dest.topViewController as! TourInfoVC  
            
        }
            
        // 랜드마크 정보 보기
        else if segue.identifier == "LandmarkInfoGO" {
            let dest = segue.destination as! UINavigationController
            let destTarget = dest.topViewController as! LandmarkInfoVC
            
        }
    }

}
