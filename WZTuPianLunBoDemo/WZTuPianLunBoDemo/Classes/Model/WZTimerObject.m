//
//  WZTimerObject.m
//  WZTuPianLunBoDemo
//
//  Created by songbiwen on 2016/11/25.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZTimerObject.h"

@interface WZTimerObject ()
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL aSelector;

@end
@implementation WZTimerObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    WZTimerObject *timer = [[WZTimerObject alloc] init];
    timer.target = aTarget;
    timer.aSelector = aSelector;
    return [NSTimer scheduledTimerWithTimeInterval:ti target:timer selector:@selector(fire:) userInfo:userInfo repeats:yesOrNo];
}

- (void)fire:(id)obj {
    [self.target performSelector:self.aSelector withObject:obj];
}
@end
