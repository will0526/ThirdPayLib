//
//  MOPHUDCenter.m
//  MOPMobileClient
//
//  Created by sunyard on 12-12-18.
//  Copyright (c) 2012年 com.sunyard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBCyclingLabel.h"

@interface MOPCustomStatueBar : UIWindow
{
    BBCyclingLabel *defaultLabel;
}
- (void)showStatusMessage:(NSString *)message;
- (void)removeStatusMessage;

@end
