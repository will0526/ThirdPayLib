//
//  NSData+Utils.h
//  UMSCashier
//
//  Created by will on 14-4-17.
//  Copyright (c) 2014年 UMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Utils)

- (NSMutableArray *)spliteData2Array:(NSUInteger) size;

+ (NSData *)getIntegrationData:(NSMutableArray *) arr;

- (NSString *)toHexString;
@end
