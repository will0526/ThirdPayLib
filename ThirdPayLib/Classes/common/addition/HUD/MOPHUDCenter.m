//
//  MOPHUDCenter.m
//  MOPMobileClient
//
//  Created by sunyard on 12-12-18.
//  Copyright (c) 2012年 com.sunyard. All rights reserved.
//

#import "MOPHUDCenter.h"
#import <QuartzCore/QuartzCore.h>
#import "SystemInfo.h"

#import "CommonViewController.h"

//单例对象
static MOPHUDCenter *shareInstance;
@implementation MOPHUDCenter
{
    MOPCustomStatueBar *customStatueBar;
    UIView *loading;
    UILabel *loadingtitle;
//    MOPRoundProgressView* roundProgress;
    UIView<MOPProgressView> *progressView;
    UIAlertView* alert;
    MOPHUDCenterHUDType hudType_;
    NSThread *removeThread;
    BOOL progressing;
    UIImageView* iconImageView;
    double angle;
    BOOL isStop;

    BOOL        isWaitingForHiden_;
    UIView      *viewShowWaiting_;
    NSString    *titleShowWaiting_;
    BOOL         backgroundWating_;
}
@synthesize HUD;
//获取指示中心单例
+(MOPHUDCenter*)shareInstance
{
    @synchronized(self)
    {
        if (shareInstance==Nil) {
            shareInstance=[[self alloc]init];
        }
        return shareInstance;
    }
}
+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (shareInstance == nil) {
            shareInstance = [super allocWithZone:zone];
            return  shareInstance;
        }
    }
    return nil;
}

#pragma mark - 警告框
-(void)showAlert:(NSString*)message
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    alert=[[UIAlertView alloc]initWithTitle:nil
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - 载入画面
-(void)showHUDWithTitle:(NSString*)title
                   type:(MOPHUDCenterHUDType)hudtype
             controller:(CommonViewController *)ctl
         showBackground:(BOOL)background
{
    [self showHUDWithTitle:title
                      type:hudtype
                      view:ctl.view
            showBackground:background];
}


-(void)showHUDWithTitle:(NSString*)title
                   type:(MOPHUDCenterHUDType)hudtype
                   view:(UIView *)view
         showBackground:(BOOL)background
{
//    DDLogInfo(@"title:%@",title);

    if (![[NSThread currentThread]isMainThread])
    {
//        DDLogInfo(@"不在主线程调用，转入主线程调用");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showHUDWithTitle:title
                              type:hudtype
                              view:view
                    showBackground:background];
        });
        return;
    }
    
    UIView *hudSuperView  = nil;
    
    titleShowWaiting_ = title;
    backgroundWating_ = background;
    
    if (hudtype == MOPHUDCenterHUDTypeNetWorkLoading)
    {
        hudSuperView = [[UIApplication sharedApplication] delegate].window;
    }else
    {
        hudSuperView = view;
    }
    
    viewShowWaiting_ = hudSuperView;
    
    if (HUD.onHiding)
    {
        hudType_ = hudtype;
        isWaitingForHiden_ = YES;
        return;
    }
    
    if (hudType_ != hudtype)
    {
        if (HUD)
        {
            hudType_ = hudtype;
            [self stopOperTimer];
            HUD.removeFromSuperViewOnHide = YES;
            [HUD hide:YES];
            isWaitingForHiden_ = YES;
            HUD = nil;
            return;
        }else
        {
            hudType_ = hudtype;
            [self hudViewInitial];
            return;
        }
    }
    
    MBProgressHUD *hudFormer = (MBProgressHUD *)[hudSuperView viewWithTag:HudTag];
    
    if (hudFormer)
    {
        if (hudFormer.onHiding)
        {
            hudType_ = hudtype;
            isWaitingForHiden_ = YES;
            return;
        }else
        {
            if (hudType_ == MOPHUDCenterHUDTypeSuccess
                ||hudType_ == MOPHUDCenterHUDTypeRightDevice
                ||hudType_ == MOPHUDCenterHUDTypeWrongDevice
                ||hudType_ == MOPHUDCenterHUDTypeWarming)
            {
                isWaitingForHiden_ = YES;
                hudType_ = hudtype;
                return;
            }
         }
    }else
    {
        hudType_ = hudtype;
        [self hudViewInitial];
    }
 }


- (void)refreshHudView
{
//    DDLogInfo(@"title:%@",titleShowWaiting_);
    HUD.labelText = titleShowWaiting_;
    UIView *customView = [HUD viewWithTag:HudTag];
    if (customView)
    {
        if (hudType_==MOPHUDCenterHUDTypePullOut)
        {
            UILabel *lineLbl = (UILabel *)[HUD viewWithTag:HudTag+1];
            UIImageView *iconImage = (UIImageView *)[HUD viewWithTag:HudTag+2];
            if (lineLbl && iconImage)
            {
                if (backgroundWating_)
                {
                    lineLbl.backgroundColor = [UIColor whiteColor];
                    iconImage.image = [UIImage getImageFromBundle:@"forceLoadImage"];
                    HUD.isHiddenBackground = NO;
                }else
                {
                    lineLbl.backgroundColor = HEX_RGB(0x949494);
                    iconImage.image = [UIImage getImageFromBundle:@"loadImage"];
                    HUD.isHiddenBackground = YES;
                }
            }
        }
    }
    
}


- (void)hudViewInitial
{
//    DDLogInfo(@"title:%@",titleShowWaiting_);

    UIWindow* keyWindow=[[UIApplication sharedApplication] delegate].window;
    if (hudType_ == MOPHUDCenterHUDTypeNetWorkLoading)
    {
        
        HUD=[[MBProgressHUD alloc]initWithWindow:keyWindow];
        [keyWindow addSubview:HUD];
    }else
    {
        HUD=[[MBProgressHUD alloc]initWithView:viewShowWaiting_];
        [viewShowWaiting_ addSubview:HUD];
    }
    
    HUD.tag = HudTag;
    HUD.delegate = self;
    HUD.labelText = titleShowWaiting_;

    UIView* customView = nil;
    UIImage *iconImage = nil;
    UILabel *lineLabel = nil;
    
    switch (hudType_)
    {
        case MOPHUDCenterHUDTypePullOut:
            iconImage=[UIImage getImageFromBundle:@"pull out"];
            break;
        case MOPHUDCenterHUDTypeIposLoading:
            iconImage=[UIImage getImageFromBundle:@"load0"];
            break;
        case MOPHUDCenterHUDTypeSuccess:
            iconImage=[UIImage getImageFromBundle:@"icon_ok"];
            break;
        case MOPHUDCenterHUDTypeRightDevice:
            iconImage=[UIImage getImageFromBundle:@"icon_ok"];
            break;
        case MOPHUDCenterHUDTypeWrongDevice:
            iconImage=[UIImage getImageFromBundle:@"icon_error"];
            break;
        case MOPHUDCenterHUDTypeWarming:
            iconImage=[UIImage getImageFromBundle:@"icon_warming"];
            break;
        default:
            break;
    }
    iconImageView=[[UIImageView alloc]initWithImage:iconImage];
    
    if (IS_IPAD)
    {
        customView=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, 150*1.5, 91*2.3))];
    }
    else
    {
        customView=[[UIView alloc]initWithFrame:(CGRectMake(0, 0, 55, 30))];
    }
    
    
    if (IS_IPAD)
    {
        iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77*2.3, 91*2.5)];
    }
    else
    {
        lineLabel = [[UILabel alloc]init];
        lineLabel.frame = CGRectMake((customView.bounds.size.width-77)/2, (customView.bounds.size.height-1)/2+20, 83, 1);
        lineLabel.backgroundColor = [UIColor whiteColor];
        iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake((customView.bounds.size.width-33)/2, (customView.bounds.size.height-33)/2+10, 33, 33)];

    }
    
    if (hudType_==MOPHUDCenterHUDTypeIposLoading)
    {
        NSMutableArray* imageArray=[NSMutableArray array];
        for (int i=0; i<4; i++)
        {
            [imageArray addObject:[UIImage getImageFromBundle:[NSString stringWithFormat:@"load_net%d",i]]];
        }
        if (IS_IPAD)
        {
            iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 77*2, 91*2.3)];
        }
        else
        {
            iconImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
        }
        [iconImageView setHighlightedAnimationImages:imageArray];
        [iconImageView setHighlighted:YES];
        [iconImageView setAnimationDuration:1];
        [iconImageView startAnimating];
        
    }
    else if(hudType_==MOPHUDCenterHUDTypeNetWorkLoading)
    {
        iconImageView.image = [UIImage getImageFromBundle:@"networkLoadImage"];
    }else if (hudType_==MOPHUDCenterHUDTypePullOut)
    {
        if (backgroundWating_)
        {
            lineLabel.backgroundColor = [UIColor whiteColor];
            iconImageView.image = [UIImage getImageFromBundle:@"forceLoadImage"];
            HUD.isHiddenBackground = NO;
        }else
        {
            lineLabel.backgroundColor = HEX_RGB(0x949494);
            iconImageView.image = [UIImage getImageFromBundle:@"loadImage"];
            HUD.isHiddenBackground = YES;
        }
    }
    
    [customView addSubview:iconImageView];
//    [customView addSubview:lineLabel];
    
    HUD.customView=customView;
    HUD.mode = MBProgressHUDModeCustomView;

   // [HUD setRemoveFromSuperViewOnHide:YES];
    [HUD show:YES];
    isStop = YES;
    [self startAnimation];
    if (!_operTime)
    {
//        _operTime = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
//        [_operTime fire];
//        [UIView setAnimationDelegate:self];
    }
    
    if (hudType_ == MOPHUDCenterHUDTypeSuccess
        ||hudType_ == MOPHUDCenterHUDTypeRightDevice
        ||hudType_ == MOPHUDCenterHUDTypeWrongDevice
        ||hudType_ == MOPHUDCenterHUDTypeWarming)
    {
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:1];
    }else if(hudType_==MOPHUDCenterHUDTypePullOut)
    {
        
        HUD.shouldHideOnTouch = YES;
    }
    customView.tag = HudTag;
    lineLabel.tag = HudTag+1;
    iconImageView.tag = HudTag +2;

    HUD.backgroundColor = HEX_RGB(0x09091a);
    HUD.color = [UIColor whiteColor];
    HUD.alpha = 0.6;
    
}



#pragma mark -- SwipeCard Animations
-(void)receiveAnimation
{
    if (isStop) {
        return;
    }
    
    angle += 20;
    [UIView beginAnimations:@"clockwiseAnimation" context:NULL];
    [UIView setAnimationDuration:0.01f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(receiveAnimation)];
    iconImageView.transform = CGAffineTransformMakeRotation((angle * M_PI) / 180.0f);
    [UIView commitAnimations];
}


- (void)startAnimation{
    if (isStop) {
        isStop = NO;
        [self receiveAnimation];
    }
}

- (void)stopAnimation
{
    
    isStop = YES;
    angle = 0;
}


-(void)stopOperTimer
{
    
    if ([_operTime isValid]) {
        [_operTime invalidate];
        _operTime = nil;
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
//    DDLogInfo(@"HUD设为nil,hud title = %@",hud.labelText);
    if (isWaitingForHiden_)
    {
        [self hudViewInitial];
        isWaitingForHiden_ = NO;
    }
}

-(void)removeHUD
{
//    DDLogInfo(@"removeHUD");
    if (isWaitingForHiden_)
    {
        isWaitingForHiden_ = NO;
    }
    if (HUD)
    {
        [self stopAnimation];
        [self stopOperTimer];
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES];
        HUD = nil;
    }
}
-(void)removeHUDDelay
{
//    DDLogInfo(@"removeHUDDelay");
    if (isWaitingForHiden_)
    {
        isWaitingForHiden_ = NO;
    }
    if (HUD)
    {
        [self stopOperTimer];
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:1];
    }
 }

//- (void)progressTask:(MOPRoundProgressView*)progressView
//{
//    // This just increases the progress indicator in a loop
//    float progress = 0.0f;
//    while (progressing&&progress <= 1.0f) {
//        if (progress>0.99f) {
//            progress=0.0f;
//        }
//        progress += 0.01f;
//        progressView.progress = progress;
//        usleep(30000);
//    }
//}

#pragma - 状态栏提示文字
-(void)initStatusBar
{
    customStatueBar=[[MOPCustomStatueBar alloc]init];
}

- (void)showStatusMessage:(NSString *)message
{
    [customStatueBar showStatusMessage:message];
    [[customStatueBar class]cancelPreviousPerformRequestsWithTarget:self];
//    [customStatueBar performSelector:@selector(removeStatusMessage) withObject:Nil afterDelay:1.5];
    [NSThread detachNewThreadSelector:@selector(removeStatusMessage) toTarget:customStatueBar withObject:nil];
}
- (void)showStatusMessageStay:(NSString *)message
{
    [customStatueBar showStatusMessage:message];
}

@end




#pragma mark - 圆形载入视图

//@implementation MOPRoundProgressView
//{
//    BOOL progressing;
//    NSThread *progressThread;
//}
//#pragma mark -
//#pragma mark Accessors
//
//- (float)progress {
//    return _progress;
//}
//
//- (void)setProgress:(float)progress {
//    _progress = progress;
////    [self setNeedsDisplay];
//    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
//}
//
//- (void)progressTask
//{
//    // This just increases the progress indicator in a loop
//    float progress = 0.0f;
//    while (progressing&&progress <= 1.0f) {
//        if (progress>0.99f) {
//            progress=0.0f;
//        }
//        progress += 0.01f;
//        self.progress = progress;
//        usleep(10000);
//    }
//}
//
//#pragma mark - Lifecycle
//
//- (id)init {
//    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 37.0f)];
//}
//
//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//		self.opaque = NO;
//        progressThread=[[NSThread alloc]initWithTarget:self selector:@selector(progressTask) object:nil];
//        progressing=YES;
//        [progressThread start];
//    }
//    return self;
//}
//-(void)stopProgress
//{
//    progressing=NO;
////    [progressThread cancel];
////    NSLog(@"progress canceled!:%@",[progressThread isCancelled]?@"yes":@"no");
//}
//
//#pragma mark - Drawing
//
//- (void)drawRect:(CGRect)rect {
//    
//    CGRect allRect = self.bounds;
//    CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // Draw background
//    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 0.0f); // white
//    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.0f); // translucent white
//    CGContextSetLineWidth(context, 2.0f);
//    CGContextFillEllipseInRect(context, circleRect);
//    CGContextStrokeEllipseInRect(context, circleRect);
//    
//    // Draw progress
//    CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
//    CGFloat radius = (allRect.size.width - 4) / 2+1;
//    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
//    CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
//    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
//    CGContextMoveToPoint(context, center.x, center.y);
//    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
//}
//
//@end


#pragma mark - 网络载入视图

@implementation MOPNetWorkLoadingView
{
    BOOL progressing;
    NSThread *progressThread;
    UIImageView* iconImage;
}
@synthesize imageTag=_imageTag;
#pragma mark -
#pragma mark Accessors

-(void)setImageTag:(int)imageTag
{
    _imageTag=imageTag;
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
}

- (void)progressTask
{
    // This just increases the progress indicator in a loop
    int tag=0;
    while (progressing) {
        tag=tag%4;

        self.imageTag =tag;
        [NSThread sleepForTimeInterval:0.2];
        tag++;
    }
}

#pragma mark - Lifecycle

//- (id)init {
//    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 37.0f)];
//}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
        progressThread=[[NSThread alloc]initWithTarget:self selector:@selector(progressTask) object:nil];
        progressing=YES;
        [progressThread start];
    }
    return self;
}
-(void)stopProgress
{
    progressing=NO;
    //    [progressThread cancel];
    //    NSLog(@"progress canceled!:%@",[progressThread isCancelled]?@"yes":@"no");
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [iconImage removeFromSuperview];
    NSString* imageName=[NSString stringWithFormat:@"load_net%d",_imageTag];
    iconImage=[[UIImageView alloc]initWithImage:([UIImage getImageFromBundle:imageName])];
    iconImage.frame=self.bounds;
    [self addSubview:iconImage];
//    CGRect allRect = self.bounds;
//    CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // Draw background
//    CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 0.0f); // white
//    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 0.0f); // translucent white
//    CGContextSetLineWidth(context, 2.0f);
//    CGContextFillEllipseInRect(context, circleRect);
//    CGContextStrokeEllipseInRect(context, circleRect);
//    
//    // Draw progress
//    CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
//    CGFloat radius = (allRect.size.width - 4) / 2+1;
//    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
//    CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
//    CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
//    CGContextMoveToPoint(context, center.x, center.y);
//    CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
//    CGContextClosePath(context);
//    CGContextFillPath(context);
}

@end

