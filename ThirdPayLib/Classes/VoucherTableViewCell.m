//
//  VoucherTableViewCell.m
//  Pods
//
//  Created by will on 2017/2/8.
//
//

#import "VoucherTableViewCell.h"
#import "OHAttributedLabel.h"

#import "NSAttributedString+Attributes.h"

@implementation VoucherTableViewCell
{
    UIImageView *_backView;
    UILabel *voucherName;
    UILabel *voucherDetail;
    UILabel *voucherID;
    UILabel *validate;
    OHAttributedLabel *limitAmount;
    OHAttributedLabel *ruleLabel;
    UILabel *reuseLabel;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self loadView];
        
    }
    return self;
}

-(void)loadView{

    _backView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, self.width - 30, 100)];
    voucherName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
//    voucherName.text = @"优惠券名称测试";
    voucherName.numberOfLines = 1;
    voucherName.font = [UIFont systemFontOfSize:14];
    [_backView addSubview:voucherName];
    
    
    voucherDetail = [[UILabel alloc]initWithFrame:CGRectMake(0, voucherName.bottom+5, self.width*2/3-20, 40)];
    voucherDetail.text = @"优惠券详情测试优惠券详情测试优惠券详情测试";
    voucherDetail.numberOfLines = 0;
    voucherDetail.lineBreakMode = NSLineBreakByWordWrapping;
    voucherDetail.font = [UIFont systemFontOfSize:12];
    [_backView addSubview:voucherDetail];
    
    voucherID = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 200, 0, 150, 20)];
//    voucherID.text = @"ID:65363366363621";
    voucherID.textAlignment = NSTextAlignmentRight;
    voucherID.font = [UIFont systemFontOfSize:12];
    [_backView addSubview:voucherID];
    
    limitAmount = [[OHAttributedLabel alloc]init ];
    limitAmount.frame = CGRectMake(self.width - 150, voucherID.bottom+5, 100, 15);
    limitAmount.centerVertically = YES;
    limitAmount.adjustsFontSizeToFitWidth = YES;
    
    [_backView addSubview:limitAmount];
    
    ruleLabel = [[OHAttributedLabel alloc]init ];
    ruleLabel.frame = CGRectMake(self.width - 150, limitAmount.bottom+5, 100, 20);
    ruleLabel.centerVertically = YES;
    ruleLabel.adjustsFontSizeToFitWidth = YES;
    [_backView addSubview:ruleLabel];
    
    reuseLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width - 150, ruleLabel.bottom+5, 100, 15)];
    reuseLabel.font = [UIFont systemFontOfSize:10];
    reuseLabel.textAlignment = NSTextAlignmentRight;
    [_backView addSubview:reuseLabel];
    
    validate = [[UILabel alloc]initWithFrame:CGRectMake(0, voucherDetail.bottom+5, 180, 15)];
//    validate.text = [NSString stringWithFormat:@"有效期:%@",@"20170102~20171231"];
    validate.font = [UIFont systemFontOfSize:12];
    validate.adjustsFontSizeToFitWidth = YES;
    validate.textColor = HEX_RGB(0xa9a9a9);
    [_backView addSubview:validate];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 99, self.width, 1)];
    line.backgroundColor = HEX_RGB(0xe4e4e4);
    [self addSubview:line];
    

    _backView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backView];
}

-(void)setCheckedIcon:(BOOL)selected{

    UIView *back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *selectView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 25, 25)];
    //selectView.contentMode = UIViewContentModeScaleAspectFit;
    selectView.image = [UIImage getImageFromBundle:@"checked"];
    //back.backgroundColor = [UIColor redColor];
    [back addSubview:selectView];
    if (selected) {
        
        self.accessoryView = back;
    }else{
        self.accessoryView = nil;
    }
    
}



-(void)loadContent{
    if (self.voucher.superposeType) {
        reuseLabel.text = [NSString stringWithFormat:@"可叠加使用"];
    }else{
        reuseLabel.text = [NSString stringWithFormat:@"不可叠加使用"];
    }
    voucherName.text = self.voucher.voucherName;
    voucherDetail.text = [NSString stringWithFormat:@"%@,使用时间:%@-%@",self.voucher.voucherDescription,self.voucher.availableStartTime,self.voucher.availableEndTime];
    voucherID.text = [NSString stringWithFormat:@"ID:%@", self.voucher.voucherId];
    validate.text = [NSString stringWithFormat:@"有效期:%@~%@",self.voucher.startTime,self.voucher.expirationTime];
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:@"满"];
    [str1 setFont: [UIFont systemFontOfSize:10]];
    NSString *money = [self moneyTran:self.voucher.satisfyOrderAmount ownType:1];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",money]];
    [str2 setFont: [UIFont boldSystemFontOfSize:10]];
    [str2 setTextColor:HEX_RGB(0xfc6a08)];
    
    [str1 appendAttributedString:str2];
    [str1 setTextAlignment:CTTextAlignmentFromUITextAlignment(NSTextAlignmentRight) lineBreakMode:CTLineBreakModeFromUILineBreakMode(NSLineBreakByCharWrapping)];
    [limitAmount setAttributedText:str1];
    
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc]init ];
    [str3 setFont: [UIFont systemFontOfSize:10]];
    NSMutableAttributedString *str4 = [[NSMutableAttributedString alloc]init];
    if ([self.voucher.voucherType isEqualToString:@"4"]) {
        str3 = [[NSMutableAttributedString alloc]initWithString:@"折扣"];
        int discount =  [self.voucher.discount floatValue]*100;
        str4 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d%%",discount]];
    }else if ([self.voucher.voucherType isEqualToString:@"2"]){
        str3 =[[NSMutableAttributedString alloc]initWithString: @"减"];
        NSString *money2 = [self moneyTran:self.voucher.voucherAmount ownType:1];
        str4 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",money2]];
    }
    
    
    [str4 setTextColor:HEX_RGB(0xfc6a08)];
    [str4 setFont: [UIFont systemFontOfSize:10]];
    [str3 appendAttributedString:str4];
    [str3 setTextAlignment:CTTextAlignmentFromUITextAlignment(NSTextAlignmentRight) lineBreakMode:CTLineBreakModeFromUILineBreakMode(NSLineBreakByCharWrapping)];
    [ruleLabel setAttributedText:str3];
    
    [self setCheckedIcon:self.voucher.selected];
    
}

-(NSString *)moneyTran:(NSString *)yM ownType:(int)type{
    
    if (!yM) return @"0";
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    
    
    if(type==0){
        
        if ([yM doubleValue]>DBL_MAX) {
            return @"";
        }
        
        nf.positiveFormat = @"0";
        double h=(double) ([yM doubleValue])*100;
        return  [nf stringFromNumber: [NSNumber numberWithDouble:h]];
    }
    else if(type==1){
        double h=(double) ([yM doubleValue])/100;
        nf.positiveFormat = @"0.00";
        return [nf stringFromNumber: [NSNumber numberWithDouble:h]];
    }else if (type == 2){
        double h=(double) ([yM doubleValue])/100;
        nf.positiveFormat = @"0";
        return [nf stringFromNumber: [NSNumber numberWithDouble:h]];
    }
    else return @"";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
