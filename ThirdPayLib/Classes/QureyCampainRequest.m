//
//  QureyCampainRequest.m
//  Pods
//
//  Created by will on 2017/3/31.
//
//

#import "QureyCampainRequest.h"

@implementation QureyCampainRequest



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
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"1015", @"transType");
    EncodeUnEmptyStrObjctToDic(self.requestParamDic, @"0000", @"payType");
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (IsStrEmpty(self.pageNo)) {
        self.pageNo = @"1";
    }
    if (IsStrEmpty(self.pageSize)) {
        self.pageSize = @"10";
    }
    EncodeUnEmptyStrObjctToDic(dic, self.pageNo, @"pageNo");
    EncodeUnEmptyStrObjctToDic(dic, self.pageSize, @"pageSize");
    
    EncodeUnEmptyStrObjctToDic(dic, self.merchantNo, @"merchantNo");
    EncodeUnEmptyDicObjctToDic(self.requestParamDic, dic, @"params");
    
    return self.requestParamDic;
}

@end
