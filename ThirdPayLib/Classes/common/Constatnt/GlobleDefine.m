//
//  GbobleDefine.m
//  IOSTempleteProject
//
//  Created by will on 14-1-24.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "GlobleDefine.h"

UMS_EXTERN NSString* EncodeObjectFromDic(NSDictionary *dic, NSString *key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    NSString *value = @"";
    if (NotNilAndNull(temp))   {
        if ([temp isKindOfClass:[NSString class]]) {
            value = temp;
        }else if([temp isKindOfClass:[NSNumber class]]){
            value = [temp stringValue];
        }
        return value;
    }
    return nil;
}

UMS_EXTERN NSString* EncodeDefaultStrFromDic(NSDictionary *dic, NSString *key,NSString * defaultStr)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    NSString *value = defaultStr;
    if (NotNilAndNull(temp))   {
        if ([temp isKindOfClass:[NSString class]]) {
            value = temp;
        }else if([temp isKindOfClass:[NSNumber class]]){
            value = [temp stringValue];
        }
        
        return value;
    }
    return value;
}

UMS_EXTERN id safeObjectAtIndex(NSArray *arr, NSInteger index)
{
    if (IsArrEmpty(arr)) {
        UMSAssert(!IsArrEmpty(arr));
        return nil;
    }
    
    if ([arr count]-1<index) {
        UMSAssert([arr count]-1<index);
        return nil;
    }
    
    return [arr objectAtIndex:index];
}



UMS_EXTERN NSString* EncodeStringFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSString class]])
    {
        return temp;
    }
    else if ([temp isKindOfClass:[NSNumber class]])
    {
        return [temp stringValue];
    }
    return nil;
}

UMS_EXTERN NSNumber* EncodeNumberFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithDouble:[temp doubleValue]];
    }
    else if ([temp isKindOfClass:[NSNumber class]])
    {
        return temp;
    }
    return nil;
}

UMS_EXTERN NSDictionary *EncodeDicFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSDictionary class]])
    {
        return temp;
    }
    return nil;
}

UMS_EXTERN NSArray      *EncodeArrayFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSArray class]])
    {
        return temp;
    }
    return nil;
}

UMS_EXTERN NSArray      *EncodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic))
{
    NSArray *tempList = EncodeArrayFromDic(dic, key);
    if ([tempList count])
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[tempList count]];
        for (NSDictionary *item in tempList)
        {
            id dto = parseBlock(item);
            if (dto) {
                [array addObject:dto];
            }
        }
        return array;
    }
    return nil;
}

UMS_EXTERN void EncodeUnEmptyStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key)
{
    if (IsNilOrNull(dic))
    {
        return;
    }
    
    if (IsStrEmpty(object))
    {
        return;
    }
    
    if (IsStrEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}

UMS_EXTERN void EncodeUnEmptyObjctToArray(NSMutableArray *arr,id object)
{
    if (IsNilOrNull(arr))
    {
        return;
    }
    
    if (IsNilOrNull(object))
    {
        return;
    }
    
    [arr addObject:object];
}

UMS_EXTERN void EncodeUnEmptyDicObjctToDic(NSMutableDictionary *dic,NSDictionary *object, NSString *key)
{
    if (IsNilOrNull(dic))
    {
        return;
    }
    
    if (IsNilOrNull(object))
    {
        return;
    }
    
    if (IsStrEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}

UMS_EXTERN void EncodeUnEmptyArrToDic(NSMutableDictionary *dic,NSArray *object, NSString *key)
{
    if (IsNilOrNull(dic))
    {
        return;
    }
    
    if (IsNilOrNull(object))
    {
        return;
    }
    
    if (IsStrEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}



UMS_EXTERN void EncodeDefaultStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key,NSString * defaultStr)
{
    if (IsNilOrNull(dic))
    {
        return;
    }
    
    if (IsStrEmpty(object))
    {
        object = defaultStr;
    }
    
    if (IsStrEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}
