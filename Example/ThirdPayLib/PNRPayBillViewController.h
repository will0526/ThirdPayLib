//
//  PNRPayBillViewController.h
//  ThirdPayLib
//
//  Created by will on 2017/7/18.
//  Copyright © 2017年 王英永. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSOCProtocol<JSExport>


-(void)onBookOrder:(NSString *)orderinfo;



@end

@interface PNRPayBillViewController : UIViewController


@end
