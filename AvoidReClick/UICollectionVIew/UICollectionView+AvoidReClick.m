//
//  UICollectionView+AvoidReClick.m
//  AvoidReClick
//
//  Created by qingfeng on 2018/8/6.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import "UICollectionView+AvoidReClick.h"
#import <objc/runtime.h>
#import "NSObject+AvoidReClick.h"
#import "NSObject+AvoidReClick.h"

static const NSTimeInterval defaultValue = 1;

@implementation UICollectionView (AvoidReClick)

+ (void)load {
    Method setDelegateMethod = class_getInstanceMethod(self, @selector(setDelegate:));
    Method qfSetDelegateMethod = class_getInstanceMethod(self, @selector(qf_setDelegate:));
    method_exchangeImplementations(setDelegateMethod, qfSetDelegateMethod);
}

- (void)qf_setDelegate:(id<UICollectionViewDelegate>)delegate {
    //只监听UIcollectionView
    if (![self isMemberOfClass:[UICollectionView class]]) {
        return;
    }
    
    [self qf_setDelegate:delegate];
    
    if (delegate) {
        Class class = [delegate class];
        
        SEL originSelector = @selector(collectionView:didSelectItemAtIndexPath:);
        SEL swizzlSelector = @selector(collectionView:qf_didSelectItemAtIndexPath:);
        
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

- (void)collectionView:(UICollectionView *)collectionView qf_didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![collectionView isMemberOfClass:[UICollectionView class]]) {
        return;
    }
    collectionView.timeInterval = (collectionView.timeInterval == 0) ? defaultValue : collectionView.timeInterval;
    
    if (collectionView.isIgnoreEvent) {
        return;
    }
    if (collectionView.timeInterval > 0.1) {
        NSLog(@"%f",collectionView.timeInterval);
        [collectionView performSelector:@selector(resetIsIgnoreEvent:) withObject:collectionView afterDelay:collectionView.timeInterval];
    }
    collectionView.isIgnoreEvent = YES;
    [collectionView collectionView:collectionView qf_didSelectItemAtIndexPath:indexPath];
}

- (void)resetIsIgnoreEvent:(UICollectionView *)collectionView {
    collectionView.isIgnoreEvent = NO;
}


@end
