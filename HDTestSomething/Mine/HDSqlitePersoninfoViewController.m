//
//  HDSqlitePersoninfoViewController.m
//  HDTestSomething
//
//  Created by yscompany on 2017/6/7.
//  Copyright © 2017年 yscompany. All rights reserved.
//
#define kRandom(length) [self getRandomStringWithLenght:length]

#import "HDSqlitePersoninfoViewController.h"
#import "HDUserInfoTable.h"
#import "MJRefresh.h"
@interface HDSqlitePersoninfoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *baseTableView;
@end

@implementation HDSqlitePersoninfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.baseTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteStoreInfo)];
    [HDUserInfoTable initData];
//    [self addUser];
    [self addUsers];
    // Do any additional setup after loading the view.
}
#pragma mark - action method
- (void)headRefreshData {
    [self.dataSource removeAllObjects];
    [self.baseTableView.mj_header beginRefreshing];
    [self getStoreInfo];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.baseTableView.mj_header endRefreshing];
    });
}
#pragma mark - 获取数据源信息
- (void)getStoreInfo {
//    self.dataSource = [HDUserInfoTable getAllUser];
    [self.dataSource addObjectsFromArray: [[HDSqliteManager shareSqliteManager] executeQuery:[NSString stringWithFormat:@"select * from user"]]];
    [self.baseTableView reloadData];
}
#pragma mark - button action method
- (void)deleteStoreInfo {
    [[HDSqliteManager shareSqliteManager] executeNonQuery:@"delete from user"];
    [[HDSqliteManager shareSqliteManager] executeNonQuery:@"delete from userRoom"];
    [self getStoreInfo];
}
#pragma mark - tableview delegate datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataSource[indexPath.row][@"name"];
    if (!cell.textLabel.text) {
        cell.textLabel.text = self.dataSource[indexPath.row][@"userName"];
    }
    cell.detailTextLabel.text = self.dataSource[indexPath.row][@"neckName"];
    if (!cell.detailTextLabel.text) {
        cell.detailTextLabel.text = self.dataSource[indexPath.row][@"friends"];
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSArray<UITableViewRowAction *>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [HDUserInfoTable deleteUserStateId:[[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"userTargetId"] integerValue]];
        [HDUserInfoTable deleteUser:[[self.dataSource objectAtIndex:indexPath.row] objectForKey:@"name"]];
        [self.baseTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *addAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"增加" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    addAction.backgroundColor = [UIColor greenColor];
    return @[deleteAction,addAction];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addUser {
    [HDUserInfoTable addUser:@"罗玉龙" neckName:@"雷炎" targetId:1210];
    [HDUserInfoTable addUser:@"梁承亮" neckName:@"一只小狗" targetId:1211];
    [HDUserInfoTable addUser:@"王朝" neckName:@"聪" targetId:1212];
    [HDUserInfoTable addUser:@"吕雄一" neckName:@"德莱厄斯" targetId:1213];
    [HDUserInfoTable addUser:@"黄德" neckName:@"末日恐惧" targetId:1214];
    [HDUserInfoTable addUser:@"徐翔" neckName:@"虚空行者" targetId:1215];
    [self addUserState];
    [self getStoreInfo];
    
}
- (void)addUsers {
    NSMutableString *sql = [NSMutableString string];
    for (NSInteger i = 0;i < 10; i++) {
        [sql appendString:[NSString stringWithFormat:@"insert into user (name, neckName, targetId) values ('%@%zd', '%@%zd', %zd);",@"小明",i,@"阿花",i,i]];
    }
    [[HDSqliteManager shareSqliteManager] executeNonQuery:sql];
    [self addUserState];
    [self getStoreInfo];
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
        _baseTableView.backgroundColor = KBackgroundColor;
        _baseTableView.showsVerticalScrollIndicator = NO;
        _baseTableView.showsHorizontalScrollIndicator = NO;
        _baseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefreshData)];
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _baseTableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
