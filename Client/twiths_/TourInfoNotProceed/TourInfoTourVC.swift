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
    let cal = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
    
    @IBOutlet var tourName: UILabel!
    @IBOutlet var tourCreateDate: UILabel!
    @IBOutlet var tourDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 셀에 이미지를 불러오기 위한 이미지 이름, 저장소 변수
        let imgName = ThisTour.image
        let storRef = Storage.storage().reference(forURL: "gs://twiths-350ca.appspot.com").child(imgName)
        
        // 셀에 이미지 불러오기. 임시로 64*1024*1024, 즉 64MB를 최대로 하고, 논의 후 변경 예정.
        storRef.getData(maxSize: 64 * 1024 * 1024) { Data, Error in
            if Error != nil {
                // 오류가 발생함.
            } else if let Data = Data {
                self.imgView.image = UIImage(data: Data)
            }
        }
        
        tourName.text = ThisTour.name
        
        let date = ThisTour.createDate
        guard let cale = cal else { return }
        let year = cale.component(NSCalendar.Unit.year, from: date)
        let month = cale.component(NSCalendar.Unit.month, from: date)
        let day = cale.component(NSCalendar.Unit.day, from: date)
        tourCreateDate.text = "\(year)년 \(month)월 \(day)일"
        tourCreateDate.text = String(format: NSLocalizedString(" %@ %d, %d", comment: ""),makeMonth(month), day, year)
        
        tourDetail.text = ThisTour.detail
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
