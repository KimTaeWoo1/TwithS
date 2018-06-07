//
//  LandmarkInfoVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 25..
//

import UIKit
import Firebase

class LandmarkInfoVC: UITableViewController {

    var ThisLandmark:Landmark_ = Landmark_()
    var tourName = ""
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var landmarkName: UILabel!
    @IBOutlet var TourName: UILabel!
    @IBOutlet var landmarkDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
        let imgName = ThisLandmark.image
        let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
        
        landmarkName.text = ThisLandmark.name
        TourName.text = tourName
        landmarkDetail.text = ThisLandmark.detail
        
        // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
        storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
            if Error != nil {
                // 오류가 발생함.
            } else {
                self.imgView.image = UIImage(data: Data!)
            }
        }
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
        return 3
    }

}
