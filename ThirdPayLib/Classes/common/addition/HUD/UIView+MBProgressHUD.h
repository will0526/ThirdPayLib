//
//  UIView+MBProgressHUD.h
//  SNFramework
//
//  Created by  liukun on 13-9-17.
//  Copyright (c) 2013年 liukun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (MBProgressHUD)
- (void)showIndicatorHUD:(NSString *)indiTitle;
- (void)showIndicatorHUD:(NSString *)indiTitle yOffset:(CGFloat)y;
- (void)hideIndicatorHUD;
- (MBProgressHUD *)getIndicatorHUD;

- (void)showTextHUD:(NSString *)text;
- (void)showTextHUD:(NSString *)text yOffset:(CGFloat)y;
- (void)hideTextHUD;
- (MBProgressHUD *)getTextHUD;


@end
