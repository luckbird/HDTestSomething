//
//  HDTestCollectionViewCell.h
//  HDTestSomething
//
//  Created by yscompany on 2017/5/22.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HDTestCollectionCellState) {
    HDTestCollectionCellStateDefault = 0,//默认展示效果，有内容显示内容，有彩带显示彩带
    HDTestCollectionCellStateAdd = 1,//右上角+
    HDTestCollectionCellStateSubtract = 2,//右上角-
    HDTestCollectionCellStateAdded = 3,//右上角√
    HDTestCollectionCellStateWaitingAdd = 4//待添加，只显示虚线框
};
typedef void(^longPressAction)(UILongPressGestureRecognizer *longPress) ;
typedef void(^panPressAction)(UIPanGestureRecognizer *panPress);
@interface HDTestCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) longPressAction longPressStyle;
@property (nonatomic, copy) panPressAction  panPressStyle;
- (void)setImageName:(NSDictionary *)dict;
- (void)setImageStateDict:(NSDictionary *)dict;
@end
