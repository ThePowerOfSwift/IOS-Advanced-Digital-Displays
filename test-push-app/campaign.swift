//
//  campaign.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 26/3/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import Foundation



class Campaign {
    var description: String
    var id: String
    var media: String
    var media_url: String
    var name: String
    var user_id: String
    var verification_status: String
    
    
    init(description: String, id: String, media: String, media_url:String, name: String, user_id: String,verification_status: String){
        self.description = description
        self.id = id
        self.media = media
        self.media_url = media_url
        self.name = name
        self.user_id = user_id
        self.verification_status = verification_status
    }
}
