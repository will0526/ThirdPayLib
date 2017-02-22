//
//  UMSCommonViewController.m
//  IOSTempleteProject
//
//  Created by will on 14-2-7.
//  Copyright (c) 2014年 UMS. All rights reserved.
//

#import "CommonViewController.h"
#import "UIView+MBProgressHUD.h"
#import "LJTimer.h"
#import "SystemInfo.h"

#define SHOWTIME 1

@interface CommonViewController ()
{
    BasicBlock  sheetCallBack_;
    
    MBProgressHUD *mHud;
}

@end

@implementation CommonViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    self.view.backgroundColor = HEX_RGB(0xf8f8f8);
    
}


- (void)presentSheet:(NSString *)indiTitle
            complete:(BasicBlock)callBack
{
    sheetCallBack_ = callBack;
    [self.view showTextHUD:indiTitle];
    //每个字0.3s, 最低3秒
    CGFloat showTime = SHOWTIME;//MAX([indiTitle length] * 0.3, 3);
    [self startTimerWithInterval:showTime
                             sel:@selector(removeSheetView)
                          repeat:NO];
}

- (void)removeSheetView
{
    if (sheetCallBack_)
    {
        sheetCallBack_();
        sheetCallBack_ = nil;
    }
    [self.view hideTextHUD];
    [self stopTimerWithSel:@selector(removeSheetView)];
}

- (void)presentSheet:(NSString*)indiTitle
{
    [self.view showTextHUD:indiTitle];
    
    //每个字0.3s, 最低3秒
    CGFloat showTime = MAX([indiTitle length] * 0.3, 3);
    [self hideHUDafterDelay:showTime];
}

- (void)hideHUDafterDelay:(NSTimeInterval)delay {
    [self performSelector:@selector(hideHUD:) withObject:nil afterDelay:delay];
}

- (void)hideHUD:(NSNumber *)animated {
    [self.view hideTextHUD];
}


- (void)viewDidAppear:(BOOL)animated
{
    //do something globle, need super in subclass.
    //[MobClick beginLogPageView:NSStringFromClass([self class])];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showLoadingView {
    if (mHud == nil) {
        mHud = [[MBProgressHUD alloc]initWithView:self.view];
        mHud.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:mHud];
    }
    [mHud show:YES];
    [self requestServer];
    
}

-(void)hidingLoadingView {
    if (mHud) {
        [mHud hide:NO afterDelay:1];
    }
}

-(void)requestServer {
    
}


-(void)showErrorMsg:(NSString *)message {
    if (mHud == nil) {
        mHud = [[MBProgressHUD alloc]initWithView:self.view];
        mHud.mode = MBProgressHUDModeIndeterminate;
        [self.view addSubview:mHud];
    }
    mHud.mode = MBProgressHUDModeText;
    mHud.labelText = message;
    [mHud show:YES];
    [mHud hide:NO afterDelay:2];
}


@end
