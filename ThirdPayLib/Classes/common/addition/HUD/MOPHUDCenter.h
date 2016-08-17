//
//  MOPHUDCenter.h
//  MOPMobileClient
//
//  Created by sunyard on 12-12-18.
//  Copyright (c) 2012年 com.sunyard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOPCustomStatueBar.h"

#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, MOPHUDCenterHUDType) {
    MOPHUDCenterHUDTypeIposLoading,
    MOPHUDCenterHUDTypeNetWorkLoading,//强制性动画
    MOPHUDCenterHUDTypePullOut,//非强制性动画
    MOPHUDCenterHUDTypeSuccess,
    MOPHUDCenterHUDTypeRightDevice,
    MOPHUDCenterHUDTypeWrongDevice,
    MOPHUDCenterHUDTypeWarming
};


#define HudTag 10000

@protocol MOPProgressView <NSObject>

-(void)stopProgress;

@end

@interface MOPHUDCenter : NSObject<MBProgressHUDDelegate>
@property (nonatomic,assign) CGRect cardStartFrame;
@property (nonatomic,assign) CGRect cardEndFrame;
@property (nonatomic,strong) NSTimer *operTime;
@property (nonatomic,strong) MBProgressHUD *HUD;
+(MOPHUDCenter*)shareInstance;

-(void)showAlert:(NSString*)message;
//强制性动画ctl传nil  非强制性动画把controller传过来
-(void)showHUDWithTitle:(NSString*)title
                   type:(MOPHUDCenterHUDType)hudType
             controller:(UIViewController *)ctl
         showBackground:(BOOL)background;

-(void)showHUDWithTitle:(NSString*)title
                   type:(MOPHUDCenterHUDType)hudType
                   view:(UIView *)view
         showBackground:(BOOL)background;


-(void)removeHUD;

- (void)showStatusMessage:(NSString *)message;
- (void)showStatusMessageStay:(NSString *)message;

-(void)initStatusBar;
@end


////圆饼loading
//
//@interface MOPRoundProgressView : UIView<MOPProgressView> {
//@private
//    float _progress;
//}
//
///**
// * Progress (0.0 to 1.0)
// */
//@property (nonatomic, assign) float progress;
//
//@end

//NETloading

@interface MOPNetWorkLoadingView : UIView<MOPProgressView> 

@property(nonatomic,assign) int imageTag;

@end