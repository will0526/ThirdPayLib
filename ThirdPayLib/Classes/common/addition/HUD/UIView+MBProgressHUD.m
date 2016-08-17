//
//  UIView+MBProgressHUD.m
//  SNFramework
//
//  Created by  liukun on 13-9-17.
//  Copyright (c) 2013年 liukun. All rights reserved.
//

#import "UIView+MBProgressHUD.h"
#import "UIImage+SNAdditions.h"
#define indicatorHUDTag                     0x98751246
#define textHUDTag                          0x98751247



@implementation UIView (MBProgressHUD)

- (void)showIndicatorHUD:(NSString *)indiTitle
{
    MBProgressHUD *HUD = [self getIndicatorHUD];
    
    HUD.labelText = indiTitle;
    
//    HUD.yOffset = -(self.bounds.size.height/10); //大约在黄金分割点
    
    [HUD show:YES];
}

- (void)showIndicatorHUD:(NSString *)indiTitle yOffset:(CGFloat)y
{
    MBProgressHUD *HUD = [self getIndicatorHUD];
    
    HUD.labelText = indiTitle;
    
    HUD.yOffset = y;
    
    [HUD show:YES];
}

- (void)hideIndicatorHUD
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:indicatorHUDTag];
	
    if (hud && [hud isKindOfClass:[MBProgressHUD class]] && !hud.onHiding)
    {
        [self stopOperTimer];
        [hud hide:YES];
        
    }
}

- (MBProgressHUD *)getIndicatorHUD
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:indicatorHUDTag];
	
    if (hud && [hud isKindOfClass:[MBProgressHUD class]] && !hud.onHiding)
    {
        return hud;
    }
    else
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.tag = indicatorHUDTag;
        UIView* customView;
        UILabel *lineLabel;
        customView=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, 115, 80))];
        lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake((customView.bounds.size.width-77)/2, (customView.bounds.size.height-1)/2+20, 83, 1);
        lineLabel.backgroundColor = [UIColor whiteColor];
        hud.iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(customView.bounds.size.width/2-77/2, (customView.bounds.size.height-55)/2+20, 91/2, 55/2)];
        hud.StartFrame  = CGRectMake(customView.bounds.size.width/2-77/2, (customView.bounds.size.height-55)/2+20, 91/2, 55/2);
        hud.iconImageView.image = [UIImage getImageFromBundle:@"forceLoadImage"];
        
        [customView addSubview:hud.iconImageView];
        [customView addSubview:lineLabel];
        hud.customView=customView;
        hud.mode = MBProgressHUDModeCustomView;
        [self addSubview:hud];

        if (!hud.operTime) {
             hud.operTime = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(swipeCard) userInfo:nil repeats:YES];
            [hud.operTime fire];
            [UIView setAnimationDelegate:self];
        }
        
        
        hud.opacity = 0.6;
        hud.removeFromSuperViewOnHide = YES;
        return hud;
    }
    
}

-(void)swipeCard
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:indicatorHUDTag];
    hud.EndFrame = hud.StartFrame;
    CGRect rect = hud.EndFrame;
    rect.origin.x += 37;
    hud.EndFrame = rect;
    
    [hud.iconImageView setFrame:hud.StartFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [hud.iconImageView setFrame:hud.EndFrame];
    [UIView commitAnimations];
}
//
-(void)stopOperTimer
{
     MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:indicatorHUDTag];
    if ([hud.operTime isValid]) {
        [hud.operTime invalidate];
        hud.operTime = nil;
    }
}


- (void)showTextHUD:(NSString *)text
{
    MBProgressHUD *HUD = [self getTextHUD];
    
    HUD.detailsLabelText = text;
    
    HUD.yOffset = -(self.bounds.size.height/10); //大约在黄金分割点
    
    [HUD show:YES];
}

- (void)showTextHUD:(NSString *)text yOffset:(CGFloat)y
{
    MBProgressHUD *HUD = [self getTextHUD];
    
    HUD.detailsLabelText = text;
    
    HUD.yOffset = y; //大约在黄金分割点
    
    [HUD show:YES];
}

- (void)hideTextHUD
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:textHUDTag];
	
    if (hud && [hud isKindOfClass:[MBProgressHUD class]] && !hud.onHiding)
    {
        [self stopOperTimer];
        [hud hide:YES];
        
    }
}

- (MBProgressHUD *)getTextHUD
{
    MBProgressHUD *hud = (MBProgressHUD *)[self viewWithTag:textHUDTag];
	
    if (hud && [hud isKindOfClass:[MBProgressHUD class]] && !hud.onHiding)
    {
        return hud;
    }
    else
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
        hud.mode = MBProgressHUDModeText;
        hud.tag = textHUDTag;
        hud.opacity = 0.6f;
        hud.removeFromSuperViewOnHide = YES;
        hud.shouldHideOnTouch = YES;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            hud.detailsLabelFont = [UIFont systemFontOfSize:30.0f];
            hud.maxBoxWidth = 800.0;
        }else
        {
            hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
            hud.maxBoxWidth = 260.0;
        }
        
        hud.margin = 12.0f;
        hud.opacity = 0.6f;
        hud.boxCornerRadius = 6.0f;
        hud.animationType = MBProgressHUDAnimationZoom;
        return hud;
    }
}




@end
