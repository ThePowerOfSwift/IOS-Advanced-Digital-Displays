//
//  SettingsViewController.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 31/3/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import UIKit

import Firebase

import LocalAuthentication

class SettingsViewController: UIViewController {

    @IBOutlet weak var touchIDSwitch: UISwitch!
    
    @IBOutlet weak var passcodeSwitch: UISwitch!
    
    @IBOutlet weak var passcodeField: UITextField!
    
    @IBOutlet weak var verifyPasscodeField: UITextField!
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var passcodeView: UIView!
    
    @IBOutlet weak var verifyPasscodeView: UIView!
    
    var user: NSDictionary?
    
    let limitLength = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passcodeView.isHidden = true
        self.verifyPasscodeView.isHidden = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            touchIDSwitch.isEnabled = true
        } else {
            touchIDSwitch.isEnabled = false
        }
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickTouchIDSwitch(_ sender: Any) {
        if let touchIDSwitch = sender as? UISwitch {
            if touchIDSwitch.isOn {
                if passcodeSwitch.isOn {
                    let ac = UIAlertController(title: "Enabling TouchID entry will disable Passcode entry.", message: "Continue?", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                        self.touchIDSwitch.isOn = false;
                    }))
                    ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        self.enableTouchID()
                    }))
                    self.present(ac, animated: false)
                } else {
                    self.enableTouchID()
                }
            } else {
                let ac = UIAlertController(title: "Disabling TouchID entry will result in needing to login with your username and password.", message: "Would you like to continue?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                    self.touchIDSwitch.isOn = true;
                }))
                ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    // DO TURN OFF TOUCHID
                    print("TouchID Turned Off")
                    self.touchIDSwitch.isOn = false;
                }))
                self.present(ac, animated: false)
            }
        }
    }
    
    func enableTouchID() {
        print("Enabling Touch ID")
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Scan your finger to enable TouchID Authentication"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        //TURN ON TOUCH AUTHENTICATION
                        print("Passcode Turned Off")
                        self.passcodeSwitch.isOn = false;
                        let ac = UIAlertController(title: "Success", message: "TouchID authentication enabled", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Okay", style: .default))
                        self.present(ac, animated: false)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func didClickPasscodeSwitch(_ sender: Any) {
        if let passcodeSwitch = sender as? UISwitch {
            if passcodeSwitch.isOn {
                if touchIDSwitch.isOn {
                    let ac = UIAlertController(title: "Enabling passcode entry will disable Touch ID entry.", message: "Continue?", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                        self.passcodeSwitch.isOn = false;
                    }))
                    ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        self.enablePasscode()
                    }))
                    self.present(ac, animated: false)
                } else {
                    self.enablePasscode()
                }
            } else {
                let ac = UIAlertController(title: "Disabling passcode entry will result in needing to login with your username and password.", message: "Would you like to continue?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                    self.passcodeSwitch.isOn = true;
                }))
                ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    // DO TURN OFF PASSCODE
                    print("Passscode Turned Off")
                    self.passcodeSwitch.isOn = false;
                }))
                self.present(ac, animated: false)
            }
        }
    }
    
    func enablePasscode() {
        if let currentUser = FIRAuth.auth()?.currentUser {
            let userUid = currentUser.uid
            self.showPasscodeCreate(id: userUid)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = passcodeField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    func showPasscodeCreate(id: String)  {
        self.passcodeField.becomeFirstResponder()
        self.passcodeView.isHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(verifyPasscode))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPasscodeWithCancel))
    }
    
    func cancelPasscodeWithCancel() {
        self.passcodeSwitch.isOn = false
        cancelPasscode()
    }
    
    func cancelPasscodeWithSuccess() {
        print("TouchID Turned Off")
        self.touchIDSwitch.isOn = false;
        cancelPasscode()
    }
    
    func cancelPasscode() {
        self.passcodeView.isHidden = true
        self.verifyPasscodeView.isHidden = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        self.passcodeField.resignFirstResponder()
        self.verifyPasscodeField.resignFirstResponder()
        
    }
    
    func verifyPasscode() {
        if passcodeField.text?.characters.count == 4 {
            self.verifyPasscodeField.becomeFirstResponder()
            self.verifyPasscodeView.isHidden = false
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirmPasscode))
        } else {
            print("Passcode Needs To Be 4 Numbers")
        }
    }
    
    func confirmPasscode() {
        if passcodeField.text == verifyPasscodeField.text {
            cancelPasscodeWithSuccess()
        } else {
            print("Passcodes do not match")
        }
    }
    
    func logout() {
        do {
            try FIRAuth.auth()?.signOut()
            self.performSegue(withIdentifier: "logout", sender: nil)
        } catch {
            print("error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
