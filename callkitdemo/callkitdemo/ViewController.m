//
//  ViewController.m
//  callkitdemo
//
//  Created by wanglijun on 2018/1/30.
//  Copyright © 2018年 wanglijun. All rights reserved.
//

#import "ViewController.h"
#import <CallKit/CallKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)getCallDirectioryStatus
{
    CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
    // 获取权限状态
    //@"com.NetworkDemo.callkitdemo.callExtension"  callExtension的id
    [manager getEnabledStatusForExtensionWithIdentifier:@"com.NetworkDemo.callkitdemo.callExtension" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if (!error) {
            NSString *title = nil;
            if (enabledStatus == CXCallDirectoryEnabledStatusDisabled) {
                /*
                 CXCallDirectoryEnabledStatusUnknown = 0,
                 CXCallDirectoryEnabledStatusDisabled = 1,
                 CXCallDirectoryEnabledStatusEnabled = 2,
                 */
                title = @"未授权，请在设置->电话授权相关权限";
            }else if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
                title = @"授权";
                
                [self loadCallKit];
                
            }else if (enabledStatus == CXCallDirectoryEnabledStatusUnknown) {
                title = @"不知道";
            }
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:title
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"有错误"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

-(void)saveCallKitData
{
    NSError *err = nil;
    NSString *shareString=@"数据源";
    //这里可以用文件也可以使用数据库作为数据来源,将数据保存到共享存储空间以便callExtension获取
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.cn.com.callkitdemo.share"];
    containerURL = [containerURL URLByAppendingPathComponent:@"callkit.txt"];
    
    BOOL result = [shareString writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!result) {
        NSLog(@"%@",err);
        
    } else {
        NSLog(@"save  success.");
        
        [self getCallDirectioryStatus];
    }
}

-(void)loadCallKit
{
    CXCallDirectoryManager  *cxManager = [CXCallDirectoryManager sharedInstance];
    [cxManager reloadExtensionWithIdentifier:@"com.NetworkDemo.callkitdemo.callExtension" completionHandler:^(NSError *error){
        if (error == nil) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"更新成功"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"更新失败"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
}

-(void)cleanLoadCallKit
{
    NSError *err = nil;
    NSString *shareString=@"空数据源";
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.cn.com.callkitdemo.share"];
    containerURL = [containerURL URLByAppendingPathComponent:@"callkit.txt"];
    //将共享存储的数据清空,每次更新之后会覆盖上一次跟新的数据，每次以最后一次更新的数据为最新数据
    BOOL result = [shareString writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!result) {
        NSLog(@"%@",err);
        
    } else {
        NSLog(@"save  success.");
    }
    
    CXCallDirectoryManager  *cxManager = [CXCallDirectoryManager sharedInstance];
    [cxManager reloadExtensionWithIdentifier:@"com.NetworkDemo.callkitdemo.callExtension" completionHandler:^(NSError *error){
        if (error == nil)
        {
            
        }
        else
        {
            
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
