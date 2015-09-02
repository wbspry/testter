//
//  TwitterDetailViewController.swift
//  testter
//
//  Created by yu_yonehara_mac on 2015/09/02.
//  Copyright © 2015年 yyyske3. All rights reserved.
//

import UIKit

class TwitterDetailViewController: UIViewController {

    @IBOutlet weak var txtTweetDetail: UITextView!
    var paramText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTweetDetail.text = paramText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onBtnCloseTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
