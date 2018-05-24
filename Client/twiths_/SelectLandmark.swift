//
//  SelectLandmark.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 21..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit

class SelectLandmark: UITableViewController {
    
    var Landmarks2:[Landmark] = []
    
    @IBOutlet var SelectLandmarkTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Landmarks2 = remove_duplicate(A: DummyData.Landmarks)

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

    // 랜드마크 목록에서 이름 기준으로 중복된 항목 제거
    func remove_duplicate(A:[Landmark]) -> [Landmark] {
        var Landmarks2:[Landmark] = DummyData.Landmarks.sorted(by: {$0.Name < $1.Name})
        var index:Int = 1
        while index < Landmarks2.count {
            if Landmarks2[index].Name == Landmarks2[index-1].Name {
                Landmarks2.remove(at: index)
            }
            index += 1
        }
        return Landmarks2
    }
    
    // 중복된 항목이 제거된 랜드마크 목록의 행이, 중복을 제거하기 전의 랜드마크 목록의 몇 행에 대응되는지 구하기
    func uniq_to_dup (a:Int) -> Int {
        for i in 0..<DummyData.Landmarks.count {
            if DummyData.Landmarks[i].Name == Landmarks2[a].Name {
                return i
            }
        }
        return -1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // 랜드마크 목록에서 중복된 이름을 제거하기(Landmarks2)
        let Landmarks2:[Landmark] = remove_duplicate(A: DummyData.Landmarks)
        return Landmarks2.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Landmark_Select_Reuse", for: indexPath)
        
        // 랜드마크 목록에서 중복된 이름을 제거하기(Landmarks2)
        var Landmarks2:[Landmark] = remove_duplicate(A: DummyData.Landmarks)

        // 중복된 이름을 제거한 결과를 출력하기
        cell.textLabel?.text = Landmarks2[indexPath.row].Name
        cell.detailTextLabel?.text = Landmarks2[indexPath.row].description
        if Landmarks2[indexPath.row].Image.count > 0 {
            cell.imageView?.image = UIImage(named: Landmarks2[indexPath.row].Image[0])
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
        if segue.identifier == "Add_Landmark" {
            let selindex = uniq_to_dup(a: SelectLandmarkTable.indexPathForSelectedRow!.row)
            NewTour.Landmarks.append(DummyData.Landmarks[selindex])
        }
    }

}
