//
//  Upload.m
//  uploadClj
//
//  Created by clj on 17/7/17.
//  Copyright © 2017年 clj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
#import "Upload.h"
@implementation Upload {
    enum{
        kSendBufferSize=32768//上传缓冲区大小
    };
    uint8_t _buffer[kSendBufferSize];
}
-(void)photoTest{
    
    //PHAssetResource *resource=[[PHAssetResource assetResourcesForAsset:myAsset]firstObject];
    
    
}
-(void)testPrint{
    NSLog(@"print something==");
}
-(uint8_t*)buffer{//buffer被声明为数组，所以要用自定义的getter方法
    return self->_buffer;
}
-(void)dealloc{
    NSLog(@"==dealloc==");
    //do nothing
}
-(void)uploadWithURL:(NSString*)urlString filePath:(NSString*)filePathStr account:(NSString*)accountStr password:(NSString*)passwordStr{
    NSLog(@"==begin upload==");
    NSURL *url;//ftp address
    NSString *filePath;//file like picture
    NSString*account;
    NSString*password;
    CFWriteStreamRef ftpStream;
    
    url=[NSURL URLWithString:urlString];
    filePath=filePathStr;
    account=accountStr;
    password=passwordStr;
    
    //添加后缀
    url = CFBridgingRelease(CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef)url, (CFStringRef)[filePath lastPathComponent], false));
    
    //读取文件，转化为输入流
    self.fileStream=[NSInputStream inputStreamWithFileAtPath:filePath];
    [self.fileStream open];
    if(self.fileStream==nil){
        NSLog(@"error file Stream is nil");
    }
    //为url开启CFFTPStream输出流
    
    ftpStream=CFWriteStreamCreateWithFTPURL(NULL, (__bridge CFURLRef)url);
    if(ftpStream==nil){
        NSLog(@"error ftpStream is nil");
    }
    self.networkStream=CFBridgingRelease(ftpStream);
    if(self.networkStream==nil){
        NSLog(@"error networkStream is nil");
    }
    //设置ftp账号密码
    [self.networkStream setProperty:account forKey:(id)kCFStreamPropertyFTPUserName];
    [self.networkStream setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
    
    //设置networkStream流的代理，任何关于networkStream的事件发生都会调用代理方法
    self.networkStream.delegate=self;
    
    //设置runloop
    [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.networkStream open];
    
    //完成释放链接
    //NSLog(@"ftpStream==%@==",ftpStream);
    //NSLog(@"networkStream==%@==",self.networkStream);
    //NSLog(@"fileStream==%@==",self.fileStream);
    //CFRelease(ftpStream);
}
-(void)_stopSendWithStatus:(NSString*)statusString{
    if(self.networkStream!=nil){
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate=nil;
        [self.networkStream close];
        self.networkStream=nil;
    }
    if(self.fileStream!=nil){
        [self.fileStream close];
        self.fileStream=nil;
    }
    
    //[self _sendDidStopWithStatus:statusString];
}
-(void)stream:(NSStream*)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"stream==");
    switch(eventCode)
    {
        case NSStreamEventOpenCompleted:{
            NSLog(@"NSStreamEventOpenCompleted");
        }break;
        case NSStreamEventHasBytesAvailable:{
            NSLog(@"NSStreamEventHasBytesAvailable");
            assert(NO);//再上传时不会调用
        }break;		
        case NSStreamEventHasSpaceAvailable:{
            NSLog(@"NSStreamEventHasSpaceAvailable");
            NSLog(@"bufferOffset is %zd",self.bufferOffset);
            NSLog(@"bufferLimit is %zd",self.bufferLimit);
            if(self.bufferOffset==self.bufferLimit){
                NSInteger bytesRead;
                bytesRead=[self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if(bytesRead==-1){
                    //读取文件错误
                    NSLog(@"==读取文件错误==");
                    [self _stopSendWithStatus:@"读取文件错误"];
                }else if(bytesRead==0){
                    NSLog(@"==文件读取完成 上传完成＝＝");
                }else{
                    self.bufferOffset=0;
                    self.bufferLimit=bytesRead;
                }
            }
            
            if(self.bufferOffset!=self.bufferLimit){
                NSInteger bytesWritten;
                bytesWritten=[self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit-self.bufferOffset];
                assert(bytesWritten!=0);
                if(bytesWritten==-1){
                    NSLog(@"＝＝网络写入错误＝＝");
                    [self _stopSendWithStatus:@"网络写入错误"];
                }else{
                    self.bufferOffset+=bytesWritten;
                }
            }
        }break;
        case NSStreamEventErrorOccurred:{
            NSLog(@"＝＝Stream打开错误＝＝");
            [self _stopSendWithStatus:@"Stream打开错误"];
            assert(NO);
        }break;
        case NSStreamEventEndEncountered:{
            //ignore
        }break;
        default:{
            assert(NO);
        }break;
    }
}

@end
