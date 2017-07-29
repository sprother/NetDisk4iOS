//
//  NetworkManager.swift
//  uploadClj
//
//  Created by clj on 17/7/28.
//  Copyright © 2017年 clj. All rights reserved.
//

import Foundation
class NetworkManager:NSObject{
    var currentCheckcode:String?//如：149213124
    var currentIpAddress:String?//如：27.18.150.194
    let uploadClj=UploadClj()

    func setIP(ipAddress:String){
        self.currentIpAddress=ipAddress
    }
    //登陆
    func login(username:String,password:String)->Int{
        if currentIpAddress==nil{
            return -1
        }
        let urlStr="\(currentIpAddress):18080/ios/LoginServlet?username=\(username)&password=\(password)"
        let returnResult=uploadClj.post(urlStr: urlStr)
        if returnResult=="0"{
            //登陆失败
            return 0
        }else{
            currentCheckcode=returnResult
        }
        return 1
    }
    //注册
    func register(username:String,password:String,email:String)->Int{
        if currentIpAddress==nil{
            return -1
        }
        let urlStr="\(currentIpAddress):18080/ios/RegisterServlet?username=\(username)&password=\(password)&email=\(email)"
        let returnResult=uploadClj.post(urlStr: urlStr)
        if returnResult=="0"{
            //注册失败
            return 0
        }
        return 1
    }
    //下线
    func logoff(checkcode:String)->Int{
        let urlStr="\(currentIpAddress):18080/ios/LogOffServlet?checkcode=\(checkcode)"
        if uploadClj.post(urlStr: urlStr)=="==Invalid URL=="{
            return -1
        }
        return 1
    }
    //上传
    func upload(checkcode:String,fileData:NSData,fileName:String)->Int{
        if(currentIpAddress==nil){
            return -1
        }
        let urlStr="\(currentIpAddress):18080/ios/UploadHandleServlet?checkcode=\(checkcode)"
        let returnResult=uploadClj.uploadFile(fileData: fileData, fieldName: "file1", fileName: fileName, urlStr: urlStr)
        var retuenResult:String="s"
        if retuenResult=="1"{
            //上传成功
            return 1
        }else if retuenResult=="0"{
            //服务器返回失败0
            return 0
        }
        return -1
    }
    //下载
    func download(filename:String,checkcode:String){
        let urlStr="\(currentIpAddress):18080/ios/DownLoadServlet?filename=\(filename)&checkcode=\(checkcode)"
        let session=URLSession.shared
        //let downloadTask=session.downloadTask(with: URL(string:urlStr)!, completionHandler: <#T##(URL?, URLResponse?, Error?) -> Void#>)
        //downloadTask.resume()
    }
    
    
}
