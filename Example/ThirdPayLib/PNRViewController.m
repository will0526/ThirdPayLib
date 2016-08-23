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

@interface PNRViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ThirdPayDelegate>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UITableView * backgroundTableview;

@property (nonatomic, strong)UIButton * bookOrder;
@property (nonatomic, strong)NSMutableDictionary *params;

@end

@implementation PNRViewController
{
    NSArray *dataSource;
    NSArray *defaultSource;
    UIView *backView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"测试";
    
    //测试数据
    dataSource = @[@"用户号",@"商户号",@"订单号",@"商品名称",@"商品详情",@"订单金额",@"实付金额",@"备注",@"通知地址"];
    defaultSource = @[@"0001",@"000002",@"20160806",@"苹果手机6s",@"苹果手机6s 正品行货 64G 假一赔十",@"5400",@"100",@"不支持货到付款",@"http://www.baidu.com"];
    
    self.params = [[NSMutableDictionary alloc]init];
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    [backView addSubview:self.tableView];
    [backView addSubview:self.bookOrder];
    
    [self.bookOrder addTarget:self action:@selector(bookOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview: self.backgroundTableview];
    self.backgroundTableview.tableHeaderView = backView;
    //    self.backgroundTableview.bounces = NO;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDown)];
    [self.view addGestureRecognizer:gesture];
    
    
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
     @param memberNO         用户号
     *  @param merchantNO       商户号
     *  @param merchantOrderNO  商户订单号
     *  @param goodsName        商品名称
     *  @param goodsDetail      商品详情
     *  @param memo             备注
     *  @param totalAmount      订单总金额（分）
     *  @param payAmount        待支付金额（分）
     *  @param notifyURL        后台通知地址
     
     */
    switch (textField.tag) {
        case 0:
        {
            [self.params setValue:textField.text forKey:@"memberNO"];
        }
            break;
        case 1:
        {
            [self.params setValue:textField.text forKey:@"merchantNO"];
        }
            break;
        case 2:
        {
            [self.params setValue:textField.text forKey:@"merchantOrderNO"];
        }
            break;
        case 3:
        {
            [self.params setValue:textField.text forKey:@"goodsName"];
        }
            break;
        case 4:
        {
            [self.params setValue:textField.text forKey:@"goodsDetail"];
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
            [self.params setValue:textField.text forKey:@"memo"];
        }
            break;
        case 8:
        {
            [self.params setValue:textField.text forKey:@"notifyURL"];
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
        [_bookOrder setTitle:@"下单" forState:UIControlStateNormal];
        [_bookOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_bookOrder setBackgroundColor:[UIColor orangeColor]];
        
        _bookOrder.clipsToBounds = YES;
        _bookOrder.layer.cornerRadius = 20;
        
    }
    
    return _bookOrder;
    
    
}

-(void)bookOrder:(UIButton *)button{
    
    NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:self.params];
    
    
    [ThirdPay showPayTypeWithTradeInfo:dict ViewController:self Delegate:self];
    
}


-(void)netTest{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlStr = @"http://www.baidu.com";
    manager.requestSerializer.timeoutInterval = 30;
    NSDictionary *params = [[NSDictionary alloc]init];
    [manager POST:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSLog(@"net is ok");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"net is fail");
    }];
//    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSLog(@"net is ok");
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"net is failed22222");
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"net is failed11");
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"net is failed");
//    }];
    
//
    
    
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
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 40)];
    textLabel.text = dataSource[indexPath.row];
    textLabel.textAlignment = NSTextAlignmentLeft;
    
    [cell addSubview:textLabel];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(95, 5, 250, 40)];
    textField.placeholder = dataSource[indexPath.row];
    textField.text = defaultSource[indexPath.row];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    textField.tag = indexPath.row;
    NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ThirdPayLib.bundle"];
    textField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"test"]];
    textField.leftViewMode = UITextFieldViewModeAlways;
    [cell addSubview:textField];
    
    switch (textField.tag) {
        case 0:
        {
            [self.params setValue:textField.text forKey:@"memberNO"];
        }
            break;
        case 1:
        {
            [self.params setValue:textField.text forKey:@"merchantNO"];
        }
            break;
        case 2:
        {
            [self.params setValue:textField.text forKey:@"merchantOrderNO"];
        }
            break;
        case 3:
        {
            [self.params setValue:textField.text forKey:@"goodsName"];
        }
            break;
        case 4:
        {
            [self.params setValue:textField.text forKey:@"goodsDetail"];
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
            [self.params setValue:textField.text forKey:@"memo"];
        }
            break;
        case 8:
        {
            [self.params setValue:textField.text forKey:@"notifyURL"];
        }
            break;
        default:
            break;
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



#pragma mark thirdPayDelegate


-(void)onQueryOrder:(NSDictionary *)dict{
    
    
}

-(void)onPayResult:(PayStatus)payStatus withInfo:(NSDictionary *)dict{
    NSLog(@"%u.......%@",payStatus,dict);
    
    switch (payStatus) {
        case PayStatus_PAYSUCCESS:
        {
        
            
        }
            break;
            
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"交易结果" message:@"" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
