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
#import <AFNetworking/AFNetworking.h>"

@interface ThirdPay()


@end

@implementation ThirdPay

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
    
    
    ShowPayTypeViewController *payController = [[ShowPayTypeViewController alloc]init];
    
    payController.memberNO = memberNO;
    payController.merchantNO = merchantNO;
    payController.merchantOrderNO = merchantOrderNO;
    payController.goodsName = goodsName;
    payController.goodsDetail = goodsDetail;
    payController.memo = memo;
    payController.totalAmount = totalAmount;
    payController.payAmount = payAmount;
    payController.notifyURL = notifyURL;
    
    payController.thirdPayDelegate = delegate;
    
    [controller.navigationController pushViewController:payController animated:YES];
    
    
    
    
    //    payController
    
    
}


//下单

+(void)bookOrder:(id<ThirdPayDelegate>)delegate
{
    NSLog(@"net.......test");
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        NSString *urlStr = @"http://www.baidu.com";
        manager.requestSerializer.timeoutInterval = 30;
        NSDictionary *params = [[NSDictionary alloc]init];
        [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            NSLog(@"net is ok");
        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
            NSLog(@"net is failed");
        }];
    
    
}

@end
