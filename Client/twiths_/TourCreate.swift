//
//  TourCreate.swift
//  twiths_
//
//  Created by ㅇㅇ on 2018. 5. 21..
//

import UIKit

class TourCreate: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var TourNameBox: UITextField!
    
    @IBOutlet var Minute: UITextField!
    @IBOutlet var Hour: UITextField!
    
    @IBOutlet var Descript: UITextField!
    var Mode:Int = 0 // 0: Tour Create / 1: Tour Edit
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 생성하려는 투어에 있는 랜드마크의 개수를 구한다.
        return NewTour.Landmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var picture_list:[String] = [] // 사진 목록
        
        // 사용자가 진행 중인 해당 투어에 있는 각 랜드마크의 사진의 목록을 작성한다.
        // 목록을 저장하기 위한 배열 이름은 picture_list
        for i in 0..<NewTour.Landmarks.count {
            if NewTour.Landmarks[i].Image.count > 0 {
                picture_list.append(NewTour.Landmarks[i].Image[0])
            }
        }
        
        // 셀(테이블의 칸이 아니라, 컬렉션 뷰의 각 정사각형 모양의 칸)에 이미지를 출력한다.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Proceed_Reuse", for: indexPath)
        
        let IV:UIImageView = UIImageView(frame:CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: 80, height: 80))
        let img:UIImage = UIImage(named: picture_list[indexPath.row])!
        IV.image = img
        cell.addSubview(IV)
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Mode == 1 {self.title = "투어 편집하기"}

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
        return max(1, NewTour.Landmarks.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourCreate_Reuse", for: indexPath)
        
        if NewTour.Landmarks.count < 1 {
            cell.textLabel?.text = "랜드마크를 추가하세요."
        }
        else {
            let x = NewTour.Landmarks[indexPath.row]
            
            cell.textLabel?.text = x.Name
            if x.Image.count > 0 {
                cell.imageView?.image = UIImage(named: x.Image[0])
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
        
        if segue.identifier == "Upload_Tour" {
            
            // 투어 이름, 시간의 값을 텍스트박스에서 구하기
            let TN:String = TourNameBox.text!
            guard let Hours:Int = Int(Hour.text!) else {
                return
            }
            guard let Minutes:Int = Int(Minute.text!) else {
                return
            }
            
            // 새로운 투어 만들기
            let date_string = DateFormatter().string(from: Date())
            let year_now = Int(date_string.split(separator: "-")[0])
            let month_now = Int(date_string.split(separator: "-")[1])
            let day_now = Int(date_string.split(separator: "-")[2])
            
            let newT:Tour = Tour(NAME: TN, ID: 0, User: DummyData.Logined, Created: Date_ymd(year: year_now!, month: month_now!, day: day_now!), Updated: Date_ymd(year: year_now!, month: month_now!, day: day_now!), Limit: Hours * 60 + Minutes, Image: NewTour.Landmarks[0].Image, descrip: Descript.text!, MapImage: "asdf")
            DummyData.Tours.append(newT)
            
            // 새로운 투어에 넣을 랜드마크 추가하기
            for i in 0..<NewTour.Landmarks.count {
                let NTLMK = NewTour.Landmarks[i]
                let newLandmark:Landmark = Landmark(NAME: NTLMK.Name, TOUR: newT, LOC: NTLMK.Location, GPS: NTLMK.GPSAddress, descrip: NTLMK.description, Image: NTLMK.Image)
                DummyData.Landmarks.append(newLandmark)
            }
            
            // NewTour를 초기화하기
            NewTour.initialize()
        }
    }

}
