//
//  UMSSecurityUtils.m
//  UMSOpenPlatformCore
//
//  Created by Ning Gang on 14-4-15.
//  Copyright (c) 2014年 ChinaUMS. All rights reserved.
//

#import "LJSecurityUtils.h"
#import "CommonCrypto/CommonDigest.h"

#import "SystemInfo.h"
#import "NSData+Utils.h"
#import "md5.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#import "rsa.h"
#import "sha1.h"
#import "pk.h"
#import "entropy.h"
#import "ctr_drbg.h"
#import "des.h"
#import "config.h"

#import <sys/socket.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <netdb.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define BLOCK_SIZE 100
#define KEYE @"10001"

@implementation LJSecurityUtils

+(NSString *) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+(NSData *)Pad_Zeor:(NSData *)data
{
    if ([data length]%8 == 0) {
        return data;
    }
    else
    {
        unsigned char * paddingBuf = malloc(([data length]/8 + 1 )*8);
        memset(paddingBuf,0,([data length]/8 + 1 )*8);
        memcpy(paddingBuf, [data bytes], [data length]);
        NSData *paddingData = [NSData dataWithBytes:paddingBuf length:([data length]/8 + 1 )*8];
        free(paddingBuf);
        
        return paddingData;
    }
}
+(NSData*)MD5:(NSData*)data
{
    unsigned char output[16] = {0};
    md5((unsigned char*)[data bytes], [data length], output);
    return [NSData dataWithBytes:output length:16];
}

#import <CommonCrypto/CommonDigest.h>

+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSData*)SHA1:(NSData*)data
{
    unsigned char output[20] = {0};
    sha1([data bytes], [data length], output);
    return [NSData dataWithBytes:output length:20];
}

+(NSString *)RSAEncrypt:(NSString *)text publicKey:(NSString *)key{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData * data1 = [data subdataWithRange:NSMakeRange(29, 128)];
    NSString *modeStr = [NSString stringWithFormat:@"%@",data1];
    
    
    modeStr = [modeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    modeStr = [modeStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    modeStr = [modeStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    modeStr = [modeStr uppercaseString];
    
    NSString *rsaStr = [[self RSAEncrypt:[text dataUsingEncoding:NSUTF8StringEncoding] KeyN:modeStr KeyE:KEYE] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    rsaStr = [rsaStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSLog(@"%@",rsaStr);
    rsaStr = [rsaStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    NSLog(@"%@",rsaStr);
    rsaStr = [rsaStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",rsaStr);
    return rsaStr;
}

+(NSData*)RSAEncrypt:(NSData*)plaintTextData KeyN:(NSString *)keyn KeyE:(NSString *) keye
{
    NSMutableArray * blockPlaintArr = [plaintTextData spliteData2Array:BLOCK_SIZE];
    NSMutableArray * blockEncryArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (NSData * data in blockPlaintArr) {
        [blockEncryArr addObject:[self RSAEncryptWithBlockData:data KeyN:keyn KeyE:keye]];
    }
    
    return [NSData getIntegrationData:blockEncryArr];
    
}

+(NSData*)RSAEncryptWithBlockData:(NSData*)plaintTextData KeyN:(NSString *)keyn KeyE:(NSString *) keye
{
    int ret;
    rsa_context rsa;
    entropy_context entropy;
    ctr_drbg_context ctr_drbg;
    
    const char *pers = "rsa_encrypt";
    
    entropy_init( &entropy );
    if( ( ret = ctr_drbg_init( &ctr_drbg, entropy_func, &entropy,
                              (const unsigned char *) pers,
                              strlen( pers ) ) ) != 0 )
    {
        return nil;
    }
    
    rsa_init( &rsa, RSA_PKCS_V15, 0 );
    
    if( (ret = mpi_read_string(&rsa.N,16,(char *)[keyn cStringUsingEncoding:NSUTF8StringEncoding])) != 0 ||(ret = mpi_read_string( &rsa.E,16,(char *)[keye cStringUsingEncoding:NSUTF8StringEncoding])) != 0)
    {
        return nil;
    }
    
    rsa.len =  ( mpi_msb( &rsa.N ) + 7 ) >> 3;
    unsigned char buf[rsa.len];
    if( ( ret = rsa_pkcs1_encrypt( &rsa, ctr_drbg_random, &ctr_drbg,
                                  RSA_PUBLIC, [plaintTextData length],
                                  [plaintTextData bytes], buf ) ) != 0 )
    {
        return nil;
    }
    
    NSData *encryptData = [[NSData alloc]initWithBytes:buf length:rsa.len];
    
    entropy_free( &entropy );
    
    return encryptData;
}

+(NSData *)TDESEncrypt:(NSData *)plaintextData withKey:(NSData *)keyData
{
    if ([plaintextData length]%8 != 0) {
        return nil;
    }
    unsigned char * encryptBuf = malloc([plaintextData length]);
    lj_tdes_encrypt([plaintextData bytes], encryptBuf, (int)[plaintextData length], [keyData bytes]);
    
    NSData *encryptData = [NSData dataWithBytes:encryptBuf length:[plaintextData length]];
    free(encryptBuf);
    
    return encryptData;
    
}

void lj_tdes_encrypt(const unsigned char *data, unsigned char *result,
             int length, const unsigned char *key) {
	des3_context ctx;
	des3_set3key_enc(&ctx, (unsigned char *) key);
	while (length > 0) {
		des3_crypt_ecb(&ctx, (unsigned char *) data, result);
		data += 8;
		result += 8;
		length -= 8;
	}
}

+(NSData *)TDESDecrypt:(NSData *)decryptData withKey:(NSData *)keyData
{
    if ([decryptData length]%8 != 0) {
        return nil;
    }
    
    unsigned char * decryptBuf = malloc([decryptData length]);
    lj_tdes_decrypt([decryptData bytes], decryptBuf, (int)[decryptData length], [keyData bytes]);
    
    NSData *decryptBufData = [NSData dataWithBytes:decryptBuf length:[decryptData length]];
    free(decryptBuf);
    
    return decryptBufData;
}

void lj_tdes_decrypt(const unsigned char *data, unsigned char *result,
             int length, const unsigned char *key) {
	des3_context ctx;
	des3_set3key_dec(&ctx, (unsigned char *) key);
	while (length > 0) {
		des3_crypt_ecb(&ctx, (unsigned char *) data, result);
		data += 8;
		result += 8;
		length -= 8;
	}
}

+(NSString *)RSASign:(NSString *)pemFilePath Content:(NSData *)content
{
    int ret = 1;
    rsa_context *rsa;
    pk_context key;
    unsigned char hash[20];
    unsigned char buf[POLARSSL_MPI_MAX_SIZE];
    
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:pemFilePath ofType:@"pem"];

    pk_init( &key );
    ret = pk_parse_keyfile( &key, [keyPath UTF8String], NULL );
    
    rsa = pk_rsa( key );
    if( ret != 0 )
    {
        return nil;
    }
    
    if( ( ret = rsa_check_privkey( rsa ) ) != 0 )
    {
        return nil;
    }

    sha1([content bytes], [content length], hash);
    
    if( ( ret = rsa_pkcs1_sign( rsa, NULL, NULL, RSA_PRIVATE, POLARSSL_MD_SHA1,
                               20, hash, buf ) ) != 0 )
    {
        return nil;
    }
    
    pk_free( &key );
    return [[NSString alloc] initWithBytes:buf length:POLARSSL_MPI_MAX_SIZE encoding:NSUTF8StringEncoding];
}

+(BOOL)RSAVerify:(NSData *)content Sign:(NSData *)sign KeyN:(NSString *)keyn KeyE:(NSString *)keye
{
    
    int ret;
    unsigned char hash[20] = {0};
    sha1([content bytes], [content length], hash);
    
	rsa_context rsa;
	rsa_init(&rsa,RSA_PKCS_V15,0);
    
    if( (ret = mpi_read_string(&rsa.N,16,(char *)[keyn cStringUsingEncoding:NSUTF8StringEncoding])) != 0 ||(ret = mpi_read_string( &rsa.E,16,(char *)[keye cStringUsingEncoding:NSUTF8StringEncoding])) != 0)
    {
        return NO;
    }
    
    //    rsa.len = length;
    rsa.len =  ( mpi_msb( &rsa.N ) + 7 ) >> 3;

	if( rsa_check_pubkey(  &rsa ) != 0)
		return NO;
    
    if( ( ret = rsa_pkcs1_verify( &rsa, NULL, NULL, RSA_PUBLIC,
                                 POLARSSL_MD_SHA1, 20, hash, [sign bytes] ) ) != 0 )
    {
        return NO;
    }
	return YES;
    
}

//Mac 9.9
+(NSData *)Mac9_9:(NSData *)srcData withKey:(NSData *)key
{
    unsigned char mac[8];
    
    NSData * data = [self Pad_Zeor:srcData];
    lj_mac9_9([data bytes], (int)[data length], mac, [key bytes]);
    
    return [[NSData alloc] initWithBytes:mac length:8];
}

void lj_mac9_9(const unsigned char *data, int length,
         unsigned char *result, const unsigned char *key) {
	des_context ctx;
	des_setkey_enc(&ctx, (unsigned char *) key);
	unsigned char iv[8];
	memset(result, 0, 8);
	while (length > 0) {
		int i;
		for (i = 0; i < 8; i++) {
			result[i] ^= data[i];
		}
		memset(iv, 0, 8);
		des_crypt_cbc(&ctx, DES_ENCRYPT, 8, iv, result, result);
		data += 8;
		length -= 8;
	}
}

+(NSString *)getMACAddress{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
}

+ (NSString *) getIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

#pragma mark - MD5
//Md5
+ (NSString *)calDataMd5:(NSData *)data {
    unsigned char digest[CC_MD5_DIGEST_LENGTH]={0};
    CC_MD5([data bytes], (CC_LONG)[data length], digest);
    
    NSMutableString *s=[NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [s appendFormat:@"%02X",digest[i]];
    }
    return s;
}

//SHA-1
+ (NSString *)calDataSHA1:(NSData *)data
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH]={0};
    CC_SHA1([data bytes], (CC_LONG)[data length], digest);
    
    NSMutableString *s=[NSMutableString string];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [s appendFormat:@"%02X",digest[i]];
    }
    return s;
}

+ (NSString *)calFileSHA1:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle == nil ) {
        return nil;
    }
    CC_SHA1_CTX sha1;
    CC_SHA1_Init(&sha1);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 8192 ];
        CC_SHA1_Update(&sha1, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 )
            done = YES;
    }
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(digest, &sha1);
    
    NSMutableString* s=[NSMutableString string];
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [s appendFormat:@"%02X",digest[i]];
    }
    return s;
}


@end
