//
//  BDWalletSDKMainManager.h
//  BaiduWalletSDK
//
//  Created by lushuang on 14-3-13.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


// 进入SDK返回的错误类型
typedef enum BDWalletSDK_Error_Type {
    BDWalletSDK_Error_None              = 0,// 无错
    BDWalletSDK_Error_Net               = 1,// 网络异常
    BDWalletSDK_Error_OrderInfo         = 2,// orderInfo异常
    BDWalletSDK_Error_InvalidDelegate   = 3,// 传入无效Delegate
    BDWalletSDK_Error_Unlogin           = 4,// 未登录
    BDWalletSDK_Error_Other             = 5,// 其他未知错误
    BDWalletSDK_Error_InvalidParameters = 6,// 无效参数
    BDWalletSDK_Error_InvalidLogin      = 5003,// 无效登录状态
}BDWalletSDKErrorType;


@protocol BDWalletSDKMainManagerDelegate <NSObject>


// 支付回调接口
-(void)BDWalletPayResultWithCode:(int)statusCode payDesc:(NSString*)payDescs;

@end



@interface BDWalletSDKMainManager : NSObject

// 必须设置的参数
@property (nonatomic, weak) UIViewController *rootViewController;// 优先设置rootViewController，如果delegate是一个UIViewController 可以将rootViewController设置为nil或与delegate一致
@property (nonatomic, weak) id<BDWalletSDKMainManagerDelegate> delegate;// 如果delegate 与 rootViewController需要匹配设置
 // 可选参数
@property (nonatomic, assign) BOOL leaveBDWalletSDKAnimate;// 离开sdk是否需要动画,默认为YES

// statusBarStyle
@property (assign, nonatomic)UIStatusBarStyle statusBarStyle;
@property (assign, nonatomic)UIStatusBarStyle oldStatusBarStyle;

// navgationBar
@property (nonatomic, strong) UIColor *bdWalletSDKNavColor;// nav背景色
@property (nonatomic, strong) UIFont *bdWalletNavTitleFont;//导航条Title字体，不设置使用默认字体
@property (nonatomic, strong) UIColor *bdWalletNavTitleColor;// title颜色
@property (nonatomic, strong) UIColor *bdWalletNavBottomTitleColor; //title下部文本颜色
@property (nonatomic, strong) UIImage *bdWalletNavBackNormalImage;// 返回键Normal
@property (nonatomic, strong) UIImage *bdWalletNavBackHighlightImage;// 返回键highlight
@property (nonatomic, strong) UIImage *bdWalletNavBgImage;// navbar背景

// 导航返回自定义
@property (nonatomic, strong) UIColor *bdWalletNavGobackColor;// goback颜色
@property (nonatomic, strong) UIColor *bdWalletNavGobackHighlightedColor;// goback Highlighted颜色
@property (nonatomic, strong) UIFont  *bdWalletNavGobackFont;//返回字体大小
@property (nonatomic, strong) NSString *bdWalletNavGobackTitle;// goback文字，不设置，默认为无文字

@property (nonatomic, assign) UIEdgeInsets bdWalletNavBacktitleEdgeInset;// 返回文字偏移量
@property (nonatomic, assign) UIEdgeInsets bdWalletNavBackimageEdgeInset;// 返回图片偏移量


/**
 * @breif  获取当前实例
 */
+(BDWalletSDKMainManager*)getInstance;

/**
 * @breif  支付接口
 * @param  orderInfo  订单信息
 * @param  params     可不传
 * @param  delegateT  sdk代理
 */
-(BDWalletSDKErrorType)doPayWithOrderInfo:(NSString*)orderInfo params:(NSDictionary*)params delegate:(id<BDWalletSDKMainManagerDelegate>)delegateT;


@end

