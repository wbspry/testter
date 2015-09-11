//
//  ViewController.swift
//  testter
//
//  Created by yu_yonehara_mac on 2015/08/21.
//  Copyright (c) 2015年 yyyske3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tableView : UITableView?
    
    @IBOutlet weak var lblDisp: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HelloWorld!!")
        
        let header = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 64))
        header.image = UIImage(named: "header")

        let title = UILabel(frame: CGRect(x: 10, y: 20, width: 310, height: 44))
        title.text = "ToDoリスト"
        header.addSubview(title)
        
        let screenWidth = UIScreen.mainScreen().bounds.size.height
        self.tableView = UITableView(frame: CGRect(x: 0, y: 60, width: 320, height: screenWidth - 60))
        

        self.view.addSubview(header)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func variousButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Various", bundle: nil)
        let splitVC = storyboard.instantiateViewControllerWithIdentifier("VariousViewController") as! UISplitViewController
        splitVC.preferredDisplayMode = .AllVisible
        splitVC.delegate = self
        self.presentViewController(splitVC, animated: true, completion: nil)
    }
    
    @IBAction func variousViewReturnActionForSegue(segue: UIStoryboardSegue) {
        segue.sourceViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("view消えるよ")
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("view消えたよ")
    }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        print("かわったよ")
    }
}

extension ViewController: UISplitViewControllerDelegate {
    func splitViewController(splitViewController: UISplitViewController,
        showDetailViewController vc: UIViewController, sender: AnyObject?) -> Bool {
            // UISplitViewController#showDetailViewController()を呼ばれた時に呼ばれる
            return false
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        return true
    }
}
