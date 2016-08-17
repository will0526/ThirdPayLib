//
//  UMSSecurityUtils.h
//  UMSOpenPlatformCore
//
//  Created by Ning Gang on 14-4-15.
//  Copyright (c) 2014年 ChinaUMS. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LJSecurityUtils : NSObject

+(NSString *) uuid;

//PADDING 默认填充0
+(NSData *)Pad_Zeor:(NSData *)data;

+ (NSString *) md5:(NSString *)str;
//MD5
+(NSData*)MD5:(NSData*)data;

//SHA1
+(NSData*)SHA1:(NSData*)data;

+(NSString *)RSAEncrypt:(NSString *)text publicKey:(NSString *)key;

//+(NSString *)RSADecrypt:(NSString *)text privateKey:(NSString *)key;
//RSA
+(NSData*)RSAEncrypt:(NSData*)plaintTextData KeyN:(NSString *)keyn KeyE:(NSString *) keye;

//TDES
+(NSData *)TDESEncrypt:(NSData *)plaintextData withKey:(NSData *)keyData;

+(NSData *)TDESDecrypt:(NSData *)decryptData withKey:(NSData *)keyData;

//SIGN&VERIFY

+(NSString *)RSASign:(NSString *)pemFilePath Content:(NSData *)content;

+(BOOL)RSAVerify:(NSData *)content Sign:(NSData *)sign KeyN:(NSString *)keyn KeyE:(NSString *)keye;

//Mac 9.9
+(NSData *)Mac9_9:(NSData *)srcData withKey:(NSData *)key;

+(NSString *)getMACAddress;

+ (NSString *) getIPAddress;



//资源包
//Md5
+ (NSString *)calDataMd5:(NSData *)data;
//SHA-1
+ (NSString *)calDataSHA1:(NSData *)data;
+ (NSString *)calFileSHA1:(NSString*)path;

@end
