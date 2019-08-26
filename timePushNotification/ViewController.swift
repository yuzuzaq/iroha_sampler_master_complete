//
//  ViewController.swift
//  timePushNotification
//
//  Created by tatsumi kentaro on 2018/08/30.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import RealmSwift
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let realm = try! Realm()
    var contentsArray = [dateData]()
    
    
    @IBOutlet weak var table1: UITableView!
    
//    var data = [AlertData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table1.delegate = self
        table1.dataSource = self

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentsArray = [dateData]()
        //realmデータを全て取り出し
        let data = realm.objects(AlertData.self)
        //realmデータを一つずつ取り出しcontentsArrayに追加
        data.forEach { (diff) in
            contentsArray.append(dateData(title: diff.title, contents: diff.contents, month: diff.month, day: diff.day))
        }
        table1.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = contentsArray[indexPath.row].title
        return cell
    }
    
    
}
//realmオブジェクトを設定
class dateData{
    var title:String!
    var contents:String!
    var month:Int!
    var day:Int!
    init(title:String,contents:String,month:Int,day:Int) {
        self.title = title
        self.contents = contents
        self.month = month
        self.day = day
    }
}

