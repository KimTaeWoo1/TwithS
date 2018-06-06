//
//  CreateReviewNavigationVC.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 6. 6..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit

class CreateReviewNavigationVC: UIViewController {
    var tour = Tour_()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let controller = segue.destination as? UINavigationController, let childVC = controller.topViewController as? CreateReviewVC {
            childVC.tour = tour
        }
    }
    

}
