//
//  PNRViewController.m
//  ThirdPayLib
//
//  Created by 王英永 on 08/10/2016.
//  Copyright (c) 2016 王英永. All rights reserved.
//

#import "PNRViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <ThirdPayLib/ThirdPay.h>
#import <ThirdPayLib/PNROrderInfo.h>
#import <ThirdPayLib/PNROtherPayInfo.h>
#import <ThirdPayLib/PNRGoodsInfo.h>
#import <ThirdPayLib/PNRMemberInfo.h>

#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))
@interface PNRViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ThirdPayDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UITableView * backgroundTableview;

@property (nonatomic, strong)UIButton * bookOrder;
@property (nonatomic, strong)NSMutableDictionary *params;
@property (nonatomic,strong)PNROrderInfo *orderInfo;
@property (nonatomic,strong)PNRMemberInfo *memberInfo;

@property (nonatomic,strong)PNRGoodsInfo *goodsInfo1;

@property (nonatomic,strong)PNRGoodsInfo *goodsInfo2;

@property (nonatomic,strong)PNROtherPayInfo *otherPay1;

@property (nonatomic,strong)PNROtherPayInfo *otherPay2;
@end

@implementation PNRViewController
{
    NSArray *dataSource;
    NSArray *defaultSource;
    NSArray *pickerData;
    UIView *backView;
    UILabel *payTypeLabel;
    PayType paytype;
    UIPickerView *_pickerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试";
    
    NSDate *datenow = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    NSString *merchantOrder = [dateFormatter stringFromDate:datenow];
    
    self.orderInfo = [[PNROrderInfo alloc]init];
    self.memberInfo = [[PNRMemberInfo alloc]init];
    self.goodsInfo1 = [[PNRGoodsInfo alloc]init];
    self.goodsInfo2 = [[PNRGoodsInfo alloc]init];
    
    self.otherPay1 = [[PNROtherPayInfo alloc]init];
    self.otherPay2 = [[PNROtherPayInfo alloc]init];
    //测试数据
    switch (_viewType) {
        case 0:
        {
            dataSource = @[@"用户号",@"商户号",@"订单号"];
            defaultSource = @[@"8888888881121",@"000000000000001",@"20160923091858000551"];
        }
            break;
        case 1:
        {
            dataSource = @[@"用户号",@"商户号",@"商户订单号",@"订单标题",@"订单详情",@"订单金额(分)",@"实付金额(分)",@"商品号1",@"商品名称1",@"商品数量1",@"商品单价1",@"商品描述1",@"商品号2",@"商品名称2",@"商品数量2",@"商品单价2",@"商品描述2",@"支付方式1(积分)",@"支付方式ID",@"支付金额",@"(优惠券)",@"优惠券ID",@"优惠券金额",@"备注",@"通知地址"];
            defaultSource = @[@"8888888881121",@"000000000000001",merchantOrder,@"手机订单标题",@"苹果手机6s和iPhone7 正品行货",@"540000",@"1000",@"0000001",@"iPhone6s 灰色",@"1",@"1",@"灰色64G全网",@"0000002",@"iPhone7 灰色",@"1",@"1",@"灰色128G全网",@"",@"",@"1",@"2",@"771b984ee16f444bb97c2919a9de3693",@"1000",@"不支持货到付款",@"http://www.baidu.com"];
        }
            break;
        case 2:
        {
            dataSource = @[@"用户号",@"商户号",@"商户订单号",@"订单标题",@"订单详情",@"订单金额(分)",@"实付金额(分)",@"商品号1",@"商品名称1",@"商品数量1",@"商品单价1",@"商品描述1",@"商品号2",@"商品名称2",@"商品数量2",@"商品单价2",@"商品描述2",@"支付方式1(积分)",@"支付方式ID",@"支付金额",@"(优惠券)",@"优惠券ID",@"优惠券金额",@"备注",@"通知地址",@"支付方式"];
            defaultSource = @[@"8888888881121",@"000000000000001",merchantOrder,@"手机订单标题",@"苹果手机6s和iPhone7 正品行货",@"540000",@"1000",@"0000001",@"iPhone6s 灰色",@"1",@"1",@"灰色64G全网",@"0000002",@"iPhone7 灰色",@"1",@"1",@"灰色128G全网",@"",@"",@"1",@"2",@"771b984ee16f444bb97c2919a9de3693",@"1000",@"不支持货到付款",@"http://www.baidu.com"];
            
            
            pickerData = @[@"支付宝",@"微信",@"翼支付",@"Apple Pay",@"百度钱包"];
            _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260)];
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            _pickerView.showsSelectionIndicator = YES;
//            _pickerView.hidden = YES;
            _pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
            _pickerView.backgroundColor = [UIColor lightGrayColor];
            
        }
            break;
        case 5:{
            dataSource = @[@"用户号",@"商户号",@"用户类型",@"商户订单金额"];
            defaultSource = @[@"8888888881121",@"000000000000001",@"1",@"10"];
            
            
        }
            break;
        case 6:{
            dataSource = @[@"用户号",@"商户号",@"用户类型"];
            defaultSource = @[@"8888888881121",@"000000000000001",@"1"];
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    self.params = [[NSMutableDictionary alloc]init];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableView.frame.origin.y+10 +40+10)];
    [backView addSubview:self.tableView];
    [backView addSubview:self.bookOrder];
    
    
    backView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.tableView.frame.size.height +40 +20);
    
    [self.bookOrder addTarget:self action:@selector(bookOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: self.backgroundTableview];
    self.backgroundTableview.tableHeaderView = backView;
    
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDown)];
    [self.view addGestureRecognizer:gesture];
    [self.view addSubview:_pickerView];
    
    
}

-(void)keyboardDown{
    [self.view endEditing:YES];
    
    //    [self.view resignFirstResponder];
    
}

#pragma mark textfieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag>4) {
        [self animateTextField: textField up: YES];
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag>4) {
        [self animateTextField: textField up: NO];
    }
    
    return  YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
    /*
     @param accountNo         用户号
     *  @param merchantNo       商户号
     *  @param merchantOrderNo  商户订单号
     *  @param orderTitle       订单标题
     *  @param orderDetail      订单详情
     *  @param memo             备注
     *  @param totalAmount      订单总金额（分）
     *  @param payAmount        待支付金额（分）
     *  @param notifyURL        后台通知地址
     
     */
    
    if(_viewType == 5 || _viewType == 6){
        
        switch (textField.tag) {
            case 0:
            {
                self.memberInfo.accountNo = textField.text;
                
            }
                break;
            case 1:
            {
                self.memberInfo.merchantNo = textField.text;
            }
                break;
            case 2:
            {
                self.memberInfo.accountType = textField.text;
            }
                break;
            case 3:
            {
                self.memberInfo.orderAmount = textField.text;
            }
                break;
            default:{
            }
                break;
        }
        
        return;
    }
    
    
    
    switch (textField.tag) {
        case 0:
        {
            self.orderInfo.accountNo = textField.text;
            
        }
            break;
        case 1:
        {
            self.orderInfo.merchantNo = textField.text;
        }
            break;
        case 2:
        {
            switch (_viewType) {
                case 0:
                {
                    self.orderInfo.ippOrderNo = textField.text;
                    
                }
                    break;
                case 1:
                {
                    self.orderInfo.merchantOrderNo = textField.text;
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case 3:
        {
            self.orderInfo.orderSubject = textField.text;
            
        }
            break;
        case 4:
        {
            self.orderInfo.orderDescription = textField.text;
            
        }
            break;
        case 5:
        {
            self.orderInfo.totalAmount = textField.text;
            
        }
            break;
        case 6:
        {
            self.orderInfo.payAmount = textField.text;
            
        }
            break;
        case 7:
        {
            self.goodsInfo1.goodsNo = textField.text;
            
        }
            break;
        case 8:
        {
            self.goodsInfo1.goodsName = textField.text;
         
        }
            break;
        case 9:
        {
            self.goodsInfo1.goodsNumber = textField.text;
            
        }
            break;
        case 10:
        {
            self.goodsInfo1.goodsPrice = textField.text;
            
        }
            break;
        case 11:
        {
            self.goodsInfo1.goodsBody = textField.text;
            
        }
            break;
        case 12:
        {
            self.goodsInfo2.goodsNo = textField.text;
            
            
        }
            break;
        case 13:
        {
            self.goodsInfo2.goodsName = textField.text;
            
        }
            break;
        case 14:
        {
            self.goodsInfo2.goodsNumber = textField.text;
        }
            break;
        case 15:
        {
            self.goodsInfo2.goodsPrice = textField.text;
         
        }
            break;
        case 16:
        {
            self.goodsInfo2.goodsBody = textField.text;
            
        }
            break;
        case 17:
        {
            self.otherPay1.voucherType = textField.text;
            
        }
            break;
        case 18:
        {
            self.otherPay1.voucherId = textField.text;
            
        }
            break;
        case 19:
        {
            self.otherPay1.voucherPayAmount = textField.text;
            
        }
            break;
        case 20:
        {
            self.otherPay2.voucherType = textField.text;
            
        }
            break;
        case 21:
        {
            self.otherPay2.voucherId = textField.text;
            
        }
            break;
        case 22:
        {
            self.otherPay2.voucherPayAmount = textField.text;
            
        }
            break;
        case 23:
        {
            self.orderInfo.memo = textField.text;
            
        }
            break;
        case 24:
        {
            self.orderInfo.notifyURL = textField.text;
            
        }
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return  YES;
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 150; // tweak as needed
    //    if (isCashier) {
    //        movementDistance = 130;
    //    }
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
    
}


-(UIButton *)bookOrder{
    if (_bookOrder == nil) {
        _bookOrder = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3, self.tableView.frame.size.height+self.tableView.frame.origin.y+10, self.view.frame.size.width/3, 40)];
        switch (_viewType) {
            case 0:
            {
                [_bookOrder setTitle:@"查询" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [_bookOrder setTitle:@"下单" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [_bookOrder setTitle:@"立即支付" forState:UIControlStateNormal];
            }
                break;
            case 5:{
                [_bookOrder setTitle:@"订单权益查询" forState:UIControlStateNormal];
            }
                break;
            case 6:{
                [_bookOrder setTitle:@"所有权益查询" forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        
        [_bookOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_bookOrder setBackgroundColor:[UIColor orangeColor]];
        
        _bookOrder.clipsToBounds = YES;
        _bookOrder.layer.cornerRadius = 20;
        
    }
    
    return _bookOrder;
    
    
}

-(void)bookOrder:(UIButton *)button{
    [self.view endEditing:YES];
    self.orderInfo.appSchemeStr = @"ThirdPayDemo";
    self.orderInfo.appVer = @"1.0";
    NSMutableArray *tempGoods = [[NSMutableArray alloc]init];
    

    
    [tempGoods addObject:self.goodsInfo1];
    [tempGoods addObject:self.goodsInfo2];
    self.orderInfo.goodsInfo = tempGoods;
    
    NSMutableArray *tempPay = [[NSMutableArray alloc]init];
    if (!IsStrEmpty(self.otherPay1.voucherType)) {
        [tempPay addObject:self.otherPay1];
    }
    if (!IsStrEmpty(self.otherPay2.voucherType)) {
        [tempPay addObject:self.otherPay2];
    }
    
    
    self.orderInfo.otherPayInfo = tempPay;
    
    
    switch (_viewType) {
        case 0:
        {
           
            [ThirdPay queryOrderInfo:self.orderInfo ViewController:self Delegate:self];
        }
            break;
        case 1:
        {
            
            [ThirdPay showPayTypeWithTradeInfo:self.orderInfo ViewController:self Delegate:self];
        }
            break;
        case 2:
        {
            [ThirdPay payWithTradeInfo:self.orderInfo ViewController:self Delegate:self];
            
        }
            break;
        case 5:{
            [ThirdPay queryMemberInfoForOrder:self.memberInfo ViewController:self Delegate:self];
        }
            break;
        case 6:{
            [ThirdPay queryMemberInfo:self.memberInfo ViewController:self Delegate:self];
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark tableView start

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50*dataSource.count) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UITableView *)backgroundTableview {
    if (_backgroundTableview == nil) {
        _backgroundTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _backgroundTableview.backgroundColor = [UIColor lightGrayColor];
    }
    return _backgroundTableview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString static *identify = @"datasoure";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (!cell) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 50, 40)];
    textLabel.text = dataSource[indexPath.row];
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.adjustsFontSizeToFitWidth = YES;
    [cell addSubview:textLabel];
    
    if (_viewType == 2 && indexPath.row == 25 ) {
        NSLog(@"%ld",(long)indexPath.row);
        NSLog(@"text.......%@",dataSource[indexPath.row]);
        
        
        payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 250, 40)];
        payTypeLabel.text = @"支付宝";
        paytype = PayType_Alipay;
        payTypeLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:payTypeLabel];
        UIButton *paytypeSelect = [[UIButton alloc]initWithFrame:CGRectMake(110, 5, 250, 40)];
        [paytypeSelect setBackgroundColor:[UIColor clearColor]];
        [paytypeSelect addTarget:self action:@selector(pickerViewShow) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:paytypeSelect];
       
        //self.orderInfo.orderSubject = textField.text;
        //[self.params setValue:@"http\\:www.baidu.com" forKey:@"notifyURL"];
    }else{
        NSLog(@"%ld",(long)indexPath.row);
        NSLog(@"text.......%@",dataSource[indexPath.row]);
        NSLog(@"text2.......%@",defaultSource[indexPath.row]);
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(55, 5, self.view.frame.size.width - 60, 40)];
        textField.placeholder = dataSource[indexPath.row];
        
        textField.text = defaultSource[indexPath.row];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
        textField.tag = indexPath.row;
        textField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test"]];
        textField.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:textField];
        if(_viewType == 5 || _viewType == 6){
            switch (textField.tag) {
                case 0:
                {
                    self.memberInfo.accountNo = textField.text;
                    
                }
                    break;
                case 1:
                {
                    self.memberInfo.merchantNo = textField.text;
                }
                    break;
                case 2:
                {
                    self.memberInfo.accountType = textField.text;
                }
                    break;
                case 3:
                {
                    self.memberInfo.orderAmount = textField.text;
                }
                    break;
                default:{
                }
                    break;
            }
        }else{
            switch (textField.tag) {
                case 0:
                {
                    self.orderInfo.accountNo = textField.text;
                    
                }
                    break;
                case 1:
                {
                    self.orderInfo.merchantNo = textField.text;
                    
                }
                    break;
                case 2:
                {
                    switch (_viewType) {
                        case 0:
                        {
                            self.orderInfo.ippOrderNo = textField.text;
                            
                        }
                            break;
                        case 1:
                        case 2:
                        {
                            self.orderInfo.merchantOrderNo = textField.text;
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                case 3:
                {
                    self.orderInfo.orderSubject = textField.text;
                    
                }
                    break;
                case 4:
                {
                    self.orderInfo.orderDescription = textField.text;
                    
                }
                    break;
                case 5:
                {
                    self.orderInfo.totalAmount = textField.text;
                    
                }
                    break;
                case 6:
                {
                    self.orderInfo.payAmount = textField.text;
                    
                }
                    break;
                case 7:
                {
                    self.goodsInfo1.goodsNo = textField.text;
                    
                }
                    break;
                case 8:
                {
                    self.goodsInfo1.goodsName = textField.text;
                    
                }
                    break;
                case 9:
                {
                    self.goodsInfo1.goodsNumber = textField.text;
                    
                }
                    break;
                case 10:
                {
                    self.goodsInfo1.goodsPrice = textField.text;
                    
                }
                    break;
                case 11:
                {
                    self.goodsInfo1.goodsBody = textField.text;
                    
                }
                    break;
                case 12:
                {
                    self.goodsInfo2.goodsNo = textField.text;
                    
                    
                }
                    break;
                case 13:
                {
                    self.goodsInfo2.goodsName = textField.text;
                    
                }
                    break;
                case 14:
                {
                    self.goodsInfo2.goodsNumber = textField.text;
                }
                    break;
                case 15:
                {
                    self.goodsInfo2.goodsPrice = textField.text;
                    
                }
                    break;
                case 16:
                {
                    self.goodsInfo2.goodsBody = textField.text;
                    
                }
                    break;
                case 17:
                {
                    self.otherPay1.voucherType = textField.text;
                    
                }
                    break;
                case 18:
                {
                    self.otherPay1.voucherId = textField.text;
                    
                }
                    break;
                case 19:
                {
                    self.otherPay1.voucherPayAmount = textField.text;
                    
                }
                    break;
                case 20:
                {
                    self.otherPay2.voucherType = textField.text;
                    
                }
                    break;
                case 21:
                {
                    self.otherPay2.voucherId = textField.text;
                    
                }
                    break;
                case 22:
                {
                    self.otherPay2.voucherPayAmount = textField.text;
                    
                }
                    break;
                case 23:
                {
                    self.orderInfo.memo = textField.text;
                    
                }
                    break;
                case 24:
                {
                    self.orderInfo.notifyURL = textField.text;
                    
                }
                    break;
                default:
                    break;
            }
        }
            
            
    }
        
    
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [cell addSubview:line];
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


#pragma mark tableView end

#pragma mark pickerView start

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerData count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerData[row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    payTypeLabel.text = pickerData[row];
    switch (row) {
        case 0:
        {
            paytype = PayType_Alipay;
        }
            
            break;
        case 1:
        {
            paytype = PayType_WeichatPay;
        }
            
            break;
        case 2:
        {
            paytype = PayType_YiPay;
        }
            
            break;
        case 3:
        {
            paytype = PayType_ApplePay;
        }
            
            break;
        case 4:
        {
            paytype = PayType_BaiduPay;
        }
            
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 160);
    }];
    
}

-(void)pickerViewShow{
//    _pickerView.hidden = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.frame = CGRectMake(0, self.view.frame.size.height-160, self.view.frame.size.width, 160);
    }];
}




#pragma mark pickerView end




#pragma mark thirdPayDelegate


-(void)onQueryMemberForOrder:(NSDictionary *)dict{
    
    NSString *title = @"查询结果";
    NSString *content = [self combieTitle:dict];
    NSLog(@"content%@",content);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

-(void)onQueryMember:(NSDictionary *)dict{

    NSString *title = @"查询结果";
    NSString *content = [self combieTitle:dict];
    NSLog(@"content%@",content);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
    [alert show];
    
}

-(void)onQueryOrder:(NSDictionary *)dict{
    
    NSString *title = @"查询结果";
    NSString *content = [self combieTitle:dict];
    NSLog(@"content%@",content);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
    [alert show];
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

-(void)scanQRCode:(UIViewController *)controller{
    [ThirdPay scanQRCode:controller Delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
