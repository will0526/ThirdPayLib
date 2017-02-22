//
//  VoucherTableViewCell.h
//  Pods
//
//  Created by will on 2017/2/8.
//
//

#import <UIKit/UIKit.h>
#import "VoucherData.h"

@interface VoucherTableViewCell : UITableViewCell

@property(nonatomic,strong)VoucherData *voucher;


-(void)loadContent;



-(void)setCheckedIcon:(BOOL)isChecked;

@end
