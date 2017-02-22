//
//  VoucherData.m
//  Pods
//
//  Created by will on 2017/2/8.
//
//

#import "VoucherData.h"

@implementation VoucherData


+(VoucherData *)initWithDict:(NSDictionary *)dict{
    
    VoucherData *temp = [[VoucherData alloc]init];
    temp.voucherType = EncodeStringFromDic(dict, @"voucherType");
    temp.voucherId = EncodeStringFromDic(dict, @"voucherId");
    temp.voucherNo = EncodeStringFromDic(dict, @"voucherNo");
    temp.startTime = EncodeStringFromDic(dict, @"startTime");
    temp.expirationTime = EncodeStringFromDic(dict, @"expirationTime");
    temp.availableStartTime = EncodeStringFromDic(dict, @"availableStartTime");
    temp.availableEndTime = EncodeStringFromDic(dict, @"availableEndTime");
    temp.voucherAmount = EncodeStringFromDic(dict, @"voucherAmount");
    temp.usePayType = EncodeStringFromDic(dict, @"usePayType");
    temp.voucherName = EncodeStringFromDic(dict, @"voucherName");
    temp.voucherDescription = EncodeStringFromDic(dict, @"voucherDescription");
    
    
    if([@"0" isEqualToString:EncodeStringFromDic(dict, @"superposeType")]){
        temp.superposeType = NO;
    }else{
        temp.superposeType = YES;
    }
    
    temp.satisfyOrderAmount = EncodeStringFromDic(dict, @"satisfyOrderAmount");
    temp.discount = EncodeStringFromDic(dict, @"discount");
    
    
    
    return temp;
    
}
@end
