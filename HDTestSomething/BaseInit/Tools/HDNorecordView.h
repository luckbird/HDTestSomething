//
//  HDNorecordView.h
//  HDTestSomething
//
//  Created by yscompany on 2017/6/6.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDNorecordView : UIView
/**
 获取数据失败 默认展示背景图

 @param frame 坐标
 @param titleStr 无记录提示文案
 @param imageName 无记录默认展示图案
 @return view
 */
- (instancetype)initWithFrame:(CGRect)frame andNorecordTitle:(NSString *)titleStr norecordImageName:(NSString *)imageName;
@property (nonatomic, strong) NSString *promoteTitleStr;
@property (nonatomic, strong) NSString *defaultImageName;
@end
