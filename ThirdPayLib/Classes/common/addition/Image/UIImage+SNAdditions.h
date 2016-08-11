//
//  UIImage+SNAdditions.h
//  SNFramework
//
//  Created by  liukun on 13-1-25.
//  Copyright (c) 2013年 liukun. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef	__IMAGE
#define __IMAGE( __name )	[UIImage getImageFromBundle:__name]


@interface UIImage (SNAdditions)

//add by Gang Ning
//get Image from Bundle
+ (UIImage *)getImageFromBundle:(NSString *)imageName;

+ (UIImage *)noCachegetImageFromBundle:(NSString *)imageName;

+ (UIImage *)stregetImageFromBundle:(NSString *)imageName;
+ (UIImage *)stregetImageFromBundle:(NSString *)imageName capX:(CGFloat)x capY:(CGFloat)y;
+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)stretched;
- (UIImage *)grayscale;
- (UIImage *)roundCornerImageWithRadius:(CGFloat)cornerRadius;


- (UIColor *)patternColor;


- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

@end
