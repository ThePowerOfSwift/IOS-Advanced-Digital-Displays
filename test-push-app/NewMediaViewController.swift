//
//  NewMediaViewController.swift
//  test-push-app
//
//  Created by Keegan Cruickshank on 26/3/17.
//  Copyright © 2017 Keegan Cruickshank. All rights reserved.
//

import UIKit

class NewMediaViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var campaign: Campaign?
    
    var autorotate = false

    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var declineButton: UIButton!
    
    @IBOutlet weak var image: SLImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let media_url = campaign?.media_url {
            image.downloadedFrom(link: media_url, contentMode: .scaleAspectFit, completionHandler: { (true) in
                self.spinner.isHidden = true
                self.image.isHidden = false
                self.acceptButton.isEnabled = true
                self.declineButton.isEnabled = true
            })
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func declineMedia() {
        print("Not Yet")
        
    }
    
    @IBAction func acceptMedia() {
    }
    
    
    
    override var shouldAutorotate: Bool {
        return self.autorotate;
    }
    

}

extension SLImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completionHandler:@escaping (Bool) -> ()) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                completionHandler(true)
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, completionHandler:@escaping (Bool) -> ()) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode) { (true) in
            completionHandler(true)
        }
    }
}

