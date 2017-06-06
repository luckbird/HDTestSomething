//
//  HDTestTableViewCell.m
//  HDTestSomething
//
//  Created by yscompany on 2017/6/6.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDTestTableViewCell.h"

#define KSingal_line 1 / [UIScreen mainScreen].scale
#define KmarginLeft    16

@interface HDTestTableViewCell ()

@property (nonatomic, strong) UILabel *withdrawKindLabel;
@property (nonatomic, strong) UILabel *withdrawDateLabel;
@property (nonatomic, strong) UILabel *withdrawAmountLabel;
@property (nonatomic, strong) UILabel *withdrawStateLabel;
@property (nonatomic, strong) UILabel *withdrawMarginLabel;

@end
@implementation HDTestTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setSubviewsFrame];
    }
    return self;
}

- (void)setSubviewsFrame {
    self.withdrawKindLabel.frame = CGRectMake(KmarginLeft, 14, kScreenW/2 - 2 * KmarginLeft, 16);
    [self.contentView addSubview:self.withdrawKindLabel];
    
    self.withdrawDateLabel.frame = CGRectMake(KmarginLeft, CGRectGetMaxY(self.withdrawKindLabel.frame) + 4, kScreenW / 2 - 2 * KmarginLeft, 12);
    [self.contentView addSubview:self.withdrawDateLabel];
    
    self.withdrawAmountLabel.frame = CGRectMake(kScreenW / 2, 20, kScreenW/2 -  KmarginLeft, 15);
    [self.contentView addSubview:self.withdrawAmountLabel];
    
    self.withdrawStateLabel.frame = CGRectMake(kScreenW / 2, CGRectGetMaxY(self.withdrawAmountLabel.frame) + 4, kScreenW/2 - KmarginLeft, 12);
    [self.contentView addSubview:self.withdrawStateLabel];
    
    self.withdrawMarginLabel.frame = CGRectMake(0, 60 - KSingal_line, kScreenW, KSingal_line);
    [self.contentView addSubview:self.withdrawMarginLabel];
}
- (void)setPOSRecordInfo:(NSDictionary *)dict {
    self.withdrawKindLabel.text = [VerifyTools getSafeString:[dict objectForKey:@"withdrawalType"]];
    self.withdrawDateLabel.text = [VerifyTools getSafeString:[dict objectForKey:@"withdrawalTime"]];
    self.withdrawAmountLabel.text = [VerifyTools getSafeString:[dict objectForKey:@"arrivalAmount"]];
    self.withdrawStateLabel.text = [VerifyTools getSafeString:[dict objectForKey:@"businessstate"]];
    if ([self.withdrawStateLabel.text isEqualToString:@"处理中"]) {
        self.withdrawStateLabel.hidden = NO;
    }else {
        self.withdrawStateLabel.hidden = YES;
    }
}

#pragma mark - getter method
- (UILabel *)withdrawDateLabel {
    if (!_withdrawDateLabel) {
        _withdrawDateLabel = [UILabel new];
        _withdrawDateLabel.textColor = kColorWithRGB(100, 100, 100);
        _withdrawDateLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _withdrawDateLabel;
}
- (UILabel *)withdrawKindLabel {
    if (!_withdrawKindLabel) {
        _withdrawKindLabel = [UILabel new];
        _withdrawKindLabel.textColor = kColorWithRGB(60, 60, 60);
        _withdrawKindLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _withdrawKindLabel;
}
- (UILabel *)withdrawAmountLabel {
    if (!_withdrawAmountLabel) {
        _withdrawAmountLabel = [UILabel new];
        _withdrawAmountLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _withdrawAmountLabel.textColor = [UIColor blackColor];
        _withdrawAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _withdrawAmountLabel;
}
- (UILabel *)withdrawStateLabel {
    if (!_withdrawStateLabel) {
        _withdrawStateLabel = [UILabel new];
        _withdrawStateLabel.font = [UIFont systemFontOfSize:12.0f];
        _withdrawStateLabel.textColor = kColorWithRGB(255, 162, 0);
        _withdrawStateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _withdrawStateLabel;
}
- (UILabel *)withdrawMarginLabel {
    if (!_withdrawMarginLabel) {
        _withdrawMarginLabel = [UILabel new];
        _withdrawMarginLabel.backgroundColor = kColorWithRGB(220, 220, 220);
    }
    return _withdrawMarginLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
