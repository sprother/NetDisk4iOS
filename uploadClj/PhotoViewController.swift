//
//  PhotoViewController.swift
//  uploadClj
//
//  Created by clj on 17/7/28.
//  Copyright © 2017年 clj. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let networkManager=NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("start")

        
        
        print("finish")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //选择相册
    @IBAction func fromAlbum(){
        //判断是否支持图片库
        //在xcode8之后需要在info.plist中配置求照片相册的描述字段Privacy - Photo Library Usage Description
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker=UIImagePickerController()
            picker.delegate=self
            picker.sourceType=UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: {()->Void in })
        }else{	
            print("读取相册错误")
        }
    }
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage=info[UIImagePickerControllerOriginalImage]as! UIImage
        /*
        let fm=FileManager.default
        let rootPath=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let filePath="\(rootPath)/pickedPhoto.jpg"*/
        let imageData=UIImageJPEGRepresentation(pickedImage, 1.0)
        //上传图片
        if !(imageData==nil){
            let url=info[UIImagePickerControllerReferenceURL]
            //需要import photos
            let fetchResult:PHFetchResult=PHAsset.fetchAssets(withALAssetURLs: [url as! URL], options: nil)
            let asset:PHAsset=fetchResult.firstObject!
            var imageFileName:String?
            PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: {(imageData,dateUTI,orientation,info) in
                let imageNSURL:NSURL=info!["PHImageFileURLKey"]as! NSURL
            imageFileName=imageNSURL.lastPathComponent
            })
            networkManager.upload(checkcode: networkManager.currentCheckcode!, fileData: imageData as! NSData, fileName: imageFileName!)

            
        }
    }
    //当点击cancel按钮时回调
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
