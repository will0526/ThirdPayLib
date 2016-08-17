//
//  UMSBaseResponse.m
//  UMSCashier
//
//  Created by will on 14-3-16.
//  Copyright (c) 2014年 UMS. All rights reserved.
//

#import "BaseResponse.h"
#import "CommonDTO.h"

@implementation BaseResponse

@synthesize jsonDict;

-(id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

-(NSDictionary *)getJsonDict
{
    return jsonDict;
}

-(void)praseJsondicttoResponse
{

}

-(CommonDTO *)dtoToDictionary:(NSDictionary *)jsonDict
{
    return nil;
}
@end
