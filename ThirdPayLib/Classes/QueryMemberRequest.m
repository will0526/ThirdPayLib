//
//  QueryMemberRequest.m
//  Pods
//
//  Created by will on 2016/12/26.
//
//

#import "QueryMemberRequest.h"

@implementation QueryMemberRequest



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

-(NSDictionary *)dtoToDictionary
{
    [super dtoToDictionary];
    
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, self.merchantNo, @"merchantNo");
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"1006", @"transType");
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"0000", @"payType");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    
    EncodeUnEmptyStrObjctToDic(dic, self.orderAmount, @"orderAmount");
    EncodeUnEmptyStrObjctToDic(dic, self.accountNo, @"accountNo");
    EncodeUnEmptyStrObjctToDic(dic, self.accountType, @"accountType");
    EncodeUnEmptyDicObjctToDic(self.requestParamDic, dic, @"params");
    
    return self.requestParamDic;
}

@end