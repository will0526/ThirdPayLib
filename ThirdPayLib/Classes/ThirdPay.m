//
//  ThirdPay.m
//  Pods
//
//  Created by will on 16/8/10.
//
//

#import "ThirdPay.h"
#import "ShowPayTypeViewController.h"
#import "UIColor+SNAdditions.h"
#import "UIImage+SNAdditions.h"
#import "NSData+Base64.h"
#import "NSData+Utils.h"
#import "NSString+Additions.h"
#import "NSString+DES.h"
#import "NSString+Hashes.h"
#import "NSString+MD5.h"
#import "NSString+NULL.h"
#import "NSString+SEL.h"
#import "UIView+Category.h"
#import "Constant.h"
#import "EnvironmentConfig.h"
#import "GlobleConstant.h"
#import "GlobleDefine.h"
#import "SystemInfo.h"
#import "IPAddress.h"

#import "Constant.h"
#import "EnvironmentConfig.h"
#import "GlobleConstant.h"
#import "GlobleDefine.h"
#import "ShowPayTypeViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AlipaySDK/AlipaySDK.h>

@interface ThirdPay()

@property(nonatomic, weak)id<ThirdPayDelegate> thirdPayDelegate;
@property(nonatomic, strong) NSString *orderNO;


@end

@implementation ThirdPay
{
    NSString *merchantNO;
    NSString *memberNO;
    NSString *merchantOrderNO;
    NSString *goodsName;
    NSString *goodsDetail;
    NSString *memo;
    NSString *totalAmount ;
    NSString *payAmount;
    NSString *notifyURL;
    NSString *appSchemeStr;
    NSString *resultInfo;
    NSString *memberPoints;
    NSString *redPocket;
    
    
}
static ShowPayTypeViewController *payController;
//下单
+(void)payWithTradeInfo:(NSDictionary *)tradeInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate PayType:(PayType)payType
{
    
    [ThirdPay bookOrder:delegate];
    
    
    
    
    
    
}

//查询
+(void)queryOrderInfo:(NSDictionary *)tradeInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate{
    
    
}

//展示支付方式选择页面支付
+(void)showPayTypeWithTradeInfo:(NSDictionary *)tradeInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate{
    
    NSString *merchantNO = EncodeStringFromDic(tradeInfo, @"merchantNO");
    NSString *memberNO = EncodeStringFromDic(tradeInfo, @"memberNo");
    NSString *merchantOrderNO = EncodeStringFromDic(tradeInfo, @"merchantOrderNO");
    NSString *goodsName = EncodeStringFromDic(tradeInfo, @"goodsName");
    NSString *goodsDetail = EncodeStringFromDic(tradeInfo, @"goodsDetail");
    NSString *memo = EncodeStringFromDic(tradeInfo, @"memo");
    NSString *totalAmount = EncodeStringFromDic(tradeInfo, @"totalAmount");
    NSString *payAmount = EncodeStringFromDic(tradeInfo, @"payAmount");
    NSString *notifyURL = EncodeStringFromDic(tradeInfo, @"notifyURL");
    NSString *appSchemeStr = EncodeStringFromDic(tradeInfo, @"appSchemeStr");
    NSString *resultInfo = @"";
    
    if (IsStrEmpty(merchantNO)) {
        resultInfo = @"商户号不能为空";
    }else if (IsStrEmpty(merchantOrderNO)){
        resultInfo = @"商户订单号不能为空";
    }else if (IsStrEmpty(goodsName)){
        resultInfo = @"商品名称不能为空";
    }else if (IsStrEmpty(goodsDetail)){
        resultInfo = @"商品详情不能为空";
    }else if (IsStrEmpty(totalAmount)){
        resultInfo = @"订单金额不能为空";
    }else if (IsStrEmpty(payAmount)){
        resultInfo = @"支付金额不能为空";
    }else if (IsStrEmpty(notifyURL)){
        resultInfo = @"后台通知地址不能为空";
    }else if (IsStrEmpty(appSchemeStr)){
        resultInfo = @"appSchemeStr不能为空";
    }else{
        resultInfo = @"";
    }
    if (!IsStrEmpty(resultInfo)) {
        tradeInfo = @{@"resultInfo":resultInfo};
        if (delegate && [delegate respondsToSelector:@selector(onPayResult:withInfo:)]) {
            [delegate onPayResult:PayStatus_PAYFAIL withInfo:tradeInfo];
            return;
        }
    }
    
    
    payController = [[ShowPayTypeViewController alloc]init];
    
    payController.memberNO = memberNO;
    payController.merchantNO = merchantNO;
    payController.merchantOrderNO = merchantOrderNO;
    payController.goodsName = goodsName;
    payController.goodsDetail = goodsDetail;
    payController.memo = memo;
    payController.totalAmount = totalAmount;
    payController.payAmount = payAmount;
    payController.notifyURL = notifyURL;
    payController.appScheme = appSchemeStr;
    payController.thirdPayDelegate = delegate;
    
    [controller.navigationController pushViewController:payController animated:YES];
    
    
    
    
    //    payController
    
    
}


//下单

+(void)bookOrder:(id<ThirdPayDelegate>)delegate
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlStr = @"http://www.baidu.com";
    manager.requestSerializer.timeoutInterval = 30;
    NSDictionary *params = [[NSDictionary alloc]init];
    [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSLog(@"........................................................success");
        
        [delegate onPayResult:PayStatus_PAYFAIL withInfo:@{@"test":@"test"}];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [delegate onPayResult:PayStatus_PAYFAIL withInfo:@{@"test":@"test"}];
        NSLog(@"........................................................fail");
    }];
    
    
}

+(Boolean)handleOpenURL:(NSURL *)url withCompletion:(ThirdPayCompletion)complete{
    [payController handleOpenURL:url withCompletion:complete];
    
    
        return YES;
}




@end
