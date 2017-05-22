//
//  BaseTabBarController.m
//  HDTestSomething
//
//  Created by yscompany on 2017/5/22.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "BaseTabBarController.h"
#import "HDHomePageViewController.h"
#import "HDNewsViewController.h"
#import "HDFindViewController.h"
#import "HDMineViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

+(instancetype)shareTabBarController {
    static BaseTabBarController *tabBar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBar = [BaseTabBarController new];
    });
    return tabBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getChildViewControllers];
    // Do any additional setup after loading the view.
}
- (void)getChildViewControllers {
    [self addChildVC:[HDHomePageViewController new] childTitle:@"首页" andImageName:@"hdhomePage"];
    [self addChildVC:[HDNewsViewController new] childTitle:@"消息" andImageName:@"hdnews"];
    [self addChildVC:[HDFindViewController new] childTitle:@"发现" andImageName:@"hdfind"];
    [self addChildVC:[HDMineViewController new] childTitle:@"我" andImageName:@"hdmine"];
}
- (void)addChildVC:(UIViewController *)childVC childTitle:(NSString *)titleName andImageName:(NSString *)imageName {
    childVC.title = titleName;
    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
    childVC.tabBarItem.title = titleName;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVC];
    nav.title = titleName;
    [self addChildViewController:nav];
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
