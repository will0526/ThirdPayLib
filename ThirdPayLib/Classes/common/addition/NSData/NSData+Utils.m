//
//  NSData+Utils.m
//  UMSCashier
//
//  Created by will on 14-4-17.
//  Copyright (c) 2014年 UMS. All rights reserved.
//

#import "NSData+Utils.h"

@implementation NSData (Utils)

-(NSMutableArray *)spliteData2Array:(NSUInteger) size
{
    NSUInteger lengthDest = [self length] % size == 0 ?
    [self length] / size : [self length] / size + 1;
    
    NSMutableArray * arr = [[NSMutableArray alloc] initWithCapacity:lengthDest];
    
    for (NSUInteger i = 0 ; i < lengthDest; i ++) {
        NSUInteger lengthTemp = 0;
        if (i == lengthDest - 1) {
            lengthTemp = [self length] % size == 0 ?
            size : [self length] % size;
            
        } else {
            lengthTemp = size;
            
        }
        NSData * tempData = [self subdataWithRange:NSMakeRange(i*size, lengthTemp)];
        [arr addObject:tempData];
    }
    return arr;
}

+ (NSData *)getIntegrationData:(NSMutableArray *) arr
{
    NSMutableData * integrationData = [NSMutableData data];
    for (NSData * data in arr) {
        [integrationData appendData:data];
    };
    return integrationData;
}

-(NSString *)toHexString
{
    Byte *bytes = (Byte *)[self bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[self length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

@end
