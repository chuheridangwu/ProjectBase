//
//  UIControl+Click.h
//  aaa
//
//  Created by dym on 2017/7/31.
//  Copyright © 2017年 dym. All rights reserved.
// 防止button重复点击

#import <UIKit/UIKit.h>

@interface UIControl (Click)
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;//添加点击事件的间隔时间

@property (nonatomic, assign) BOOL ignoreEvent;//是否忽略点击事件,不响应点击事件
@end
