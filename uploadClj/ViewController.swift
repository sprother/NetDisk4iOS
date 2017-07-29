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
        //swiftHTTPUpload()
        //testRecord()
        
        print("finish")
        
    }
    let myRecordManager=RecordManager()
    func testRecord(){
        //myRecordManager.record()
        //myRecordManager.read()
        /*
        myRecordManager.hasDownload(fileName:"filename1.png")
        myRecordManager.hasDownload(fileName: "filename1")
        myRecordManager.hasDownload(fileName: "fileName1.png")
        myRecordManager.hasDownload(fileName:"fileName3.txt")
        myRecordManager.existFile(fileName: "file")
        myRecordManager.existFile(fileName: "fileName5中.e")*/
        
        myRecordManager.setDownloadToTrue(fileName: "fileName3.c")
        myRecordManager.setDownloadToTrue(fileName: "444")
        myRecordManager.printPlist()
    }
    
    
    let myUpload=UploadClj()
    func swiftHTTPUpload(){
        //myUpload.post(urlStr: "http://27.18.151.17:18080/ios/RegisterServlet?username=Lilith&password=233")
        //myUpload.test(filePath:"/Users/clj/Desktop/cljfile.txt",urlStr:"http://27.18.151.17:18080/ios/LoginServlet?username=Lilith&password=233")
        //myUpload.post(urlStr:"http://27.18.151.17:18080/ios/ListFileServlet?checkcode=1501545977804")
        //http://27.18.151.17:18080/ios/LoginServlet?username=Lilith&password=233
        //http://27.18.151.17:18080/ios/UploadHandleServlet?checkcode=1498866481474
        
        
        
    }
    func downloadAddressBook(urlStr:String){
        let session=URLSession.shared
        let urlString=urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url=URL(string: urlString)
        let request=URLRequest(url: url!)
        let sessionDownloadTask=session.downloadTask(with: request, completionHandler: {(URL,response,error)in
            if !(error==nil){
                print("==\(error)==")
            }else{
                let fm=FileManager.default
                let filePath="/Users/clj/Desktop/addressbook"
                try! fm.copyItem(atPath: (URL?.path)!, toPath: filePath)
                print("==\(response)==")
            }
        })
        sessionDownloadTask.resume()
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

