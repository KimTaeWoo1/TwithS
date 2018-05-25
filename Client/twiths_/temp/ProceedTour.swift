//
//  ProceedTour.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 21..
//

import UIKit

/*
class ProceedCell:UITableViewCell {
    @IBOutlet var proceed_box: UIView!
}

class ProceedTour: UITableViewController {
    @IBOutlet var title_text: UINavigationItem!
    
    var all_landmarks:[[Landmark]] = [] // 사용자가 진행 중인 모든 투어에 있는 랜드마크 목록을 합친 배열
    var data_added:Int = 0 // all_landmarks_data_add()가 실행을 시작했는지의 여부
    
    // 각 랜드마크에 대하여 사용자가 진행 중인 투어에 있는지 찾고, 있으면 추가한다.
    func all_landmarks_data_add() {
        if data_added == 1 { return }
        data_added = 1
        for i in 0..<DummyData.Logined.ProceedingTours.count {
            
            var tour_landmarks:[Landmark] = [] // 진행 중인 특정 투어에 있는 랜드마크의 배열
            for j in 0..<DummyData.Landmarks.count {
                
                // 투어의 ID가 일치하면 해당 랜드마크를 추가
                if DummyData.Landmarks[j].Tour.TourID == DummyData.Logined.ProceedingTours[i].Tour.TourID {
                    tour_landmarks.append(DummyData.Landmarks[j])
                }
            }
            if tour_landmarks.count > 0 { all_landmarks.append(tour_landmarks) }
        }
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 사용자가 진행 중인 해당 투어에 있는 랜드마크의 개수를 구한다.
        var a:Int = 0
        for i in 0..<DummyData.Landmarks.count {
            if DummyData.Landmarks[i].Tour.TourID == DummyData.Logined.ProceedingTours[section].Tour.TourID {
                a += 1
            }
        }
        return a
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var picture_list:[String] = [] // 사진 목록
        
        // 사용자가 진행 중인 해당 투어에 있는 각 랜드마크의 사진의 목록을 작성한다.
        // 목록을 저장하기 위한 배열 이름은 picture_list
        for i in 0..<DummyData.Landmarks.count {
            for j in 0..<DummyData.Logined.ProceedingTours.count {
                if DummyData.Landmarks[i].Tour.TourID == DummyData.Logined.ProceedingTours[j].Tour.TourID {
                    picture_list = picture_list + DummyData.Landmarks[i].Image
                }
            }
        }
        title_text.title? = picture_list[0]
        
        // 셀(테이블의 칸이 아니라, 컬렉션 뷰의 각 정사각형 모양의 칸)에 이미지를 출력한다.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Proceed_Reuse", for: indexPath)
        
        let IV:UIImageView = UIImageView(frame:CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: 80, height: 80))
        let img:UIImage = UIImage(named: picture_list[indexPath.row])!
        IV.image = img
        cell.addSubview(IV)
        
        return cell
    }
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title_text.title? = "\(DummyData.Logined.ProceedingTours.count)개의 투어 진행 중"

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

    // 해당 투어에 있는 랜드마크의 개수를 구한다.
    func get_landmark_count (A:Tour) -> Int {
        var a:Int = 0
        for i in 0..<DummyData.Landmarks.count {
            if DummyData.Landmarks[i].Tour.TourID == A.TourID {
                a += 1
            }
        }
        return a
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // 사용자가 진행 중인 투어의 개수를 구한다.
        return DummyData.Logined.ProceedingTours.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // 사용자가 진행 중인, 각각의 투어에 있는 랜드마크의 개수를 구한다.
        return get_landmark_count(A: DummyData.Logined.ProceedingTours[section].Tour)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourCell", for: indexPath) as! ProceedCell
        
        all_landmarks_data_add() // 랜드마크 데이터를 추가한다.
        
        let ldmk = all_landmarks[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = ldmk.Name
        if ldmk.Image.count > 0 {
            cell.imageView?.image = UIImage(named: ldmk.Image[0])
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DummyData.Logined.ProceedingTours[section].Tour.Name
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section:Int) -> String? {
        return "랜드마크 개수: \(get_landmark_count(A: DummyData.Logined.ProceedingTours[section].Tour))"
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
        if segue.identifier == "tour_detail" {
            let dest = segue.destination as! Tour_Landmarks
            let selindex = self.tableView.indexPathForSelectedRow?.section
            dest.ID = DummyData.Logined.ProceedingTours[selindex!].Tour.TourID
            dest.This_Tour = find_tour(tourID: dest.ID)
            dest.Landmark_List = Tour_LandmarkList(A: dest.This_Tour)
        }
        else if segue.identifier == "tour_edit" {
            let dest = segue.destination as! TourCreate
            dest.Mode = 1
        }
    }

}
 */
