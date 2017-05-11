//
//  ObjectiveCAdaptor.h
//  bankcard
//
//  Created by Liu Yiqun on 15/10/12.
//  Copyright (c) 2015年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <UIKit/UIKit.h>

@interface BankcardAdaptor: NSObject

@property (nonatomic, readonly) NSInteger flag;
@property (nonatomic, readonly) NSInteger lineStart;
@property (nonatomic, readonly) NSInteger lineEnd;

@property (nonatomic, readonly) NSInteger cardNumberLength;
@property (nonatomic, readonly) NSMutableArray *leftArray;
@property (nonatomic, readonly) NSMutableArray *rightArray;
@property (nonatomic, readonly) NSMutableArray *blankFlagArray;
@property (nonatomic, readonly) NSMutableArray *cardNumberArray;
@property (nonatomic, copy, readonly) NSString *cardNumber;

@property (nonatomic, readonly) CGRect dtcFstRect;

@property (nonatomic, readonly) NSInteger dstImageHeight;
@property (nonatomic, readonly) NSInteger dstImageWidth;
@property (nonatomic, readonly) UIImage *dstRGBImage;

- (BOOL)canWork;
- (void)initWithAPIKey:(NSString *)apiKey andLocalLicenceFile:(NSString *)localLicencePath;
- (BOOL)initWithToken:(NSString *)token;

- (int)runBankcardProcess:(UIImage *)bankcardImage
       andNumberOfThreads:(int)num_threads
        andDispLargeImage:(BOOL)disp_large_image;
- (int)releaseBankcardMemory;

@end
