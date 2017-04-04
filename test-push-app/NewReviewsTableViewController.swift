//
//  NewReviewsTableViewController.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 28/3/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import UIKit

class NewReviewsTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FirebaseManager.current.verifyingCampaigns!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let new = tableView.dequeueReusableCell(withIdentifier: "CustomNewReviewTableViewCell", for: indexPath) as? CustomNewReviewTableViewCell {
            new.adDescription.text = FirebaseManager.current.verifyingCampaigns![indexPath.row].description
            new.title.text = FirebaseManager.current.verifyingCampaigns![indexPath.row].name
            new.userEmail.text = FirebaseManager.current.verifyingCampaigns![indexPath.row].user_id
            let verified = FirebaseManager.current.verifyingCampaigns![indexPath.row].verification_status
            new.verified.textColor = Color().verifiedColor(verified: verified)
            new.verified.text = verified.capitalized
            cell = new
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(FirebaseManager.current.verifyingCampaigns![indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120.0
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
