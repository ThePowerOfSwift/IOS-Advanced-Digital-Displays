//
//  ViewController.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 25/3/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import UIKit

import Firebase

import LocalAuthentication

import AudioToolbox

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var LoginIndicator: UIView!
    
    @IBOutlet weak var passcodeField: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var authText: UILabel!
    
    @IBOutlet weak var authenticatingView: UIView!
    
    @IBOutlet weak var passcodeView: UIView!
    
    var passcode: String?
    
    var ref: FIRDatabaseReference!
    
    let limitLength = 4
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height/2.5)
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += (keyboardSize.height/2.5)
            }
        }
    }
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        LoginIndicator.isHidden = true
        passcodeView.isHidden = true
        button.layer.cornerRadius = 20
        LoginIndicator.layer.cornerRadius = 20
        let whiteColor : UIColor = UIColor( red: 236/255, green: 240/255, blue:241/255, alpha: 0.5 )
        username.placeHolderColor = whiteColor
        password.placeHolderColor = whiteColor
        self.ref = FIRDatabase.database().reference()
        super.viewDidLoad()
        username.delegate = self
        password.delegate = self
        if let currentUser = FIRAuth.auth()?.currentUser {
            let userUid = currentUser.uid
            self.ref.child("user_data/users").child(userUid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let permission = value?["permission_level"] as? String ?? ""
                if permission == "Admin" {
                    if let appSettings = value?["app_settings"] as? NSDictionary, let method = appSettings["login_method"] as? String, let passcode = appSettings["app_passcode"] as? String {
                        if method == "passcode" {
                            self.passcode = passcode
                        }
                    }
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let fromNotification = appDelegate.gotNotification
                    if !fromNotification {
                        let name = value?["first_name"] as? String ?? ""
                        self.authenticateUser(name: name)
                    }
                } else {
                    
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        } else {
            self.authenticatingView.isHidden = true
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func authenticateUser(name: String) {
        authText.text = "Authenticating user with fingerprint"
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Welcome back " + name + ", Scan your finger"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.runSecretCode()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            print(passcode!)
            if let passcode = passcode {
                self.presentPasscodeConfirm(passcode: passcode)
            } else {
                let ac = UIAlertController(title: name + " login faster", message: "You can now use your Touch ID or a passcode to login faster. Check it out in the options menu after logging in.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: {
                    (success) in
                    self.authenticatingView.isHidden = true
                })
                )
                present(ac, animated: true)
            }
            
        }
    }
    
    
    @IBAction func passcodeDidChange(_ sender: Any) {
        if let text = (sender as? UITextField)?.text {
            if text.characters.count == 4 {
                if text == passcode! {
                    self.runSecretCode()
                } else {
                    print("You Stupid Fuck")
                }
            }
        }
        print((sender as! UITextField).text!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = passcodeField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    func presentPasscodeConfirm(passcode: String) {
        passcodeView.isHidden = false
        authenticatingView.isHidden = true
        self.passcodeField.becomeFirstResponder()
        
    }
    
    func runSecretCode() {
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
        self.authenticatingView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginClicked() {
        LoginIndicator.isHidden = false
        FIRAuth.auth()?.signIn(withEmail: username.text!, password: password.text!) { (user, error) in
            if (user as FIRUser!) != nil {
                self.LoginIndicator.isHidden = true
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                self.authenticatingView.isHidden = true
            } else if let error = error {
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.LoginIndicator.isHidden = true
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "loginSegue" {
            print("Logged in, redierecting...")
        }
    }
    
    @IBAction func didPressNext() {
     password.becomeFirstResponder()
    }
    
    
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
}

