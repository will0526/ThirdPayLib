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
#import "AFNetworking.h"
@interface PNRViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ThirdPayDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UITableView * backgroundTableview;

@property (nonatomic, strong)UIButton * bookOrder;
@property (nonatomic, strong)NSMutableDictionary *params;

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
    
    
    //测试数据
    switch (_viewType) {
        case 0:
        {
            dataSource = @[@"用户号",@"商户号",@"订单号"];
            defaultSource = @[@"0001",@"000000000000001",@"20160923091858000551"];
        }
            break;
        case 1:
        {
            dataSource = @[@"用户号",@"商户号",@"商户订单号",@"商品名称",@"商品详情",@"订单金额(分)",@"实付金额(分)",@"红包",@"积分",@"备注",@"通知地址"];
            defaultSource = @[@"0001",@"000000000000001",merchantOrder,@"苹果手机 6s",@"苹果手机6s 正品行货 64G 假一赔十",@"540000",@"1",@"0",@"0",@"不支持货到付款",@"http://www.baidu.com"];
        }
            break;
        case 2:
        {
            dataSource = @[@"用户号",@"商户号",@"商户订单号",@"商品名称",@"商品详情",@"订单金额(分)",@"实付金额(分)",@"红包",@"积分",@"备注",@"支付方式"];
            pickerData = @[@"支付宝",@"微信",@"翼支付",@"Apple Pay",@"百度钱包"];
            defaultSource = @[@"0001",@"000000000000001",merchantOrder,@"苹果手机6s",@"苹果手机6s 正品行货 64G 假一赔十",@"5400",@"1",@"0",@"0",@"不支持货到付款",@""];
            _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 260)];
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
            _pickerView.showsSelectionIndicator = YES;
//            _pickerView.hidden = YES;
            _pickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 260);
            _pickerView.backgroundColor = [UIColor lightGrayColor];
            
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
    //    self.backgroundTableview.bounces = NO;
    
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
     @param memberNo         用户号
     *  @param merchantNO       商户号
     *  @param merchantOrderNO  商户订单号
     *  @param orderTitle       订单标题
     *  @param orderDetail      订单详情
     *  @param memo             备注
     *  @param totalAmount      订单总金额（分）
     *  @param payAmount        待支付金额（分）
     *  @param notifyURL        后台通知地址
     
     */
    switch (textField.tag) {
        case 0:
        {
            [self.params setValue:textField.text forKey:@"memberNo"];
        }
            break;
        case 1:
        {
            [self.params setValue:textField.text forKey:@"merchantNO"];
        }
            break;
        case 2:
        {
            switch (_viewType) {
                case 0:
                {
                    [self.params setValue:textField.text forKey:@"orderNO"];
                }
                    break;
                case 1:
                {
                    [self.params setValue:textField.text forKey:@"merchantOrderNO"];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case 3:
        {
            [self.params setValue:textField.text forKey:@"orderTitle"];
        }
            break;
        case 4:
        {
            [self.params setValue:textField.text forKey:@"orderDetail"];
        }
            break;
        case 5:
        {
            [self.params setValue:textField.text forKey:@"totalAmount"];
        }
            break;
        case 6:
        {
            [self.params setValue:textField.text forKey:@"payAmount"];
        }
            break;
        case 7:
        {
            [self.params setValue:textField.text forKey:@"redPocket"];
        }
            break;
        case 8:
        {
            [self.params setValue:textField.text forKey:@"point"];
        }
            break;
        case 9:
        {
            [self.params setValue:textField.text forKey:@"memo"];
        }
            break;
        case 10:
        {
            [self.params setValue:@"http//:www.baidu.com" forKey:@"notifyURL"];
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
    [self.params setValue:@"ThirdPayDemo" forKey:@"appSchemeStr"];
    
    switch (_viewType) {
        case 0:
        {
            NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:self.params];
            
            [ThirdPay queryOrderInfo:dict ViewController:self Delegate:self];
        }
            break;
        case 1:
        {
            NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:self.params];
            
            [ThirdPay showPayTypeWithTradeInfo:dict ViewController:self Delegate:self];
        }
            break;
        case 2:
        {
            NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:self.params];
            
            [ThirdPay payWithTradeInfo:dict ViewController:self Delegate:self PayType:paytype];
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
    
    if (_viewType == 2 && indexPath.row == 10 ) {
        
        payTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 250, 40)];
        payTypeLabel.text = @"支付宝";
        paytype = PayType_Alipay;
        payTypeLabel.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:payTypeLabel];
        UIButton *paytypeSelect = [[UIButton alloc]initWithFrame:CGRectMake(110, 5, 250, 40)];
        [paytypeSelect setBackgroundColor:[UIColor clearColor]];
        [paytypeSelect addTarget:self action:@selector(pickerViewShow) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:paytypeSelect];
       
        [self.params setValue:@"http\\:www.baidu.com" forKey:@"notifyURL"];
    }else{
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(55, 5, self.view.frame.size.width - 60, 40)];
        textField.placeholder = dataSource[indexPath.row];
        textField.text = defaultSource[indexPath.row];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
        textField.tag = indexPath.row;
        textField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test"]];
        textField.leftViewMode = UITextFieldViewModeAlways;
        [cell addSubview:textField];
        
        switch (textField.tag) {
            case 0:
            {
                NSString *temp = textField.text;
                [self.params setValue:temp forKey:@"memberNo"];
            }
                break;
            case 1:
            {
                [self.params setValue:textField.text forKey:@"merchantNO"];
            }
                break;
            case 2:
            {
                switch (_viewType) {
                    case 0:
                    {
                        [self.params setValue:textField.text forKey:@"orderNO"];
                    }
                        break;
                    case 1:
                    case 2:
                    {
                        [self.params setValue:textField.text forKey:@"merchantOrderNO"];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 3:
            {
                [self.params setValue:textField.text forKey:@"orderTitle"];
            }
                break;
            case 4:
            {
                [self.params setValue:textField.text forKey:@"orderDetail"];
            }
                break;
            case 5:
            {
                [self.params setValue:textField.text forKey:@"totalAmount"];
            }
                break;
            case 6:
            {
                [self.params setValue:textField.text forKey:@"payAmount"];
            }
                break;
            case 7:
            {
                [self.params setValue:textField.text forKey:@"redPocket"];
            }
                break;
            case 8:
            {
                [self.params setValue:textField.text forKey:@"point"];
            }
                break;
            case 9:
            {
                [self.params setValue:textField.text forKey:@"memo"];
            }
                break;
            case 10:
            {
                [self.params setValue:@"http\\:www.baidu.com" forKey:@"notifyURL"];
            }
                break;
            default:
                break;
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
