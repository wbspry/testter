//
//  DeviceInfoViewController.swift
//  testter
//
//  Created by yu_yonehara_mac on 2015/09/04.
//  Copyright © 2015年 yyyske3. All rights reserved.
//

import UIKit

class DeviceInfoViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    //セルに表示するテキスト
    var tableDataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let device :UIDevice = UIDevice.currentDevice()
        
        tableDataSource.append(device.batteryLevel.description)
        tableDataSource.append(device.name)
        tableDataSource.append(device.systemName)
        tableDataSource.append(device.systemVersion)
        
        let screen:UIScreen = UIScreen.mainScreen()
        
        tableDataSource.append("scale:\(screen.scale)")
        tableDataSource.append("height:\(screen.bounds.height)")
        
        self.tabBarItem.title = "tabbardesu"
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableDataSource.count
    }
    
    //セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        
        cell.textLabel!.text = tableDataSource[indexPath.row]
        
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        
        print("HelloWorlded!!")
        
        print(isMovingToParentViewController())
        print(isBeingPresented())
        
    }
    
    
}
