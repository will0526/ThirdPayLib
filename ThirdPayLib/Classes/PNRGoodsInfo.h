//
//  PNRGoodsInfo.h
//  Pods
//
//  Created by will on 2016/12/9.
//
//

#import <Foundation/Foundation.h>

@interface PNRGoodsInfo : NSObject
@property(nonatomic,strong)NSString *itemNo;        //货号
@property(nonatomic,strong)NSString *goodsNo;       //商品编号
@property(nonatomic,strong)NSString *goodsName;     //商品名称
@property(nonatomic,strong)NSString *goodsAmount;   //商品支付金额（以分为单位）

@end
