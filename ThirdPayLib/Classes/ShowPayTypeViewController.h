//
//  ShowPayTypeViewController.h
//  Pods
//
//  Created by will on 16/8/10.
//
//

#import <UIKit/UIKit.h>
#import "ThirdPay.h"
#import "CommonViewController.h"
#import "PNROrderInfo.h"
@interface ShowPayTypeViewController :CommonViewController


@property(nonatomic,strong)NSString *viewType;

@property(nonatomic,strong)PNROrderInfo *orderInfo;





@property(nonatomic, weak)id<ThirdPayDelegate> thirdPayDelegate;
@property(nonatomic, weak)UIViewController *viewController;

-(void)bookOrder;

-(Boolean)handleOpenURL:(NSURL *)url withCompletion:(ThirdPayCompletion )complete;

-(void)scanCode:(UIViewController *)controller;

@end
