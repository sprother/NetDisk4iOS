//
//  ViewController.h
//  onlEdit
//
//  Created by phy on 2017/7/22.
//  Copyright © 2017年 class3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak,nonatomic) UIButton * activityButton;

-(void)updateFile:(NSString *)fileUrl;

@end

