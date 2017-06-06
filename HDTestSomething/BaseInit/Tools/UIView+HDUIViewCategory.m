//
//  UIView+HDUIViewCategory.m
//  HDTestSomething
//
//  Created by yscompany on 2017/6/6.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "UIView+HDUIViewCategory.h"

@implementation UIView (HDUIViewCategory)

- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint)orignal {
    return self.frame.origin;
}
- (void)setOrignal:(CGPoint)orignal {
    CGRect frame = self.frame;
    frame.origin = orignal;
    self.frame = frame;
}

@end
