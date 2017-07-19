//
//  ViewController.swift
//  uploadClj
//
//  Created by clj on 17/7/17.
//  Copyright © 2017年 clj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("start")

        checkFileUpdate()
        uploadTest()
        
        
        print("finish")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkFileUpdate(){
        let fm=FileManager.default
        
        let pathStr = "/Users/clj/Desktop"
        let attributes=try?fm.attributesOfItem(atPath: pathStr)
        print("attributes:\(attributes?[FileAttributeKey.modificationDate])")
        let str:Date=attributes?[FileAttributeKey.modificationDate] as! Date
        print(str)
    }
    
    func uploadTest(){
        print("uploadTest")
        let up=Upload()
        up.testPrint()
        print("===\(up)===")
        up.upload(withURL: "ftp://localhost/homeTest", filePath: "/Users/clj/Desktop/50m.txt", account: "clj", password: "28732149")
        
        up.testPrint()
    }
}

