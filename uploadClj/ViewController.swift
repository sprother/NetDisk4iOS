//
//  ViewController.swift
//  uploadClj
//
//  Created by clj on 17/7/17.
//  Copyright © 2017年 clj. All rights reserved.
//

import UIKit

class ViewController: UIViewController,URLSessionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("start")
        
        fileUpdateTest(file1: "/Users/clj/Desktop/50m2.mp4", file2: "/Users/clj/Desktop/50m.mp4")
        //swiftHTTPUpload()
        
        print("finish")
        
    }
    let myUpload=uploadClj()
    func swiftHTTPUpload(){
         myUpload.test(filePath:"/Users/clj/Desktop/cljfile.txt",urlStr:"http://27.18.150.194:18080/ios/first?account=abc&password=123")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fileUpdateTest(file1:String,file2:String){
        //文件对比模块
        let fm=FileManager.default
        if fm.contentsEqual(atPath: file1, andPath: file2){
            print("==Equal==")
        }else{
            print("==Not Equal==")
        }
        //let pathStr = "/Users/clj/Desktop/50m.mp4"
        printDate(file: file1)
        printDate(file: file2)
    }
    func printDate(file:String){
        let fm=FileManager.default
        let attributes=try?fm.attributesOfItem(atPath: file)
        print("==attributes:\(attributes?[FileAttributeKey.modificationDate])==")
        let str:Date=attributes?[FileAttributeKey.modificationDate] as! Date
        print("==Data: \(str) ==")
    }

}

