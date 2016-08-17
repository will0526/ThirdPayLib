/*!
 
 @header   LJTimer.h
 @abstract IOSTempleteProject   
 @author   will
 @version  1.0  14-2-10 Creation
 
 */

#import <Foundation/Foundation.h>
#import "GlobleDefine.h"
@interface NSObject (LJTimer)

- (void)startTimerWithInterval:(NSTimeInterval)interval sel:(SEL)aSel repeat:(BOOL)aRep;
- (void)stopTimerWithSel:(SEL)aSel;
- (void)stopAllTimers;

@end



/*********************************************************************/


@interface LJTimerQueue : NSObject
{
    NSMutableArray  *_timerQueue;
}

AS_SINGLETON(LJTimerQueue);


- (void)scheduleTimeWithInterval:(NSTimeInterval)interval target:(id)target sel:(SEL)aSel repeat:(BOOL)aRep;

- (void)cancelTimerOfTarget:(id)target sel:(SEL)aSel;

- (void)cancelTimerOfTarget:(id)target;
@end
