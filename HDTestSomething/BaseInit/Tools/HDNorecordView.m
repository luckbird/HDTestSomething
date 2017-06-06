//
//  HDNorecordView.m
//  HDTestSomething
//
//  Created by yscompany on 2017/6/6.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDNorecordView.h"

@interface HDNorecordView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *promoteLabel;
@end
@implementation HDNorecordView

- (instancetype)initWithFrame:(CGRect)frame andNorecordTitle:(NSString *)titleStr norecordImageName:(NSString *)imageName {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageView.image = [UIImage imageNamed:[VerifyTools getSafeString:imageName]];
        [self addSubview:self.imageView];
        
        self.promoteLabel.text = [VerifyTools getSafeString:titleStr];
        [self addSubview:self.promoteLabel];
    }
    return self;
}

#pragma mark - getter setter method
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW - 96)/2, 124, 96, 96)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.image = [UIImage imageNamed:@"OrderFromNoResult"]; 
    }
    return _imageView;
}
- (UILabel *)promoteLabel {
    if (!_promoteLabel) {
        _promoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) +15, kScreenW, 20)];
        _promoteLabel.font = [UIFont systemFontOfSize:14];
        _promoteLabel.textColor = kColorWithRGB(190, 190, 190);
        _promoteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _promoteLabel;
}
- (void)setPromoteTitleStr:(NSString *)promoteTitleStr {
    self.promoteLabel.text = [VerifyTools getSafeString:promoteTitleStr];
}
- (void)setDefaultImageName:(NSString *)defaultImageName {
    self.imageView.image = [UIImage imageNamed:[VerifyTools getSafeString:defaultImageName]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
