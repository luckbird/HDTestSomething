//
//  BaseViewController.h
//  HDTestSomething
//
//  Created by yscompany on 2017/5/22.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDNetworking.h"
@interface BaseViewController : UIViewController
@property (nonatomic, strong) HDNetworking *http;
@end
