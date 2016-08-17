//
//  LJTimer.m
//  IOSTempleteProject
//
//  Created by will on 14-2-10.
//  Copyright (c) 2014年 UMS. All rights reserved.
//

#import "LJTimer.h"

@interface LJTimerItem : NSObject

@property (nonatomic, unsafe_unretained) id target;
@property (nonatomic, assign) SEL selector;

@end

@implementation LJTimerItem

@synthesize target;
@synthesize selector;

@end


@implementation NSObject(LJTimer)

- (void)startTimerWithInterval:(NSTimeInterval)interval sel:(SEL)aSel repeat:(BOOL)aRep
{
    [[LJTimerQueue sharedInstance] scheduleTimeWithInterval:interval
                                                     target:self
                                                        sel:aSel
                                                     repeat:aRep];
}

- (void)stopTimerWithSel:(SEL)aSel
{
    [[LJTimerQueue sharedInstance] cancelTimerOfTarget:self sel:aSel];
}

- (void)stopAllTimers
{
    [[LJTimerQueue sharedInstance] cancelTimerOfTarget:self];
}

@end

@interface LJTimerQueue()
{
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	UIBackgroundTaskIdentifier backgroundTask;
#endif
}

@end

/*********************************************************************/

@implementation LJTimerQueue

DEF_SINGLETON(LJTimerQueue);

- (id)init
{
    self = [super init];
    if (self) {
        _timerQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)scheduleTimeWithInterval:(NSTimeInterval)interval target:(id)target sel:(SEL)aSel repeat:(BOOL)aRep
{
    [self cancelTimerOfTarget:target sel:aSel];
    
    LJTimerItem *item = [[LJTimerItem alloc] init];
    item.target = target;
    item.selector = aSel;
    
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
    if (!backgroundTask || backgroundTask == UIBackgroundTaskInvalid)
    {
        backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            // Synchronize the cleanup call on the main thread in case
            // the task actually finishes at around the same time.
            dispatch_async(dispatch_get_main_queue(), ^{
                if (backgroundTask != UIBackgroundTaskInvalid)
                {
                    [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                    backgroundTask = UIBackgroundTaskInvalid;
                }
            });
        }];
    }
#endif
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                      target:self
                                                    selector:@selector(handleTimer:)
                                                    userInfo:item
                                                     repeats:aRep];
    [_timerQueue addObject:timer];
}

- (void)handleTimer:(NSTimer *)timer
{
    LJTimerItem *item = (LJTimerItem *)[timer userInfo];
    
    if ([item.target respondsToSelector:item.selector])
    {
        SuppressPerformSelectorLeakWarning([item.target performSelector:item.selector]);
    }
    
    if (![timer isValid])
    {
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        dispatch_async(dispatch_get_main_queue(), ^{
            if (backgroundTask != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                backgroundTask = UIBackgroundTaskInvalid;
            }
        });
#endif
        [_timerQueue removeObject:timer];
    }
}

- (void)cancelTimerOfTarget:(id)target sel:(SEL)aSel
{
    NSArray *timerArr = [NSArray arrayWithArray:_timerQueue];
    for (NSTimer *timer in timerArr)
    {
        LJTimerItem *item = (LJTimerItem *)[timer userInfo];
        if (item.target == target && item.selector == aSel)
        {
            if ([timer isValid]) {
                [timer invalidate];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (backgroundTask != UIBackgroundTaskInvalid) {
                        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                        backgroundTask = UIBackgroundTaskInvalid;
                    }
                });
#endif
            }
            [_timerQueue removeObject:timer];
            break;
        }
    }
}

- (void)cancelTimerOfTarget:(id)target
{
    NSArray *timerArr = [NSArray arrayWithArray:_timerQueue];
    for (NSTimer *timer in timerArr)
    {
        LJTimerItem *item = (LJTimerItem *)[timer userInfo];
        if (item.target == target)
        {
            if ([timer isValid]) {
                [timer invalidate];
#if TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (backgroundTask != UIBackgroundTaskInvalid) {
                        [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
                        backgroundTask = UIBackgroundTaskInvalid;
                    }
                });
#endif
            }
            [_timerQueue removeObject:timer];
        }
    }
}

@end
