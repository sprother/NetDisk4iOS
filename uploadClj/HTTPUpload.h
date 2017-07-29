//
//  HTTPUpload.h
//  uploadClj
//
//  Created by clj on 17/7/20.
//  Copyright © 2017年 clj. All rights reserved.
//

#ifndef HTTPUpload_h
#define HTTPUpload_h
@interface HTTPUpload:NSObject
-(void)uploadWithURL:(NSString*)urlString filePath:(NSString*)filePath;
-(void)test;
-(void)initsession:(NSURLSession*)s :(NSURLSessionUploadTask*)task;
@property(nonatomic,retain)NSURLSession* session;
@property(nonatomic,retain)NSURLSessionUploadTask*uploadTask;
@end
#endif /* HTTPUpload_h */
