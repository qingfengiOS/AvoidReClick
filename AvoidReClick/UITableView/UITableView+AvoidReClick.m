//
//  UITableView+AvoidReClick.m
//  AvoidReClick
//
//  Created by qingfeng on 2018/8/6.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "UITableView+AvoidReClick.h"
#import <objc/runtime.h>
#import "NSObject+AvoidReClick.h"

static const NSTimeInterval defaultValue = 0.5;

@implementation UITableView (AvoidReClick)

+ (void)load {
    Method setDelegateMethod = class_getInstanceMethod(self, @selector(setDelegate:));
    Method ddSetDelegateMethod = class_getInstanceMethod(self, @selector(qf_setDelegate:));
    method_exchangeImplementations(setDelegateMethod, ddSetDelegateMethod);
}

- (void)qf_setDelegate:(id<UITableViewDelegate>)delegate {
    //只监听UITableView
    if (![self isMemberOfClass:[UITableView class]]) {
        return;
    }
    
    [self qf_setDelegate:delegate];
    
    if (delegate) {
        Class class = [delegate class];
        
        SEL originSelector = @selector(tableView:didSelectRowAtIndexPath:);
        SEL swizzlSelector = @selector(tableView:qf_didSelectRowAtIndexPath:);
        
        Method originMethod = class_getInstanceMethod(class, originSelector);
        Method swizzledMethod = class_getInstanceMethod([self class], swizzlSelector);
        
        BOOL didAddMethod = class_addMethod(class, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzlSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
        
    }
}

- (void)tableView:(UITableView *)tableView qf_didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self isMemberOfClass:[UITableView class]]) {
        return;
    }
    tableView.timeInterval = (tableView.timeInterval == 0) ? defaultValue : tableView.timeInterval;

    if (tableView.isIgnoreEvent) {
        return;
    }
    if (tableView.timeInterval > 0.1) {
        NSLog(@"%f",tableView.timeInterval);
        [tableView performSelector:@selector(resetIsIgnoreEvent:) withObject:tableView afterDelay:tableView.timeInterval];
    }
    tableView.isIgnoreEvent = YES;
    [tableView tableView:tableView qf_didSelectRowAtIndexPath:indexPath];
    
}

- (void)resetIsIgnoreEvent:(UITableView *)tableView {
    tableView.isIgnoreEvent = NO;
}

@end
