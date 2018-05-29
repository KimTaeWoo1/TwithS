//
//  SearchVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 28..
//  Copyright © 2018년 Hanyang University Software Studio 1 TwithS team. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class SearchVC: UITableViewController, UISearchResultsUpdating {
    
    
    let ref = Database.database().reference()
    var tours:[Tour_]  = []
    var filteredTours:[Tour_] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref.child("Tours").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            value?.forEach{ childSnapshot in
                let childData = childSnapshot.value as? NSDictionary
                let tour = Tour_()
                
                tour.name = childData?["name"] as? String ?? ""
                tour.creator = childData?["creator"] as? String ?? ""
                tour.detail = childData?["detail"] as? String ?? ""
                tour.image = childData?["image"] as? String ?? ""
                self.tours.append(tour)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text! == "" {
            filteredTours = tours
        } else {
            // Filter the results
            filteredTours = tours.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
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
        return self.filteredTours.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        cell.textLabel?.text = filteredTours[indexPath.row].name
        cell.detailTextLabel?.text = filteredTours[indexPath.row].detail
        
        // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
        let imgName = filteredTours[indexPath.row].image
        let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
        
        // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
        storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
            if Error != nil {
                // 오류가 발생함.
            } else {
                cell.imageView?.image = UIImage(data: Data!)
            }
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // 투어에 대한 랜드마크 정보 보기
        if segue.identifier == "ShowLandmark" {
            let dest = segue.destination as! TourInfoMainVC
            dest.ThisTour = filteredTours[self.tableView.indexPathForSelectedRow!.row]
            print(dest.ThisTour.landmarks)
        }
    }

}
