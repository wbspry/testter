//
//  ViewController.swift
//  testter
//
//  Created by yu_yonehara_mac on 2015/08/21.
//  Copyright (c) 2015年 yyyske3. All rights reserved.
//

import UIKit

import Accounts
import Social



class ModalViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{
    
    //UITableViewを使用できるようにする
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnTwitter: UIButton!
    
    var accountStore = ACAccountStore()
    var twAccount: ACAccount?
    //セルに表示するテキスト
    var tableDataSource: [(name: String, text: String, date: String, image: String)] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let obj = userDefaults.objectForKey("saveAccount") as? NSData
        if obj != nil{
            //保存データが取得できた場合はボタンを非活性に
            btnTwitter.enabled = false
            
            twAccount = NSKeyedUnarchiver.unarchiveObjectWithData(obj!) as? ACAccount
            
            getTimeline()
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        self.refreshControl.addTarget(self, action: "refreshTable", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.tableView.estimatedRowHeight = 200.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    //テーブルを更新
    func refreshTable(){
        //タイムラインを取得してテーブル更新
        self.getTimeline()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onTouchDown(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tableDataSource.count
    }
    
    //セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell")!
        
        let label1 = cell.viewWithTag(1) as! UILabel
        let textView1 = cell.viewWithTag(2) as! UILabel

        let imageView1 = cell.viewWithTag(3) as! UIImageView
        let imagePath = tableDataSource[indexPath.row].image
        let imageData: NSData = NSData(contentsOfURL: NSURL(string: imagePath)!)!
        imageView1.image = UIImage(data: imageData)
        
        label1.text = tableDataSource[indexPath.row].name
        textView1.text = tableDataSource[indexPath.row].text + " - Posted at " + tableDataSource[indexPath.row].date
        
        return cell
    }
    
    //Cellが選択された場合
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath){

        //選択された行id
        selectedPath = indexPath.row
        
        //TwitterDetailViewControllerへ遷移するためにSegueを呼び出す
        performSegueWithIdentifier("toTwitterDetailViewController", sender: nil)
    }
    
    var selectedPath:Int!
    
    //Segue準備
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        if(segue.identifier == "toTwitterDetailViewController"){
            let tdVC: TwitterDetailViewController = (segue.destinationViewController as? TwitterDetailViewController)!
            tdVC.paramText = tableDataSource[selectedPath].name + ": " + tableDataSource[selectedPath].text + " - Posted at " + tableDataSource[selectedPath].date
       }
    }
    
    @IBAction func onTwitterBtnDown(sender: AnyObject) {
        
        //Twitterアカウントの選択
        selectTwitterAccount()
        
    }
    
    @IBAction func onUpdateBtnDown(sender: AnyObject) {
        
        //Twitterタイムラインの取得
        self.getTimeline()
        
    }
    
    private func selectTwitterAccount(){
        //認証するアカウントのタイプを選択(他にはFacebookやWeiboなどがある)
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil){
         
            (granted: Bool, error:NSError?) -> Void in
            
            if let err = error{
                print("error! \(err)")
                return
            }
            
            if !granted {
                print("error! Twitterアカウントの利用が許可されていません")
                return
            }
            
            let accounts = self.accountStore.accountsWithAccountType(accountType) as! [ACAccount]
            
            if accounts.count == 0 {
                print("error! 設定画面からアカウントを設定してください")
                
                let url = NSURL(string: UIApplicationOpenSettingsURLString)
                UIApplication.sharedApplication().openURL(url!)
                return
                
            }
            
            //取得したアカウントで処理を行う
            
            //とりあえず1個目のアカウントを使う
            
            self.twAccount = accounts[0]
            
            // NSUserDefaultsインスタンスの生成
            let userDefaults = NSUserDefaults.standardUserDefaults()
            // キー: "saveText" , 値: "" を格納。（idは任意）
            userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(accounts[0]), forKey: "saveAccount")
            
            
            //アカウント選択画面を出す -> iPadで場合分けしなきゃいけないので後で
            //self.showAccountSelectSheet(accounts)
            
        }
    }
    
    /**
    アカウント選択のポップアップを表示する
    
    :param: accounts Accountsフレームワークから取得したアカウント
    */
    private func showAccountSelectSheet(accounts: [ACAccount]){
        let alert = UIAlertController(title: "Twitter", message: "アカウントを選択してください", preferredStyle: .ActionSheet)
        
        //アカウント選択のActionSheetを表示するボタン
        for account in accounts{
            alert.addAction(UIAlertAction(title: account.username, style: .Default, handler: {(action) -> Void in
                print("your select account is \(account)")
                self.twAccount = account
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    /**
    タイムラインの取得
    
    選択されているアカウントのhome_timelineを取得します
    */
    private func getTimeline(){
        let URL = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        
        //GET/POSTやパラメータに気をつけてリクエスト情報を生成
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: URL, parameters: nil)
        
        //認証したアカウントをセット
        request.account = twAccount
        
        //APIコールを実行
        request.performRequestWithHandler{(responseData, urlResponse, error) -> Void in
            
            if error != nil {
                print("error is \(error)")
            } else {
                //結果の表示
                
                do {
                    // Try parsing some valid JSON
                    let parsed : NSArray = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.AllowFragments) as! NSArray
                    
                    self.tableDataSource.removeAll()
                    
                    for item in parsed{
                        let userInfo = item["user"] as! NSDictionary
                        self.tableDataSource.append(name:userInfo["name"] as! String, text:item["text"] as! String, date:item["created_at"] as! String, image: userInfo["profile_image_url"] as! String)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
                catch let error as NSError {
                    // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                    print("A JSON parsing error occurred, here are the details:\n \(error)")
                }
            }
        }
    }

}

