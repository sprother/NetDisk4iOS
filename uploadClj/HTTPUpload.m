
//
//  HTTPUpload.m
//  uploadClj
//
//  Created by clj on 17/7/20.
//  Copyright © 2017年 clj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPUpload.h"
#define BOUNDARY @"asdfghj"
#define WRAP1 @"\r\n"

@implementation HTTPUpload
@synthesize session;
-(void)test{
    NSLog(@"==test==");
}
-(void)initSession:(NSURLSession*)s{
    session=s;
}
-(void)uploadWithURL:(NSString *)urlString filePath:(NSString *)filePath{
    NSURL*url=[NSURL URLWithString:urlString];
    NSMutableURLRequest* request=[NSMutableURLRequest requestWithURL:url];
    if(request==nil)assert(NO);
    NSInputStream *inStream=[NSInputStream inputStreamWithFileAtPath:filePath];//输入流提供请求体，不需要将整个体加载到内存中
    [request setHTTPBodyStream:inStream];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"post"];
    
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionUploadTask *uploadTask=[session uploadTaskWithRequest:request fromFile:[NSURL URLWithString:filePath]];
    
    [uploadTask resume];
}

-(void)URLSession:(NSURLSession*)session task:(NSURLSessionTask*)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    float progress=(float)totalBytesSent/totalBytesExpectedToSend;
    NSLog(@"==progress: %.2f%%==",progress*100);
}
@end
