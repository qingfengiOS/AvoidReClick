//
//  UIButton+AvoidReClick.m
//  AvoidReClick
//
//  Created by qingfeng on 2018/7/20.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "UIButton+AvoidReClick.h"
#import <objc/runtime.h>

static const char *kTimeInterval = "timeInterval";
static const char *kIsIgnoreEvent = "isIgnoreEvent";
static const NSTimeInterval defaultValue = 0.5;

@implementation UIButton (AvoidReClick)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originSelector =  @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(qf_sendAction:to:forEvent:);
        
        Method originMethod = class_getInstanceMethod([self class], originSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        
        BOOL didAddMethod = class_addMethod([self class], originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod([self class], swizzledSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
    
}

#pragma mark - CustomMethods
- (void)qf_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSStringFromClass([self class]) isEqualToString:@"UIButton"]) {
        self.timeInterval = (self.timeInterval == 0) ? defaultValue : self.timeInterval;
        
        if (self.isIgnoreEvent) {
            return;
        }
        if (self.timeInterval > 0.1) {
            [self performSelector:@selector(resetIsIgnoreEvent) withObject:nil afterDelay:self.timeInterval];
        }
    }
    self.isIgnoreEvent = YES;
    [self qf_sendAction:action to:target forEvent:event];
}

- (void)resetIsIgnoreEvent{
    [self setIsIgnoreEvent:NO];
}

#pragma mark - Setters
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    objc_setAssociatedObject(self, kTimeInterval, @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent {
    
    objc_setAssociatedObject(self, kIsIgnoreEvent, @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getters
- (NSTimeInterval)timeInterval {
    return [objc_getAssociatedObject(self, kTimeInterval) doubleValue];
}

- (BOOL)isIgnoreEvent {
    return [objc_getAssociatedObject(self, kIsIgnoreEvent) boolValue];
}

@end
