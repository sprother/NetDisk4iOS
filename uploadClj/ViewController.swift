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
        
        //fileUpdateTest(file1: "/Users/clj/Desktop/50m2.mp4", file2: "/Users/clj/Desktop/50m.mp4")
        swiftHTTPUpload()
        
        print("finish")
        
    }
    let myUpload=uploadClj()
    func swiftHTTPUpload(){
        myUpload.post(urlStr: "http://27.18.151.17:18080/ios/RegisterServlet?username=Lilith&password=233")
        myUpload.test(filePath:"/Users/clj/Desktop/cljfile.txt",urlStr:"http://27.18.151.17:18080/ios/LoginServlet?username=Lilith&password=233")
        myUpload.post(urlStr:"http://27.18.151.17:18080/ios/ListFileServlet?checkcode=1501545977804")
        //http://27.18.151.17:18080/ios/LoginServlet?username=Lilith&password=233
        //http://27.18.151.17:18080/ios/UploadHandleServlet?checkcode=1498866481474
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

