//
//  UIControl+Click.m
//  aaa
//
//  Created by dym on 2017/7/31.
//  Copyright © 2017年 dym. All rights reserved.
//

#import "UIControl+Click.h"
#import <objc/runtime.h>

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

static const char *UIcontrol_ignoreEvent = "UIcontrol_ignoreEvent";

@implementation UIControl (Click)

- (NSTimeInterval)acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEvent{
    return [objc_getAssociatedObject(self, UIcontrol_ignoreEvent) boolValue];
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent{
    objc_setAssociatedObject(self, UIcontrol_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    
    Method b = class_getInstanceMethod(self, @selector(xb_sendAction:to:forEvent:));
    
    method_exchangeImplementations(a, b);
}

- (void)xb_sendAction:(SEL)action to:(id)target forEvent:(UIEvent*)event{
    if (self.ignoreEvent) return;
    if (self.acceptEventInterval > 0) {
        self.ignoreEvent = YES;
        
        [self performSelector:@selector(setIgnoreEvent:) withObject:@(NO) afterDelay:self.acceptEventInterval];
    }
    
    [self xb_sendAction:action to:target forEvent:event];
}






















@end







