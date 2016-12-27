//
//  PNRGoodsInfo.h
//  Pods
//
//  Created by will on 2016/12/9.
//
//

#import <Foundation/Foundation.h>

@interface PNRGoodsInfo : NSObject

@property(nonatomic,strong)NSString *goodsNo;       //商品编号
@property(nonatomic,strong)NSString *goodsName;     //商品名称
@property(nonatomic,strong)NSString *goodsNumber;   //商品数量
@property(nonatomic,strong)NSString *goodsPrice;    //商品单价
@property(nonatomic,strong)NSString *goodsBody;     //商品详情

@end
