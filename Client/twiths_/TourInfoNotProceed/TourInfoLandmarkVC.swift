//
//  TourInfoLandmarkVC.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 31..
//  Copyright © 2018년 Hanyang University Software Studio 1 TwithS Team. All rights reserved.
//

import UIKit
import Firebase

class TourInfoLandmarkVC: UITableViewController {
    @IBOutlet var imgView: UIImageView!
    
    // Tour_ 클래스에 있는 랜드마크의 자료형이 Landmark_가 아닌 Landmark이기 때문에 임시로 이렇게 함.
    var ThisLandmark:Landmark_ = Landmark_()
    var TourName:String = ""

    @IBOutlet var landmarkName: UILabel!
    @IBOutlet var tourName: UILabel!
    @IBOutlet var landmarkDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
        let imgName = ThisLandmark.image
        let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
        
        // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
        storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
            if Error != nil {
                // 오류가 발생함.
            } else if let Data = Data {
                self.imgView.image = UIImage(data: Data)
            }
        }
        
        landmarkName.text = ThisLandmark.name
        tourName.text = TourName
        landmarkDetail.text = ThisLandmark.detail
        
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
