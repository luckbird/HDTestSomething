//
//  HDTestTableViewEditingController.m
//  HDTestSomething
//
//  Created by yscompany on 2017/6/6.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDTestTableViewEditingController.h"
#import "HDNorecordView.h"
#import "HDTestTableViewCell.h"

static NSString *reuseIdentifierID = @"HDTestTableViewCellID";
@interface HDTestTableViewEditingController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, strong) HDNorecordView *norecordView;
@property (nonatomic, strong) NSArray *fakeDataArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@end

@implementation HDTestTableViewEditingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TableViewEditing describe";
    [self.view addSubview:self.baseTableView];
    [self.dataSourceArray addObjectsFromArray:self.fakeDataArray];
    [self.dataSourceArray addObjectsFromArray:self.fakeDataArray];
    [self.dataSourceArray addObjectsFromArray:self.fakeDataArray];
    [self.dataSourceArray addObjectsFromArray:self.fakeDataArray];
    [self.dataSourceArray addObjectsFromArray:self.fakeDataArray];
    [self setInfo];
    // Do any additional setup after loading the view.
}
- (void)setInfo {
    if (self.dataSourceArray.count > 0) {
        self.norecordView.hidden = YES;
        [self.baseTableView reloadData];
    }else {
        self.norecordView.hidden = NO;
    }
}
#pragma mark - tableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HDTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierID];
    [cell setPOSRecordInfo:[self.dataSourceArray objectAtIndex:indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
/**
 移动cell 必须实现的代理方法
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [self.dataSourceArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [self.baseTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}
/**
 自定义删除文案
 */
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}
/**
 自定义编辑模式下cell处于那种编辑状态
 */
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleNone;
//}

//设置滑动时显示多个按钮 iOS 8.0以上
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //添加一个删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
        //1.更新数据
        [self.dataSourceArray removeObjectAtIndex:indexPath.row];
        //2.更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    //删除按钮颜色
    deleteAction.backgroundColor = [UIColor cyanColor];
    //添加一个置顶按钮
    UITableViewRowAction *topRowAction =[UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"置顶" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        //1.更新数据
        [self.dataSourceArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        //2.更新UI
        NSIndexPath *firstIndexPath =[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    //置顶按钮颜色
    topRowAction.backgroundColor = [UIColor magentaColor];
    //--------更多
    UITableViewRowAction *insertAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"新增" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSDictionary *dict = @{@"withdrawalType":@"微信支付1",@"withdrawalTime":@"2017-05-04 12:12:22",@"withdrawalAmount":@"200.00元",@"withdrawalFee":@"2.00元",@"arrivalAmount":@"198.00元",@"bankCard":@"建设银行(尾号6666)",@"businessstate":@"处理中",@"orderId":@"12345678901234567123456",@"tradeSn":@"12345678901234567123456"};
        [self.dataSourceArray insertObject:dict atIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    insertAction.backgroundColor = [UIColor grayColor];
    //    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"更多" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    ////        DetailViewController *detailVC = [[DetailViewController alloc]init];
    ////        [self.navigationController pushViewController:detailVC animated:YES];
    //
    //    }];
    UITableViewRowAction *moveRowAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"移动" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //1.更新数据
        [self.dataSourceArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        //2.更新UI
        NSIndexPath *firstIndexPath =[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    }];
    //背景特效
    //moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)]；
    //----------收藏
    //    UITableViewRowAction *collectRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"收藏" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
    //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"收藏" message:@"收藏成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //
    //        [alertView show];
    //    }];
    //    //收藏按钮颜色
    //    collectRowAction.backgroundColor = [UIColor greenColor];
    
    //将设置好的按钮方到数组中返回
    return @[deleteAction,topRowAction,moveRowAction,insertAction];
    // return @[deleteAction,topRowAction,collectRowAction];
}
/**
 编辑模式下完成编辑响应的代理方法 可以通过editingStyle判断是那种编辑模式
 */
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    // 从数据源中删除
//    [self.dataSourceArray removeObjectAtIndex:indexPath.row];
//    // 从列表中删除
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}

#pragma mark - getter method
- (UITableView *)baseTableView {
    if (!_baseTableView) {
        _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _baseTableView.backgroundColor = KBackgroundColor;
        _baseTableView.showsVerticalScrollIndicator = NO;
        _baseTableView.showsHorizontalScrollIndicator = NO;
        _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _baseTableView.delegate = self;
        _baseTableView.dataSource = self;
        _baseTableView.backgroundView = self.norecordView;
        [_baseTableView registerClass:[HDTestTableViewCell class] forCellReuseIdentifier:reuseIdentifierID];
    }
    return _baseTableView;
}
- (HDNorecordView *)norecordView {
    if (!_norecordView) {
        _norecordView = [[HDNorecordView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) andNorecordTitle:@"数据正在加载中..." norecordImageName:@"OrderFromNoResult"];
    }
    return _norecordView;
}
- (NSArray *)fakeDataArray {
    if (!_fakeDataArray) {
        _fakeDataArray = @[@{@"withdrawalType":@"微信支付",@"withdrawalTime":@"2017-05-04 12:12:22",@"withdrawalAmount":@"200.00元",@"withdrawalFee":@"2.00元",@"arrivalAmount":@"198.00元",@"bankCard":@"建设银行(尾号6666)",@"businessstate":@"处理中",@"orderId":@"12345678901234567123456",@"tradeSn":@"12345678901234567123456"},@{@"withdrawalType":@"刷卡消费",@"withdrawalTime":@"2017-05-04 12:12:22",@"withdrawalAmount":@"200.00元",@"withdrawalFee":@"2.00元",@"arrivalAmount":@"198.00元",@"bankCard":@"建设银行(尾号6666)",@"businessstate":@"交易成功",@"orderId":@"12345678901234567123456",@"tradeSn":@"12345678901234567123456"}];
    }
    return _fakeDataArray;
}
- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
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
