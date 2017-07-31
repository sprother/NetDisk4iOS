//
//  ViewController.m
//  onlEdit
//
//  Created by phy on 2017/7/22.
//  Copyright © 2017年 class3. All rights reserved.
//

#import "ViewController.h"
#import "onlEdit-Swift.h"

@interface ViewController ()

@property (strong,nonatomic) UIDocumentInteractionController * documentController;

@end

@implementation ViewController

-(IBAction)jumpToIosPan:(id)sender{
    NSURL * appURL = [NSURL URLWithString:@"IOSpan://"];
    
    if([[UIApplication sharedApplication] canOpenURL:appURL]){
        [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:nil];
    }else{
        NSLog(@"未安装该应用");
    }
}

-(IBAction)presentDocument:(id)sender{
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:[[NSBundle mainBundle] URLForResource:@"text" withExtension:@"txt"]];
    _documentController.delegate = self;
    
    [self presentOptionsView];
    [self presentPreview];
}

-(IBAction)presentActivityDocument:(id)sender{
    UIActivityViewController * activity = [[UIActivityViewController alloc] initWithActivityItems:@[[[NSBundle mainBundle] URLForResource:@"text" withExtension:@"txt"]] applicationActivities:nil];
    activity.excludedActivityTypes = @[UIActivityTypeAirDrop];
    
    UIPopoverPresentationController * popover = (UIPopoverPresentationController *)activity.presentationController;
    if(popover){
        popover.sourceView = self.activityButton;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    
    [self presentViewController:activity animated:YES completion:NULL];
}

-(void)presentPreview{
    [self.documentController presentPreviewAnimated:YES];
}

-(void)presentOpenInMenu{
    [self.documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

-(void)presentOptionsView{
    [_documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

-(UIViewController *) documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

-(void)updateFile:(NSString *)filePath{
    Update * newUpdate = [[Update alloc] init];
    [newUpdate postWithUrlStr:@""];
    [newUpdate doUploadWithFilePath:filePath urlStr:@""];
    [newUpdate postWithUrlStr:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
