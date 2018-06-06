//
//  SignupViewController.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 24..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var DisplayNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func SignupButtonClicked(_ sender: Any) {
        if emailTextField.text == "" || PasswordTextField.text == "" || DisplayNameTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: PasswordTextField.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
                    //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                    let user = Auth.auth().currentUser;
                    let changeRequest = user?.createProfileChangeRequest()
                    changeRequest?.displayName =  self.DisplayNameTextField.text
                    changeRequest?.commitChanges { error in
                        if let error = error {
                            print(error)
                        }
                        else {
                            
                        }
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
