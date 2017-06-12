//
//  HDMineViewController.m
//  HDTestSomething
//
//  Created by yscompany on 2017/5/22.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDMineViewController.h"
#import "HDTestmarqueeViewController.h"
#import "HDTestTableViewEditingController.h"
#import "HDUserInfoTable.h"
#import "HDSqlitePersoninfoViewController.h"

#define kRandom(length) [self getRandomStringWithLenght:length]
@interface HDMineViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *baseTableView;
@end

@implementation HDMineViewController
double t(double last, char* key){
    clock_t now = clock();
    double time = (last != 0) ? (double)(now - last) / CLOCKS_PER_SEC : 0;
    printf("time:%0.2fms \t key:%s \n", time*1000, key);
    return now;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *marqueeBtn = [[UIBarButtonItem alloc] initWithTitle:@"跑马灯" style:UIBarButtonItemStylePlain target:self action:@selector(enterMarqueeVc)];
    UIBarButtonItem *tableviewEditingBtn = [[UIBarButtonItem alloc] initWithTitle:@"特效" style:UIBarButtonItemStylePlain target:self action:@selector(enterTableViewEditingStyleVC)];
    
    self.navigationItem.rightBarButtonItems = @[marqueeBtn,tableviewEditingBtn];
    //删除表的断点
//    [HDUserInfoTable initData];
//    
//    /**
//     [LYDataService deleteUser:@"hh"];
//     [LYDataService updateUser:@"heh" neckName:@"呵呵哒" targetId:1224];
//     [[LYDataManager sharedLYDataManager] executeTransaction];
//     [self addUser];
//     */
//    double t1 = t(0, "");
//    NSMutableString *sql = [NSMutableString string];
//    for (int i = 0; i < 100; i++) {
//        [sql appendFormat:@"insert into user (name, neckName, targetId) values ('%@', '%@', %zd);", @"hehe", @"haha", i+1216];
//    }
//    //    [[LYDataManager sharedLYDataManager] executeNonQuery:@"BEGIN TRANSACTION"];
//    //    [[LYDataManager sharedLYDataManager] executeNonQuery:sql];
//    //    [[LYDataManager sharedLYDataManager] executeNonQuery:@"COMMIT TRANSACTION"];
//    //    [[LYDataManager sharedLYDataManager] executeTransaction:^{
//    //        [[LYDataManager sharedLYDataManager] executeNonQuery:sql];
//    //    }];
//    
//    //    [[LYDataManager sharedLYDataManager] executeNonQuery:sql];
//    
//    t(t1, "end");
//    
//    _dataSource = [HDUserInfoTable getAllUser];
//    if (!_dataSource.count) {
//        [self addUser];
//        _dataSource = [HDUserInfoTable getAllUser];
//    }
//    
//    
//    //添加userState断点
// 
//    [self.view addSubview:self.baseTableView];
    
    //    [LYDataService deleteUser:@"罗玉龙"];
    //    [LYDataService deleteUserAndUserState:@"罗玉龙"];
    
    
//    dispatch_queue_t queue = dispatch_queue_create([@"sql" UTF8String], DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        [self addUser];
//    });
//    dispatch_async(queue, ^{
//        [self addUserState];
//    });

        // Do any additional setup after loading the view.
}
#pragma mark - action method
- (void)enterMarqueeVc {
    [MobClick event:@"test_AddSomething"];
    HDTestmarqueeViewController *vc = [HDTestmarqueeViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)enterTableViewEditingStyleVC {
    HDSqlitePersoninfoViewController *vc = [HDSqlitePersoninfoViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    [[HDSqliteManager shareSqliteManager] executeNonQuery:@"delete from user"];
//    _dataSource = [HDUserInfoTable getAllUser];
//    [self.baseTableView reloadData];
    
}
- (void)addUsers {
    for (int i = 0; i < 1000; i++) {
        NSString *sql = [NSString stringWithFormat:@"insert into user (name, neckName, targetId) values ('%@', '%@', %zd);", @"hehe", @"haha", i+1216];
        [[HDSqliteManager shareSqliteManager] executeNonQuery:sql];
    }
}
- (void)addUserStates {
    /**
     主键不存在，插入失败
     [LYDataService addUserStatus:@"leiyan" friens:@"some one" title:@"text" userTargetId:1000];
     */
    for (int i = 1210; i < 1316; i++) {
        [HDUserInfoTable addUserStatus:kRandom(6) friens:kRandom(8) title:kRandom(4) userTargetId:i];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataSource[indexPath.row][@"name"];
    cell.detailTextLabel.text = _dataSource[indexPath.row][@"neckName"];
    return cell;
}

- (void)addUser {
    [HDUserInfoTable addUser:@"罗玉龙" neckName:@"雷炎" targetId:1210];
    [HDUserInfoTable addUser:@"梁承亮" neckName:@"一只小狗" targetId:1211];
    [HDUserInfoTable addUser:@"王朝" neckName:@"聪" targetId:1212];
    [HDUserInfoTable addUser:@"吕雄一" neckName:@"德莱厄斯" targetId:1213];
    [HDUserInfoTable addUser:@"黄德" neckName:@"末日恐惧" targetId:1214];
    [HDUserInfoTable addUser:@"徐翔" neckName:@"虚空行者" targetId:1215];
    
}
- (NSString *)getRandomStringWithLenght:(NSInteger)length {
    NSArray *orderCharacte = [NSArray arrayWithObjects: @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    length = length == 0 ? 8 : length;
    NSMutableString *orderString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i<length; i++) {
        int index = arc4random() % (orderCharacte.count);
        [orderString appendString:orderCharacte[index]];
    }
    return [orderString copy];
}
- (void)addUserState {
    /**
     主键不存在，插入失败
     [LYDataService addUserStatus:@"leiyan" friens:@"some one" title:@"text" userTargetId:1000];
     */
    for (int i = 1210; i < 1216; i++) {
        [HDUserInfoTable addUserStatus:kRandom(6) friens:kRandom(8) title:kRandom(4) userTargetId:i];
    }
}
#pragma mark - getter method
- (UITableView *)baseTableView {
    if (!_baseTableView) {
        _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _baseTableView.delegate = self;
        _baseTableView.dataSource = self;
        _baseTableView.showsVerticalScrollIndicator = NO;
        _baseTableView.showsHorizontalScrollIndicator = NO;
    }
    return _baseTableView;
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
