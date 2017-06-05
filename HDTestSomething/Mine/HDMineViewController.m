//
//  HDMineViewController.m
//  HDTestSomething
//
//  Created by yscompany on 2017/5/22.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDMineViewController.h"

@interface HDMineViewController ()
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) NSTimer *time;
@property (nonatomic, strong) CADisplayLink *adtimer;
@end

@implementation HDMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.currentLabel];
    
  
        // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.adtimer.paused = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.adtimer.paused = YES;
}

#pragma mark - action method
- (void)adStartAnimating {
    CGFloat distance = kScreenW / 600;
    CGFloat adLabelX = _currentLabel.frame.origin.x - distance;
    CGRect tempF = _currentLabel.frame;
    if (adLabelX < -(_currentLabel.frame.size.width)) {
        tempF.origin.x = kScreenW ;
        _currentLabel.frame = tempF;
        return;
    }
    tempF.origin.x = adLabelX;
    _currentLabel.frame = tempF;
}

#pragma mark -  getter method
- (UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, kScreenW, 20)];
        _currentLabel.backgroundColor = [UIColor clearColor];
        _currentLabel.text = @"我就是用来测试跑马灯文字展示的";
        CGRect frame = _currentLabel.frame;
        CGSize dims = [_currentLabel.text sizeWithFont:self.currentLabel.font];
        frame.origin.x = dims.width >kScreenW ? dims.width:kScreenW;      //设置起点
        frame.size.width = dims.width;
        _currentLabel.frame = frame;
        _currentLabel.textColor = [UIColor redColor];
        _currentLabel.font = [UIFont systemFontOfSize:16.0f];
    }
    return _currentLabel;
}
- (CADisplayLink *)adtimer {
    if (!_adtimer) {
        _adtimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(adStartAnimating)];
        [_adtimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _adtimer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
