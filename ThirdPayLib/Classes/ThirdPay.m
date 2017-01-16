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

#import "PNROrderInfo.h"
#import "PNRMemberInfo.h"
#import "QRCodeViewController.h"
#import "QueryMemberRequest.h"
#import "QueryAllMemberInfoRequest.h"
#import "PNROtherPayInfo.h"
#import "PNRGoodsInfo.h"

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
+(void)payWithTradeInfo:(PNROrderInfo *)orderInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate
{
    if ([ThirdPay checkParams:orderInfo delegate:delegate]) {
        
        payController = [[ShowPayTypeViewController alloc]init];
        
        payController.thirdPayDelegate = delegate;
        payController.orderInfo = orderInfo;
        payController.payType = orderInfo.paytype;
        payController.viewType = @"NOVIEW";
        [payController bookOrder];
    }
    
    
}

//查询
+(void)queryOrderInfo:(PNROrderInfo *)tradeInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate{
    
    NSString *merchantNo = tradeInfo.merchantNo;
    
    NSString *orderNO = tradeInfo.ippOrderNo;
    NSString *resultInfo = @"";
    
    if (IsStrEmpty(merchantNo)) {
        resultInfo = @"商户号不能为空";
    }else if (IsStrEmpty(orderNO)){
        resultInfo = @"订单号不能为空";
    }
    NSDictionary *dict = [[NSDictionary alloc]init];
    if (!IsStrEmpty(resultInfo)) {
        dict = @{@"resultInfo":resultInfo};
        if (delegate && [delegate respondsToSelector:@selector(onQueryOrder:)]) {
            [delegate onQueryOrder:dict];
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

+(void)queryMemberInfoForOrder:(PNRMemberInfo *)memberInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate{

    NSString *merchantNo = memberInfo.merchantNo;
    NSString *orderAmount = memberInfo.orderAmount;
    NSString *accountNo = memberInfo.accountNo;
    NSString *accountType = memberInfo.accountType;
    
    NSString *resultInfo = @"";
    
    if (IsStrEmpty(merchantNo)) {
        resultInfo = @"商户号不能为空";
    }else if (IsStrEmpty(orderAmount)){
        resultInfo = @"订单金额不能为空";
    }else if (IsStrEmpty(accountNo)){
        resultInfo = @"用户账号号不能为空";
    }else if (IsStrEmpty(accountType)){
        resultInfo = @"账号类型不能为空";
    }
    
    NSDictionary *dict = [[NSDictionary alloc]init];
    if (!IsStrEmpty(resultInfo)) {
        dict = @{@"resultInfo":resultInfo};
        if (delegate && [delegate respondsToSelector:@selector(onQueryOrder:)]) {
            [delegate onQueryMemberForOrder:dict];
            return;
        }
    }
    
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@""
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:controller
                                   showBackground:YES];
    QueryMemberRequest *request = [[QueryMemberRequest alloc]init];
    request.merchantNo = merchantNo;
    request.accountType = accountType;
    request.accountNo = accountNo;
    request.orderAmount = orderAmount;
    
    BaseResponse *response = [[BaseResponse alloc]init];
    
    [CommonService beginService:request response:response success:^(BaseResponse *response) {
        
        NSLog(@"response.json......%@",response.jsonDict);
        
        NSDictionary *dict = response.jsonDict;
        
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

+(void)queryMemberInfo:(PNRMemberInfo *)memberInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate{
    
    NSString *merchantNo = memberInfo.merchantNo;
    NSString *accountNo = memberInfo.accountNo;
    NSString *accountType = memberInfo.accountType;
    
    NSString *resultInfo = @"";
    
    if (IsStrEmpty(merchantNo)) {
        resultInfo = @"商户号不能为空";
    }else if (IsStrEmpty(accountNo)){
        resultInfo = @"用户账号号不能为空";
    }else if (IsStrEmpty(accountType)){
        resultInfo = @"账号类型不能为空";
    }
    
    NSDictionary *dict = [[NSDictionary alloc]init];
    if (!IsStrEmpty(resultInfo)) {
        dict = @{@"resultInfo":resultInfo};
        if (delegate && [delegate respondsToSelector:@selector(onQueryOrder:)]) {
            [delegate onQueryMemberForOrder:dict];
            return;
        }
    }
    
    [[MOPHUDCenter shareInstance]showHUDWithTitle:@""
                                             type:MOPHUDCenterHUDTypeNetWorkLoading
                                       controller:controller
                                   showBackground:YES];
    QueryAllMemberInfoRequest *request = [[QueryAllMemberInfoRequest alloc]init];
    request.merchantNo = merchantNo;
    request.accountType = accountType;
    request.accountNo = accountNo;
    
    BaseResponse *response = [[BaseResponse alloc]init];
    
    [CommonService beginService:request response:response success:^(BaseResponse *response) {
        
        NSLog(@"response.json......%@",response.jsonDict);
        
        NSDictionary *dict = response.jsonDict;
        
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


//展示支付方式选择页面支付
+(void)showPayTypeWithTradeInfo:(PNROrderInfo *)orderInfo ViewController:(UIViewController *)controller Delegate:(id<ThirdPayDelegate>)delegate{
    
   
    NSString *resultInfo = @"";
    
    if (IsStrEmpty(orderInfo.merchantNo)) {
        resultInfo = @"商户号不能为空";
    }else if (IsStrEmpty(orderInfo.merchantOrderNo)){
        resultInfo = @"商户订单号不能为空";
    }else if (IsStrEmpty(orderInfo.orderSubject)){
        resultInfo = @"订单名称不能为空";
    }else if (IsStrEmpty(orderInfo.orderDescription)){
        resultInfo = @"订单描述不能为空";
    }else if (IsStrEmpty(orderInfo.totalAmount)){
        resultInfo = @"订单金额不能为空";
    }else if (IsStrEmpty(orderInfo.payAmount)){
        resultInfo = @"支付金额不能为空";
    }else if (IsStrEmpty(orderInfo.notifyURL)){
        resultInfo = @"后台通知地址不能为空";
    }else if (IsStrEmpty(orderInfo.appSchemeStr)){
        resultInfo = @"appSchemeStr不能为空";
    }else{
        resultInfo = @"";
    }
    
    if (!IsStrEmpty(resultInfo)) {
        
        NSDictionary * tradeInfo = @{@"resultInfo":resultInfo};
        
        if (delegate && [delegate respondsToSelector:@selector(onPayResult:withInfo:)]) {
            [delegate onPayResult:PayStatus_PAYFAIL withInfo:tradeInfo];
            return;
        }
    }
    
    
    payController = [[ShowPayTypeViewController alloc]init];
    
    
    payController.thirdPayDelegate = delegate;
    payController.orderInfo = orderInfo;
    payController.viewType = @"VIEW";
    
    [controller.navigationController pushViewController:payController animated:YES];
    
}

+(BOOL)checkParams:(PNROrderInfo *)orderInfo delegate:(id<ThirdPayDelegate>)delegate{
    
  
    NSString *resultInfo = @"";
    
    if (IsStrEmpty(orderInfo.merchantNo)) {
        resultInfo = @"商户号不能为空";
    }else if (IsStrEmpty(orderInfo.merchantOrderNo)){
        resultInfo = @"商户订单号不能为空";
    }else if (IsStrEmpty(orderInfo.orderSubject)){
        resultInfo = @"订单名称不能为空";
    }else if (IsStrEmpty(orderInfo.orderDescription)){
        resultInfo = @"订单描述不能为空";
    }else if (IsStrEmpty(orderInfo.totalAmount)){
        resultInfo = @"订单金额不能为空";
    }else if (IsStrEmpty(orderInfo.payAmount)){
        resultInfo = @"支付金额不能为空";
    }else if (IsStrEmpty(orderInfo.notifyURL)){
        resultInfo = @"后台通知地址不能为空";
    }else if (IsStrEmpty(orderInfo.appSchemeStr)){
        resultInfo = @"appSchemeStr不能为空";
    }else if (!IsArrEmpty(orderInfo.goodsInfo)) {
        for (PNRGoodsInfo *temp in orderInfo.goodsInfo) {
            if (IsStrEmpty(temp.goodsNo)) {
                resultInfo = @"商品信息格式不正确";
            }else if (IsStrEmpty(temp.goodsName)){
                resultInfo = @"商品信息格式不正确";
            }else if (IsStrEmpty(temp.goodsBody)){
                resultInfo = @"商品信息格式不正确";
            }else if (IsStrEmpty(temp.goodsPrice)){
                resultInfo = @"商品信息格式不正确";
            }else if (IsStrEmpty(temp.goodsNumber)){
                resultInfo = @"商品信息格式不正确";
            }
        }
        
        
    }else if (IsArrEmpty(orderInfo.otherPayInfo)){
        for (PNROtherPayInfo *temp in orderInfo.otherPayInfo) {
            if (IsStrEmpty(temp.voucherType)) {
                resultInfo =@"优惠券信息格式不正确";
            }else if(IsStrEmpty(temp.voucherId)){
                resultInfo =@"优惠券信息格式不正确";
            }else if(IsStrEmpty(temp.voucherPayAmount)){
                resultInfo =@"优惠券信息格式不正确";
            }
        }
    }else{
        resultInfo =@"";
        
    }
    
    
    if (!IsStrEmpty(resultInfo)) {
        
        NSDictionary * tradeInfo = @{@"resultInfo":resultInfo};
        
        if (delegate && [delegate respondsToSelector:@selector(onPayResult:withInfo:)]) {
            [delegate onPayResult:PayStatus_PAYFAIL withInfo:tradeInfo];
            return NO;
        }
    }
    return YES;
    
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
