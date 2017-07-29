//
//  UploadClj.swift
//  uploadClj
//
//  Created by clj on 17/7/21.
//  Copyright © 2017年 clj. All rights reserved.
//

import Foundation
class UploadClj{

    let boundary="-------cljasdfghboundary"
    private func formData(fileData:NSData,fieldName:String,fileName:String)->NSData{
        //构造表单数据
        let dataM=NSMutableData()
        let strM=NSMutableString()
        strM.append("--\(boundary)\r\n")
        strM.append("Content-Disposition:form-data;name=\"\(fieldName)\";filename=\"\(fileName)\"\r\n")
        strM.append("Content-Type:application/octet-stream\r\n\r\n")
        let str:String=strM as String
        dataM.append(str.data(using: String.Encoding.utf8)!)
        dataM.append(fileData as Data)
        let tail="\r\n--\(boundary)--"
        dataM.append(tail.data(using: String.Encoding.utf8)!)
        return dataM
    }
    func uploadFile(fileData:NSData,fieldName:String,fileName:String,urlStr:String)->String{
        let url=URL(string:urlStr)
        if url==nil{
            print("==Invalid URL==")
            return "Invalid URL";
        }
        var request=URLRequest(url: url!)
        request.httpMethod="POST"
        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody=self.formData(fileData: fileData, fieldName: fieldName, fileName: fileName) as Data
        
        let session=URLSession.shared
        var returnResult:String="==no return result=="
        let uploadTask=session.dataTask(with: request, completionHandler: {(data,response,error)in
            if(!(error==nil)){
                print(error!)
            }else{
                //print("==response: \(response)==")
                returnResult=NSString(data:data!,encoding:String.Encoding.utf8.rawValue) as! String
                //print("==data: \(returnResult)==")
            }
        })
        uploadTask.resume()
        return returnResult
    }
    
    func post(urlStr:String)->String{
        //发送post请求，用于登陆，下线
        let session=URLSession.shared
        let url=URL(string:urlStr)
        if url==nil{
            print("==Invalid URL==")
            return "==Invalid URL==";
        }
        var request=URLRequest(url: url!)
        request.httpMethod="POST"
        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var returnStr="==no return form servlet=="
        let uploadTask=session.dataTask(with: request, completionHandler: {(data,response,error)in
            if(!(error==nil)){
                print(error!)
            }else{
                print("==response: \(response)==")
                returnStr=NSString(data:data!,encoding:String.Encoding.utf8.rawValue) as! String
                print("==data: \(NSString(data:data!,encoding:String.Encoding.utf8.rawValue))==")
            }
        })
        uploadTask.resume()
        return returnStr
    }
    
    func test(filePath:String,urlStr:String){
        let fileData:NSData=NSData.dataWithContentsOfMappedFile(filePath) as! NSData
        
        uploadFile(fileData: fileData, fieldName: "file1", fileName: "cljFileNamelarge.txt", urlStr: urlStr)
    }
}
