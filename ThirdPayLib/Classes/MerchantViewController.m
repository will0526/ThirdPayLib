//
//  MerchantViewController.m
//  Pods
//
//  Created by will on 2016/11/1.
//
//
#import "ShowPayTypeViewController.h"
#import "BookOrderRequest.h"
#import "CommonService.h"

#import "QueryOrderRequest.h"

#import "QRCodeViewController.h"
#import "UIColor+SNAdditions.h"
#import "UIImage+SNAdditions.h"
#import "NSData+Base64.h"
#import "NSData+Utils.h"
#import "NSString+Additions.h"
#import "Constant.h"
#import "EnvironmentConfig.h"
#import "GlobleConstant.h"
#import "GlobleDefine.h"
#import "ShowPayTypeViewController.h"
#import "MerchantViewController.h"

@interface MerchantViewController  ()<UITextFieldDelegate,ThirdPayDelegate>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UITableView *backtableView;
@property(nonatomic, strong)UIView *headView;
@property(nonatomic, strong)UIButton *payButton;
@property(nonatomic, strong)NSString *orderNO;
@property(nonatomic, strong)UITextField *amountTextField;

@end

@implementation MerchantViewController
{
    
    NSArray * dataSource;
    NSArray * payTypeIcon;
    int selectedIndex;
    
    UILabel *goodsNameLabel;
    UILabel *payAmountLabel;
    UILabel *orderNOLabel;
    UILabel *memoLabel;
    UILabel *redPocketLabel;
    UILabel *pointLabel;
    PayStatus payStatus;
    NSString *OrderString;
    NSMutableDictionary *_resultDict;
    BOOL isCancel;
    
    UIAlertView *cancelAlert;
    UIAlertView *payingAlert;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = HEX_RGB(0xeeeeee);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(Back)];
    
    dataSource = @[@"微信支付",@"支付宝支付",@"百度钱包支付",@"Apple Pay",@"翼支付"];
    payTypeIcon = @[@"weixinIcon",@"alipayIcon",@"baiIcon",@"applepayIcon",@"YipayIcon"];
    selectedIndex = 0;
    //    self.payType = PayType_Alipay;
    _resultDict = [[NSMutableDictionary alloc]init];
    
    
    
    self.tableView.tableHeaderView = self.headView;
    self.backtableView.tableHeaderView = self.tableView;
    
    [self.view addSubview:self.backtableView];
    [self.view addSubview:self.payButton];
    
}

-(void)bookOrder{
    
    BOOL background = YES;
    
    
    
    
    NSDate *datenow = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    NSString *merchantOrderNO = [dateFormatter stringFromDate:datenow];
    
    
    
    float amout = [_amountTextField.text floatValue];
    amout = amout*100;
    NSString * intAmout = [NSString stringWithFormat:@"%d", (int)amout];
    NSMutableDictionary *tradeInfo = [[NSMutableDictionary alloc]init];
    
    [tradeInfo setValue:@"000001" forKey:@"memberNo"];
    [tradeInfo setValue:@"000000000000001" forKey:@"merchantNO"];
    [tradeInfo setValue:merchantOrderNO forKey:@"merchantOrderNO"];
    [tradeInfo setValue:@"望湘园餐饮费用" forKey:@"orderTitle"];
    [tradeInfo setValue:@"望湘园餐饮费用测试" forKey:@"orderDetail"];
    [tradeInfo setValue:intAmout forKey:@"totalAmount"];
    [tradeInfo setValue:intAmout forKey:@"payAmount"];
    [tradeInfo setValue:@"0" forKey:@"redPocket"];
    [tradeInfo setValue:@"0" forKey:@"point"];
    [tradeInfo setValue:@"扫码付" forKey:@"memo"];
    [tradeInfo setValue:@"http//:www.baidu.com" forKey:@"notifyURL"];
    [tradeInfo setValue:@"ThirdPayDemo" forKey:@"appSchemeStr"];
    
    
    
    [ThirdPay payWithTradeInfo:tradeInfo ViewController:self Delegate:self PayType:self.payType];
    
    
    
    
    
}

-(void)gotoPay{
    
    
    payingAlert = [[UIAlertView alloc]initWithTitle:@"支付中。。。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
}

-(void)Back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

-(UIButton *)payButton{
    
    if (_payButton == nil) {
        _payButton = [[UIButton alloc]initWithFrame:CGRectMake(30, self.view.height - 60, self.view.width - 60, 50)];
        NSString *money = [self moneyTran:self.payAmount ownType:1];
        [_payButton setTitle:[NSString stringWithFormat:@"确认支付￥0元"] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xff9e05)] forState:UIControlStateNormal];
        [_payButton setBackgroundImage:[UIImage imageWithColor:HEX_RGB(0xff9e05)] forState:UIControlStateHighlighted];
        [_payButton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        
        _payButton.layer.cornerRadius = 3.5;
        _payButton.clipsToBounds = YES;
        _payButton.enabled = NO;
        [_payButton addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _payButton;
}

-(void)payButtonPressed:(UIButton *)button{
    
    switch (selectedIndex) {
        case 0:
        {
            self.payType = PayType_WeichatPay;
            
        }
            break;
        case 1:
        {
            self.payType = PayType_Alipay;
        }
            break;
        case 2:
        {
            self.payType = PayType_BaiduPay;
        }
            break;
        case 3:
        {
            self.payType = PayType_ApplePay;
        }
            break;
        case 4:
        {
            self.payType = PayType_YiPay;
        }
            break;
            
        default:
            break;
    }
    
    [self bookOrder];
}

-(UIView *)headViews{
    self.title = @"订单确认";
    if (_headView == nil) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
        _headView.backgroundColor = HEX_RGB(0xf9f9fc);
        
        goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, self.view.width - 60, 40)];
        goodsNameLabel.textAlignment = NSTextAlignmentLeft;
        goodsNameLabel.font = [UIFont systemFontOfSize:16];
        goodsNameLabel.text = [NSString stringWithFormat:@"订单详情：测试商品"];
        [_headView addSubview:goodsNameLabel];
        
        payAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(goodsNameLabel.left, goodsNameLabel.bottom, goodsNameLabel.width, goodsNameLabel.height)];
        payAmountLabel.textAlignment = NSTextAlignmentLeft;
        payAmountLabel.font = [UIFont systemFontOfSize:16];
        NSString *money = [self moneyTran:self.payAmount ownType:1];
        payAmountLabel.text = [NSString stringWithFormat:@"订单金额：￥200元"];
        [_headView addSubview:payAmountLabel];
        
        
        orderNOLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, payAmountLabel.bottom, payAmountLabel.width, goodsNameLabel.height)];
        orderNOLabel.textAlignment = NSTextAlignmentLeft;
        orderNOLabel.font = [UIFont systemFontOfSize:16];
        orderNOLabel.text = [NSString stringWithFormat:@"订单编号：161101160919"];
        [_headView addSubview:orderNOLabel];
        
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(payAmountLabel.left, orderNOLabel.bottom+5, self.view.width - 60, 68)];
        image.image = [UIImage getImageFromBundle:@"youui"];
        image.contentMode = UIViewContentModeCenter;
        
        [_headView addSubview:image];
        
        UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(payAmountLabel.left, image.bottom+20, self.view.width - 60, 68)];
        image1.image = [UIImage getImageFromBundle:@"youui"];
        image1.contentMode = UIViewContentModeCenter;
        
        [_headView addSubview:image1];
        
        _headView.frame = CGRectMake(0, 0, self.view.width, image1.bottom+20);
        
        
    }
    return _headView;
    
}



-(UIView *)headView{
    self.title = @"望湘园（万象城店）";
    if (_headView == nil) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
        _headView.backgroundColor = HEX_RGB(0xf9f9fc);
        
        goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, self.view.width - 60, 40)];
        goodsNameLabel.textAlignment = NSTextAlignmentLeft;
        goodsNameLabel.font = [UIFont systemFontOfSize:16];
        goodsNameLabel.text = [NSString stringWithFormat:@"商户名称：%@",@"望湘园"];
       // [_headView addSubview:goodsNameLabel];
        
        payAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 100, 40)];
        payAmountLabel.textAlignment = NSTextAlignmentLeft;
        payAmountLabel.font = [UIFont systemFontOfSize:18];
        NSString *money = [self moneyTran:self.payAmount ownType:1];
        payAmountLabel.text = [NSString stringWithFormat:@"消费金额："];
        [_headView addSubview:payAmountLabel];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(payAmountLabel.right, 30, self.view.width - payAmountLabel.right- 30, 40)];
        textField.placeholder = @"询问服务员后输入";
        textField.returnKeyType = UIReturnKeyDone;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        lab.text = @"元";
        lab.textAlignment = NSTextAlignmentLeft;
        textField.rightView = lab;
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        _amountTextField = textField;
        _amountTextField.delegate = self;
        [_headView addSubview:_amountTextField];
        
        orderNOLabel = [[UILabel alloc]initWithFrame:CGRectMake(payAmountLabel.left, payAmountLabel.bottom, self.view.width-payAmountLabel.left- 30,20)];
        orderNOLabel.textAlignment = NSTextAlignmentRight;
        orderNOLabel.font = [UIFont systemFontOfSize:13];
        orderNOLabel.textColor = [UIColor lightGrayColor];
        orderNOLabel.text = [NSString stringWithFormat:@"(输入不参与优惠金额)"];
        [_headView addSubview:orderNOLabel];
            
        _headView.frame = CGRectMake(0, 0, self.view.width, orderNOLabel.bottom+10);
        
        
    }
    return _headView;
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{

    NSString *str = textField.text;
    if (!IsStrEmpty(str)) {
        _payButton.enabled = YES;
        [_payButton setTitle:[NSString stringWithFormat:@"确认支付￥%@元",str] forState:UIControlStateNormal];
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return  YES;
}



-(UITableView *)backtableView{
    if (_backtableView == nil) {
        self.backtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.height) style:UITableViewStylePlain];
        
        self.backtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _backtableView;
}



#pragma mark tableView start

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.height) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString  *identify = @"payTypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 16, 28, 28)];
    iconView.image = [UIImage getImageFromBundle:[NSString stringWithFormat:@"%@",payTypeIcon[indexPath.row]]];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    [cell addSubview:iconView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconView.right + 20, 15, self.view.width -120, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = dataSource[indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [cell addSubview:titleLabel];
    
    if (indexPath.row == selectedIndex ) {
        UIImageView *selectView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
        selectView.image = [UIImage getImageFromBundle:@"checked"];
        cell.accessoryView = selectView;
    }else{
        cell.accessoryView = nil;
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59, self.view.frame.size.width, 1)];
    line.backgroundColor = HEX_RGB(0xe4e4e4);
    [cell addSubview:line];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    
    [_amountTextField resignFirstResponder];
    [tableView reloadData];
}

#pragma mark tableView end


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



-(void)onPayResult:(PayStatus)payStatus withInfo:(NSDictionary *)dict{
    NSLog(@"%u.......%@",payStatus,dict);
    NSString *title = @"";
    NSString *content = [self combieTitle:dict];
    NSLog(@"content%@",content);
    switch (payStatus) {
        case PayStatus_PAYSUCCESS:
        {
            title = @"支付成功";
            
        }
            break;
        case PayStatus_PAYFAIL:
        {
            title = @"交易失败";
            
        }
            break;
        case PayStatus_PAYTIMEOUT:
        {
            title = @"交易超时";
            
        }
            break;
        case PayStatus_PAYCANCEL:
        {
            title = @"交易取消";
            
        }
            break;
            
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}


-(NSString *)combieTitle:(NSDictionary *)dict{
    NSArray *keys = [dict allKeys];
    NSString *key;
    NSString *retString;
    for (key in keys)
    {
        if (retString == nil) {
            
            retString = [NSString stringWithFormat:@"\"%@\":\"%@\"",key,[dict valueForKey:key]];
            [retString cStringUsingEncoding:NSUnicodeStringEncoding];
        }else{
            NSString *val = [NSString stringWithFormat:@",\n\"%@\":\"%@\"",key,[dict valueForKey:key]];
            
            retString = [retString stringByAppendingString:val];
        }
    }
    
    if (!retString) {
        retString = @"";
    }
    retString = [self replaceUnicode:retString];
    
    
    return retString;
    
}
- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
