//
//  DashboardViewController.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 26/3/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import UIKit

import Firebase

class DashboardViewController: UIViewController {

    @IBOutlet weak var menuBarButtton: UIButton!
    
    @IBOutlet weak var emailBottom: UILabel!
    
    @IBOutlet weak var newReviewsButton: UIButton!
    
    @IBOutlet weak var allReviewsButton: UIButton!
    
    @IBOutlet weak var recentReviewsButton: UIButton!
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        let currentNewReviews = FirebaseManager.current.verifyingCampaigns!.count
        
        let currentAllReviews = FirebaseManager.current.campaigns!.count
        
        newReviewsButton.setTitle("New Reviews ("+currentNewReviews.description+")", for: .normal)
        
        allReviewsButton.setTitle("All Reviews ("+currentAllReviews.description+")", for: .normal)
        let _ = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if let userEmail = user?.email {
                self.emailBottom.text = "Logged in as " + userEmail
                
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    func menuClicked() {
        print("Clicked")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout() {
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logoutSegue" {
            let firebaseAuth = FIRAuth.auth()
            do {
                try firebaseAuth?.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
