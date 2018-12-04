//
//  TableViewController.swift
//  Assignment_04
//
//  Created by Devon on 2018-12-04.
//  Copyright © 2018 PROG31975. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let getData = GetData()
    var timer : Timer!
    @IBOutlet var myTable : UITableView!
    
    ///// TableView content.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Initially, there are 0 rows of data. Only once DB has returned data will there be more rows.
        if (getData.dbData != nil) {
            return (getData.dbData?.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Height of cells in TableView.
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Displays cells.
        
        // Obtain or create new cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? MyDataTableViewCell ?? MyDataTableViewCell(style: .default, reuseIdentifier: "myCell")
        
        // Obtain Post to display.
        let row = indexPath.row
        let rowData = (getData.dbData?[row])! as NSDictionary
        
        cell.myScore.text = rowData["Score"] as? String
        cell.myName.text = rowData["Name"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Onclick handling.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Repeat call every 0.4 seconds, refreshing table until DB returns data.
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.4,
            target: self,
            selector: #selector(self.refreshTable),
            userInfo: nil,
            repeats: true)
        
        getData.jsonParser()
    }
    
    @objc func refreshTable() {
        // If DB returned data update TableView.
        if (getData.dbData != nil) {
            if (getData.dbData?.count)! > 0 {
                self.myTable.reloadData()
                self.timer.invalidate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
