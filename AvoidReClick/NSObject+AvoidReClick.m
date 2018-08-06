//
//  NSObject+AvoidReClick.m
//  AvoidReClick
//
//  Created by qingfeng on 2018/8/6.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "NSObject+AvoidReClick.h"
#import <objc/message.h>

static const char *kTimeInterval = "comeTimeInterval";
static const char *kIsIgnoreEvent = "comeIsIgnoreEvent";

@implementation NSObject (AvoidReClick)

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
