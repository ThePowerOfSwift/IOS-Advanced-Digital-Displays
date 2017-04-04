//
//  CampaignManager.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 3/4/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    var ref: FIRDatabaseReference!
    static let current = FirebaseManager.init()
    var campaigns: [Campaign]?
    var verifyingCampaigns: [Campaign]?
    var campaignHandle: UInt?
    var authHandle: FIRAuthStateDidChangeListenerHandle?
    let dispatch = DispatchGroup()
    
    private init() {
        ref = FIRDatabase.database().reference()
        let campaignRef = ref.child("advertisement_data/advertisements")
        dispatch.enter()
        campaignHandle = campaignRef.observe(FIRDataEventType.value, with: { (snapshot) in
            var temp = [Campaign]()
            var verifyingTemp = [Campaign]()
            var dict = snapshot.value as? [String : AnyObject] ?? [:]
            for key in dict.keys {
                let currentCampaign = dict[key]!
                let description = currentCampaign["advertisement_description"] as! String
                let id = currentCampaign["advertisement_id"] as! String
                let media = currentCampaign["advertisement_media"] as! String
                let mediaUrl = currentCampaign["advertisement_media_url"] as! String
                let name = currentCampaign["advertisement_name"] as! String
                let userId = currentCampaign["advertisement_user_id"] as! String
                let verifyingStatus = currentCampaign["advertisement_verification_status"] as! NSDictionary
                let verifying = verifyingStatus["verifying"] as! String
                let campaign = Campaign.init(description: description, id: id, media: media, media_url: mediaUrl, name: name, user_id: userId, verification_status: verifying)
                if verifying == "verifying" {
                    verifyingTemp.append(campaign)
                }
                temp.append(campaign)
            }
            self.verifyingCampaigns = verifyingTemp
            self.campaigns = temp
            self.dispatch.leave()
        })
        
        dispatch.enter()
        authHandle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            self.dispatch.leave()
        }
        
        dispatch.notify(queue: .main) {
            print("done 1")
            // All Services Have Completed, Observable
            
        }
    }
}
