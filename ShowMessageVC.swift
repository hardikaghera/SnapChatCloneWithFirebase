//
//  ShowMessageVC.swift
//  SnapChatCloneWithFirebase
//
//  Created by hardik aghera on 01/04/18.
//  Copyright © 2018 hardikaghera2306. All rights reserved.
//

import AVKit
import AVFoundation
import UIKit

class ShowMessageVC: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    
    private let avPlayerVC = AVPlayerViewController()
    var avPlayer: AVPlayer?
    
    var mediaURL = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        // Do any additional setup after loading the view.
    }
    
    private func loadImage() {
        
        if let url = URL(string: mediaURL) {
            let request = NSMutableURLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, err) in
                if err != nil {
                    
                } else {
                    if data != nil {
                        if let img = UIImage(data: data!) {
                            self.myImageView.image = img
                        } else {
                            self.avPlayer = AVPlayer(url: url)
                            self.avPlayerVC.player = self.avPlayer
                            self.present(self.avPlayerVC, animated: true, completion: nil)
                        }
                    }
                }
            })
            task.resume()
            
        }
        
        
    }

    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
} // class  
