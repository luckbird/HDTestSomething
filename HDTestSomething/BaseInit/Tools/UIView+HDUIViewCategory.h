//
//  UIView+HDUIViewCategory.h
//  HDTestSomething
//
//  Created by yscompany on 2017/6/6.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HDUIViewCategory)

/**
扩展UIView 的坐标属性 便于后期做frame值变化的动画效果
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint orignal;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@end
