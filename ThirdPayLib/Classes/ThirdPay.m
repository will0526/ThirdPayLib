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

#import "CommonService.h"
#import "QueryOrderRequest.h"

#import "OrderInfo.h"

#import "QRCodeViewController.h"

@interface ThirdPay()<QRCodeDelegate>

@property(nonatomic, weak)id<ThirdPayDelegate> thirdPayDelegate;
@property(nonatomic, strong) NSString *orderNO;


@end

@implementation ThirdPay
{
    NSString *merchantNo;
    NSString *accountNo;
    NSString *merchantOrderNo;
    NSString *orderTitle;
    NSString *orderDetail;
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
    if ([ThirdPay checkParams:tradeInfo delegate:delegate]) {
        
        [ThirdPay assignParams:tradeInfo delegate:delegate];
        payController.payType = payType;
        [payController bookOrder];
    }
    
    
}

//查询
+(void)queryOrderInfo:(NSDictionary *)tradeInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate{
    
    NSString *merchantNo = EncodeStringFromDic(tradeInfo, @"merchantNo");
    
    NSString *orderNO = EncodeStringFromDic(tradeInfo, @"orderNO");
    NSString *resultInfo = @"";
    
    if (IsStrEmpty(merchantNo)) {
        resultInfo = @"商户号不能为空";
    }else if (IsStrEmpty(orderNO)){
        resultInfo = @"订单号不能为空";
    }
    
    if (!IsStrEmpty(resultInfo)) {
        tradeInfo = @{@"resultInfo":resultInfo};
        if (delegate && [delegate respondsToSelector:@selector(onQueryOrder:)]) {
            [delegate onQueryOrder:tradeInfo];
            return;
        }
    }
    
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@""
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:controller
                                   showBackground:YES];
    QueryOrderRequest *request = [[QueryOrderRequest alloc]init];
    request.merchantNo = merchantNo;
    request.orderNO = orderNO;
    
    BaseResponse *response = [[BaseResponse alloc]init];
    
    [CommonService beginService:request response:response success:^(BaseResponse *response) {
        
        NSLog(@"response.json......%@",response.jsonDict);
        
        NSDictionary *dict = [self combilParams:response.jsonDict];
        
        [[MOPHUDCenter shareInstance]removeHUD];
        
        if (delegate && [delegate respondsToSelector:@selector(onQueryOrder:)]) {
            [delegate onQueryOrder:dict];
            return;
        }
        
    } failed:^(NSString *errorCode, NSString *errorMsg) {
        
        [[MOPHUDCenter shareInstance]removeHUD];
        
        NSDictionary *dict = @{@"message":errorMsg,@"code":errorCode};
        
        if (delegate && [delegate respondsToSelector:@selector(onQueryOrder:)]) {
            [delegate onQueryOrder:dict];
            return;
        }
    } controller:controller showProgressBar:NO];
    
}

+(NSDictionary *)combilParams:(NSDictionary *)dic{
    
    NSString *merchantNo = EncodeStringFromDic(dic, @"merchantNo");
    NSString *batchNo = EncodeStringFromDic(dic, @"batchNo");
    
    NSDictionary *data = EncodeDicFromDic(dic, @"data");
    
    NSString *merchantName = EncodeStringFromDic(data, @"sellerName");
    NSString *merchantOrderNo = EncodeStringFromDic(data, @"orderNo");
    NSString *ippOrderNo = EncodeStringFromDic(data, @"ippOrderNo");
    NSString *payMethod = EncodeStringFromDic(data, @"payMethod");
    
    NSString *orderStatus = EncodeStringFromDic(data, @"orderStatus");
    NSString *orderDate = EncodeStringFromDic(data, @"orderDate");
    NSString *orderTime = EncodeStringFromDic(data, @"orderTime");
    NSString *payTime = EncodeStringFromDic(data, @"payTime");
//    NSString *transStatus = EncodeStringFromDic(data, @"transStatus");
    NSString *totalAmount = EncodeStringFromDic(data, @"orderSubject");
    NSString *payAmount = EncodeStringFromDic(data, @"orderAmount");
//    NSArray *transInfo = EncodeArrayFromDic(data, @"transInfo");
    NSString *memo = EncodeStringFromDic(data, @"attach");
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    EncodeDefaultStrObjctToDic(dict, merchantNo, @"merchantNo",@"");
    EncodeDefaultStrObjctToDic(dict, merchantName, @"merchantName",@"");
    
    EncodeDefaultStrObjctToDic(dict, batchNo, @"batchNo",@"");
    EncodeDefaultStrObjctToDic(dict, merchantOrderNo, @"merchantOrderNo",@"");
    EncodeDefaultStrObjctToDic(dict, ippOrderNo, @"ippOrderNo",@"");
    
    EncodeDefaultStrObjctToDic(dict, totalAmount, @"totalAmount",@"");
    EncodeDefaultStrObjctToDic(dict, payAmount, @"payAmount",@"");
    
    EncodeDefaultStrObjctToDic(dict, payTime, @"payTime",@"");
    EncodeDefaultStrObjctToDic(dict, orderDate, @"orderTime",@"");
    EncodeDefaultStrObjctToDic(dict, orderTime, @"orderDate",@"");
    EncodeDefaultStrObjctToDic(dict, orderStatus, @"transStatus",@"");
    EncodeDefaultStrObjctToDic(dict, payMethod, @"payMethod",@"");
    EncodeDefaultStrObjctToDic(dict, memo, @"memo",@"");
    
    return dict;
    
}

//展示支付方式选择页面支付
+(void)showPayTypeWithTradeInfo:(NSDictionary *)tradeInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate{
    
    NSString *merchantNo = EncodeStringFromDic(tradeInfo, @"merchantNo");
    
    NSString *accountNo = EncodeStringFromDic(tradeInfo, @"accountNo");
    NSString *merchantOrderNo = EncodeStringFromDic(tradeInfo, @"merchantOrderNo");
    NSString *orderTitle = EncodeStringFromDic(tradeInfo, @"orderTitle");
    NSString *orderDetail = EncodeStringFromDic(tradeInfo, @"orderDetail");
    NSString *memo = EncodeStringFromDic(tradeInfo, @"memo");
    NSString *totalAmount = EncodeStringFromDic(tradeInfo, @"totalAmount");
    NSString *payAmount = EncodeStringFromDic(tradeInfo, @"payAmount");
    NSString *redPocket = EncodeStringFromDic(tradeInfo, @"redPocket");
    NSString *point = EncodeStringFromDic(tradeInfo, @"point");
    NSString *notifyURL = EncodeStringFromDic(tradeInfo, @"notifyURL");
    NSString *appSchemeStr = EncodeStringFromDic(tradeInfo, @"appSchemeStr");
    
    NSString *resultInfo = @"";
    
    if (IsStrEmpty(accountNo)) {
        resultInfo = @"用户号不能为空";
    }else if (IsStrEmpty(merchantNo)) {
        resultInfo = @"商户号不能为空";
    }else if (IsStrEmpty(merchantOrderNo)){
        resultInfo = @"商户订单号不能为空";
    }else if (IsStrEmpty(orderTitle)){
        resultInfo = @"商品名称不能为空";
    }else if (IsStrEmpty(orderDetail)){
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
    
    DDLog(@"test", merchantNo);
    
    payController = [[ShowPayTypeViewController alloc]init];
    
    payController.accountNo = accountNo;
    payController.merchantNo = merchantNo;
    payController.merchantOrderNo = merchantOrderNo;
    payController.orderTitle = orderTitle;
    payController.orderDetail = orderDetail;
    payController.memo = memo;
    payController.totalAmount = totalAmount;
    payController.payAmount = payAmount;
    payController.redPocket = redPocket;
    payController.memberPoints = point;
    payController.notifyURL = notifyURL;
    payController.appScheme = appSchemeStr;
    payController.thirdPayDelegate = delegate;
    payController.viewType = @"VIEW";
    
    [controller.navigationController pushViewController:payController animated:YES];
    
}

+(BOOL)checkParams:(NSDictionary *)tradeInfo delegate:(id<ThirdPayDelegate>)delegate{
    
    NSString *merchantNo = EncodeStringFromDic(tradeInfo, @"merchantNo");
    NSString *accountNo = EncodeStringFromDic(tradeInfo, @"accountNo");
    NSString *merchantOrderNo = EncodeStringFromDic(tradeInfo, @"merchantOrderNo");
    NSString *orderTitle = EncodeStringFromDic(tradeInfo, @"orderTitle");
    NSString *orderDetail = EncodeStringFromDic(tradeInfo, @"orderDetail");
    NSString *memo = EncodeStringFromDic(tradeInfo, @"memo");
    NSString *totalAmount = EncodeStringFromDic(tradeInfo, @"totalAmount");
    NSString *payAmount = EncodeStringFromDic(tradeInfo, @"payAmount");
    NSString *redPocket = EncodeStringFromDic(tradeInfo, @"redPocket");
    NSString *point = EncodeStringFromDic(tradeInfo, @"point");
    NSString *notifyURL = EncodeStringFromDic(tradeInfo, @"notifyURL");
    NSString *appSchemeStr = EncodeStringFromDic(tradeInfo, @"appSchemeStr");
    NSString *resultInfo = @"";
    
    if (IsStrEmpty(merchantNo)) {
        resultInfo = @"商户号不能为空";
    }else if (IsStrEmpty(merchantOrderNo)){
        resultInfo = @"商户订单号不能为空";
    }else if (IsStrEmpty(orderTitle)){
        resultInfo = @"商品名称不能为空";
    }else if (IsStrEmpty(orderDetail)){
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
            return NO;
        }
    }
    return YES;
    
}

+(void)assignParams:(NSDictionary *)tradeInfo delegate:(id<ThirdPayDelegate>)delegate{
    
    NSString *merchantNo = EncodeStringFromDic(tradeInfo, @"merchantNo");
    NSString *accountNo = EncodeStringFromDic(tradeInfo, @"accountNo");
    NSString *merchantOrderNo = EncodeStringFromDic(tradeInfo, @"merchantOrderNo");
    NSString *orderTitle = EncodeStringFromDic(tradeInfo, @"orderTitle");
    NSString *orderDetail = EncodeStringFromDic(tradeInfo, @"orderDetail");
    NSString *memo = EncodeStringFromDic(tradeInfo, @"memo");
    NSString *totalAmount = EncodeStringFromDic(tradeInfo, @"totalAmount");
    NSString *payAmount = EncodeStringFromDic(tradeInfo, @"payAmount");
    NSString *redPocket = EncodeStringFromDic(tradeInfo, @"redPocket");
    NSString *point = EncodeStringFromDic(tradeInfo, @"point");
    NSString *notifyURL = EncodeStringFromDic(tradeInfo, @"notifyURL");
    NSString *appSchemeStr = EncodeStringFromDic(tradeInfo, @"appSchemeStr");
    
    payController = [[ShowPayTypeViewController alloc]init];
    
    payController.accountNo = accountNo;
    payController.merchantNo = merchantNo;
    payController.merchantOrderNo = merchantOrderNo;
    payController.orderTitle = orderTitle;
    payController.orderDetail = orderDetail;
    payController.memo = memo;
    payController.totalAmount = totalAmount;
    payController.payAmount = payAmount;
    payController.redPocket = redPocket;
    payController.memberPoints = point;
    payController.notifyURL = notifyURL;
    payController.appScheme = appSchemeStr;
    payController.thirdPayDelegate = delegate;
    
    payController.viewType = @"NOVIEW";
}

+(Boolean)handleOpenURL:(NSURL *)url withCompletion:(ThirdPayCompletion)complete{
    
    [payController handleOpenURL:url withCompletion:complete];
    return YES;
}


+(void)scanQRCode:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate{
    
    
    QRCodeViewController *qrcode = [[QRCodeViewController alloc]init];
    qrcode.thirdPayDelegate = delegate;
    [controller.navigationController pushViewController:qrcode animated:YES];
}





@end
