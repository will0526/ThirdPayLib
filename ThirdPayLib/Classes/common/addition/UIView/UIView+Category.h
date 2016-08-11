/*!
 
 @header   UIView+SNCategory.h
 @abstract IOSTempleteProject
 @author   will
 @version  1.0  14-2-8 Creation
 
 */
#import <UIKit/UIKit.h>

@interface UIView (Category)

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property(nonatomic,readonly) CGFloat screenX;
@property(nonatomic,readonly) CGFloat screenY;
@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;


- (void)removeAllSubviews;
- (UIViewController *)viewController;
- (void)setCornerRadius:(BOOL)isRadius;

@end
