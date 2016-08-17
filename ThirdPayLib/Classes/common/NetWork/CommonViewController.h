/*!
 
 @header   UMSCommonViewController.h
 @abstract IOSTempleteProject
 @author   will
 @version  1.0  14-2-7 Creation
 
 */

#import "GlobleDefine.h"

typedef void (^CompleteBlock)();
@interface CommonViewController : UIViewController



-(void)changeLanguageRefreshView:(NSNotification *)note;

-(void) showLoadingView;

-(void) requestServer;
/**
 *	hidden loading view
 */
-(void) hidingLoadingView;


- (void)presentViewControllerWithNav:(UIViewController *)controller
                            animated:(BOOL)flag
                          completion:(void (^)(void))completion;

- (void)presentSheet:(NSString *)indiTitle complete:(BasicBlock)callBack;
-(void) showErrorMsg:(NSString*) message;//提示语用这个方法
- (void)presentSheet:(NSString *)indiTitle;
- (CGRect)visibleBoundsShowNav:(BOOL)hasNav showTabBar:(BOOL)hasTabBar;
@end

