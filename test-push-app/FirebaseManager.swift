//
//  CampaignManager.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 3/4/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import Foundation
import Firebase

class CampaignManager {
    
    var ref: FIRDatabaseReference!
    static let current = CampaignManager()
    var campaigns: [Campaign]?
    var dict: [String : AnyObject]?
    var campaignHandle: UInt?
    var initList = Array(arrayLiteral: false)
    
    init() {
        ref = FIRDatabase.database().reference()
        let campaignRef = ref.child("advertisement_data/advertisements")
        campaignHandle = campaignRef.observe(FIRDataEventType.value, with: { (snapshot) in
            self.dict = snapshot.value as? [String : AnyObject] ?? [:]
            self.initList[0] = true
        })
    }

    
}
