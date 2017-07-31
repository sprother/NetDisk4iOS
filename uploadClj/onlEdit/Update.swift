//
//  Update.swift
//  onlEdit
//
//  Created by phy on 2017/7/28.
//  Copyright © 2017年 class3. All rights reserved.
//

import UIKit

class Update: NSObject {
    
    let boundary="-------cljasdfghboundary"
    
    private func formData(fileData:NSData,fieldName:String,fileName:String)->NSData{
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
    
    func uploadFile(fileData:NSData,fieldName:String,fileName:String,urlStr:String){
        let url=URL(string:urlStr)
        if url==nil{
            print("==Invalid URL==")
            return;
        }
        var request=URLRequest(url: url!)
        request.httpMethod="POST"
        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody=self.formData(fileData: fileData, fieldName: fieldName, fileName: fileName) as Data
        
        let session=URLSession.shared
        let uploadTask=session.dataTask(with: request, completionHandler: {(data,response,error)in
            if(!(error==nil)){
                print(error!)
            }else{
                print("==response: \(String(describing: response))==")
                print("==data: \(String(describing: NSString(data:data!,encoding:String.Encoding.utf8.rawValue)))==")
            }
        })
        uploadTask.resume()
    }
    
    func post(urlStr:String){
        let session=URLSession.shared
        let url=URL(string:urlStr)
        if url==nil{
            print("==Invalid URL==")
            return;
        }
        var request=URLRequest(url: url!)
        request.httpMethod="POST"
        request.setValue("multipart/form-data;boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let uploadTask=session.dataTask(with: request, completionHandler: {(data,response,error)in
            if(!(error==nil)){
                print(error!)
            }else{
                print("==response: \(String(describing: response))==")
                print("==data: \(String(describing: NSString(data:data!,encoding:String.Encoding.utf8.rawValue)))==")
            }
        })
        uploadTask.resume()
    }
    
    func doUpload(filePath:String,urlStr:String){
        let fileData:NSData = NSData.dataWithContentsOfMappedFile(filePath) as! NSData
        uploadFile(fileData: fileData, fieldName: "file1", fileName: "sample.txt", urlStr:urlStr)
    }
}
