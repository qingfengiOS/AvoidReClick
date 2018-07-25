//
//  UIButton+AvoidReClick.h
//  AvoidReClick
//
//  Created by qingfeng on 2018/7/20.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 防止重复点击类
 */
@interface UIButton (AvoidReClick)

/// 防止重复点击的时间间隔
@property (nonatomic, assign) NSTimeInterval timeInterval;

/// 是否忽略事件 YES：忽略事件，不响应 NO：响应事件
@property (nonatomic, assign) BOOL isIgnoreEvent;

@end
