//
//  Upload.h
//  uploadClj
//
//  Created by clj on 17/7/17.
//  Copyright © 2017年 clj. All rights reserved.
//

#ifndef Upload_h
#define Upload_h
#import <Foundation/Foundation.h>
@interface Upload:NSObject<NSStreamDelegate>
@property(nonatomic,readonly)BOOL isSending;
@property(nonatomic,retain)NSOutputStream*networkStream;
@property(nonatomic,retain)NSInputStream*fileStream;
@property(nonatomic,readonly)uint8_t *buffer;
@property(nonatomic,assign)size_t bufferOffset,bufferLimit;
-(void)uploadWithURL:(NSString*)urlString filePath:(NSString*)filePathStr account:(NSString*)accountStr password:(NSString*)passwordStr;
-(void)testPrint;
@end

#endif /* Upload_h */

