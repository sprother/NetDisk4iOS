//
//  RecordManager.swift
//  uploadClj
//
//  Created by clj on 17/7/27.
//  Copyright © 2017年 clj. All rights reserved.
//

import Foundation
class RecordManager{
    let filePath:String=NSHomeDirectory()+"/Documents/recordFile.plist"
    func record(){
        print(filePath)
        let myArray:NSArray=[
            ["name":"fileName1.a","hasDownload":true],
            ["name":"fileName2.b","hasDownload":true],
            ["name":"fileName3.c","hasDownload":false],
            ["name":"fileName4.d","hasDownload":true],
            ["name":"fileName5中.e","hasDownload":true]
        ]
        myArray.write(toFile: filePath, atomically: true)
    }
    func printPlist(){
        let arrayFromPlist:NSArray?=NSArray(contentsOfFile: filePath)
        print(arrayFromPlist as Any)
    }

    func existFile(fileName:String)->Bool{
        let arrayFromPlist:NSArray?=NSArray(contentsOfFile: filePath)
        let array:NSArray=arrayFromPlist?.value(forKey: "name") as! NSArray
        if array.contains(fileName){
            print("==Exist the file==")
            return true
        }
        print("==NOT exist file==")
        return false
    }
    func hasDownload(fileName:String)->Bool{
        let arrayFromPlist:NSArray?=NSArray(contentsOfFile: filePath)
        let array:NSArray=arrayFromPlist?.value(forKey: "name") as! NSArray
        if array.contains(fileName){
            print("==Exist the file==")
            let index=array.index(of: fileName)
            let hasDownloadArray:NSArray=arrayFromPlist?.value(forKey: "hasDownload") as! NSArray
            let hasDownload:Bool=hasDownloadArray[index] as! Bool
            if hasDownload==true{
                print("has download")
                return true
            }else{
                print("NOT download")
                return false
            }
        }
        print("==NOT exist file==")
        return false
    }
    
    func setDownloadToTrue(fileName:String){
        let arrayFromPlist:NSMutableArray?=NSMutableArray(contentsOfFile: filePath)
        if(existFile(fileName: fileName)){
            for dictionary in arrayFromPlist!{
                if (dictionary as AnyObject).value(forKey: "name") as!String==fileName{
                    (dictionary as AnyObject).setValue(true, forKey: "hasDownload")
                }
            }
        }else{
            //如果plist中没有文件名，则添加
            arrayFromPlist?.add(["name":fileName,"hasDownload":true])
            print("NOT==")
        }
        arrayFromPlist?.write(toFile: filePath, atomically: true)
    }

    func getFileNameFromServer(urlStr:String){
        //用于获取用户服务器上的文件名，获取的用户名以空格隔开，若本地plist中没有当中文件名，则添加一行并设置hasDownload为false
        var fileNameStrings:NSString?
        let boundary="------boundayasdfghgetfilename"
        let session=URLSession.shared
        let url=URL(string:urlStr)
        if url==nil{
            print("==Invalid URL==")
        }
        var request=URLRequest(url: url!)
        request.httpMethod="POST"
        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let uploadTask=session.dataTask(with: request, completionHandler: {(data,response,error)in
            if(!(error==nil)){
                print(error!)
            }else{
                print("==response: \(response)==")
                fileNameStrings=NSString(data:data!,encoding:String.Encoding.utf8.rawValue)
                print("==data: \(fileNameStrings)==")
            }
        })
        uploadTask.resume()
        
        //分割fileNameStrings
        let fileNames=fileNameStrings?.components(separatedBy: " ")
        let arrayFromPlist:NSMutableArray?=NSMutableArray(contentsOfFile: filePath)
        for fileName in fileNames!{
            if(!existFile(fileName: fileName)){
                arrayFromPlist?.add(["name":fileName,"hasDownload":false])
            }
        }
    }
    
}
