//
//  SeeAnime.swift
//  Test Applaudo Sergio Zorrilla
//
//  Created by Sergio Eduardo Zorrilla Arellano on 19/08/17.
//  Copyright © 2017 Bodoque Inc. All rights reserved.
//

import UIKit

class SeeAnime: UIViewController {

    @IBOutlet weak var lblNameAnime: UILabel!
    @IBOutlet weak var wvVideo: UIWebView!
    @IBOutlet weak var tvDescription: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UserDefaults.standard.object(forKey: "title") as? String
        let video = UserDefaults.standard.object(forKey: "video") as? String
        let synopsis = UserDefaults.standard.object(forKey: "synopsis") as? String
        
        lblNameAnime.text = title
        tvDescription.text = synopsis
        
        print(video!)
        
        guard let youtubeUrl = NSURL(string: "https://www.youtube.com/embed/\(video!)") else {
            return
        }
        
        wvVideo.loadRequest(NSURLRequest(url: youtubeUrl as URL) as URLRequest)

        // Do any additional setup after loading the view.
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
