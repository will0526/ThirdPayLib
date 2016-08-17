//
//  MOPHUDCenter.m
//  MOPMobileClient
//
//  Created by sunyard on 12-12-18.
//  Copyright (c) 2012年 com.sunyard. All rights reserved.
//

#import "MOPCustomStatueBar.h"

@implementation MOPCustomStatueBar

- (id)init{
    self = [super init];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
		self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.backgroundColor = [UIColor clearColor];
        
        defaultLabel = [[BBCyclingLabel alloc]initWithFrame:CGRectMake(200, 0, 120, 20) andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
        defaultLabel.backgroundColor = [UIColor clearColor];
        defaultLabel.textColor = [UIColor whiteColor];
        defaultLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        defaultLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:defaultLabel];
//        [defaultLabel setText:@"default label text" animated:NO];
//        defaultLabel.transitionDuration = 0.75;
//        defaultLabel.shadowOffset = CGSizeMake(0, 1);
//        defaultLabel.font = [UIFont systemFontOfSize:15];
//        defaultLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
//        defaultLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.75];
        defaultLabel.clipsToBounds = YES;
    }
    return self;
}

- (void)showStatusMessage:(NSString *)message{
    self.hidden = NO;
    self.alpha = 1.0f;
    [defaultLabel setBackgroundColor:([UIColor blackColor])];
    [defaultLabel setText:message animated:YES];
    [[defaultLabel class]cancelPreviousPerformRequestsWithTarget:self];
    return;
}
-(void)removeStatusMessage
{
    [NSThread sleepForTimeInterval:1.5];
    [defaultLabel setText:@"" animated:YES];
//    [defaultLabel setBackgroundColor:([UIColor clearColor])];
    [defaultLabel performSelector:@selector(setBackgroundColor:) withObject:[UIColor clearColor] afterDelay:0.3];
//    self.alpha = 1.0f;
//    
    [UIView animateWithDuration:0.5f animations:
     ^{
        self.alpha = 0.0f;
    }completion:
     ^(BOOL finished){
        defaultLabel.text = @"";
        self.hidden = YES;
    }];
}


@end
