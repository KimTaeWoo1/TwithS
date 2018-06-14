//
//  LoginViewController.swift
//  twiths_
//
//  Created by yeon suk choi on 2018. 5. 24..
//  Copyright © 2018년 yeon suk choi. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class LoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
 
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let app = FirebaseApp.app() {
            GIDSignIn.sharedInstance().clientID = app.options.clientID
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
        }

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if Auth.auth().currentUser != nil, let storyboard = self.storyboard {
            let vc = storyboard.instantiateViewController(withIdentifier: "Home")
            self.present(vc, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func LoginButtonClicked(_ sender: Any) {
        if self.emailTextField.text == "" || self.PasswordTextField.text == "" {
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in

            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else if let email = self.emailTextField.text, let pwd = self.PasswordTextField.text, let storyboard = self.storyboard {
            Auth.auth().signIn(withEmail: email, password: pwd) { (user, error) in
                
                if error == nil {
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    //Go to the HomeViewController if the login is sucessful
                    let vc = storyboard.instantiateViewController(withIdentifier: "Home")
                    self.present(vc, animated: true, completion: nil)
                } else {
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    guard let error = error else { return }
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential){ (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("User loggind in with google...")
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
    
    @IBAction func FacebookLoginButtonClicked(_ sender: Any) {
        let fbLoginManager = FBSDKLoginManager()
        

        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential, completion: {(user, error) in
                if error != nil {
                    print("error #1\(error?.localizedDescription)!")
                    return
                }
            })
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                print("facebook login success!.")
                // Present the main view
                if let storyboard = self.storyboard {
                    let vc = storyboard.instantiateViewController(withIdentifier: "Home")
                    self.present(vc, animated: true, completion: nil)
                }
            })
            
        }
    }
    
}
