//
//  HDTestCollectionViewController.m
//  HDTestSomething
//
//  Created by yscompany on 2017/5/22.
//  Copyright © 2017年 yscompany. All rights reserved.
//

#import "HDTestCollectionViewController.h"
#import "HDTestCollectionViewCell.h"

static NSString * HDTestCollectionViewCellID = @"HDTestCollectionViewCell";
static NSString * HDTestCollectionHeadViewID = @"HDTestCollectionHeadViewID";

@interface HDTestCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *imageDatasArray;
@property (nonatomic, assign) CGPoint lastPressPoint;
@property (nonatomic, strong) NSMutableArray *cellAttributeArray;
@property (nonatomic, assign) BOOL isBeginEidit;
@end

@implementation HDTestCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collection];
    self.lastPressPoint = CGPointZero;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(startEiditSelectImages)];
    // Do any additional setup after loading the view.
}

#pragma mark - button action
- (void)startEiditSelectImages {
    self.isBeginEidit = YES;
    NSLog(@"-------开始编辑--------");
    [self.collection reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finshSelectImages)];
}
- (void)finshSelectImages {
    self.isBeginEidit = NO;
    NSLog(@"-------开始编辑--------");
    [self.collection reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(startEiditSelectImages)];
}
#pragma mark - collectionViewDelegate dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageDatasArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HDTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HDTestCollectionViewCellID forIndexPath:indexPath];
//    [cell setImageName:[self.imageDatasArray objectAtIndex:indexPath.row]];
    if (self.isBeginEidit) {
        [cell setImageStateDict:[self.imageDatasArray objectAtIndex:indexPath.row]];
    }else {
        [cell setImageName:[self.imageDatasArray objectAtIndex:indexPath.row]];
    }
    if (indexPath.section == 0) {
        cell.panPressStyle = ^(UIPanGestureRecognizer *panPress) {
            if (!self.isBeginEidit) {
                return;
            }
            HDTestCollectionViewCell *cell = (HDTestCollectionViewCell *)panPress.view;
            NSIndexPath *cellIndexPath = [_collection indexPathForCell:cell];
            [_collection bringSubviewToFront:cell];
            BOOL isChanged = NO;
            if (panPress.state == UIGestureRecognizerStateBegan) {
                [self.cellAttributeArray removeAllObjects];
                for (int i = 0;i< self.imageDatasArray.count; i++) {
                    [self.cellAttributeArray addObject:[_collection layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]]];
                }
                self.lastPressPoint = [panPress locationInView:_collection];
            }else if (panPress.state == UIGestureRecognizerStateChanged){
                cell.center = [panPress locationInView:_collection];
                for (UICollectionViewLayoutAttributes *attributes in self.cellAttributeArray) {
                    if (CGRectContainsPoint(attributes.frame, cell.center) && cellIndexPath != attributes.indexPath) {
                        isChanged = YES;
                        //对数组中存放的元素重新排序
                        NSString *imageStr = self.imageDatasArray[cellIndexPath.row];
                        [self.imageDatasArray removeObjectAtIndex:cellIndexPath.row];
                        [self.imageDatasArray insertObject:imageStr atIndex:attributes.indexPath.row];
                        [self.collection moveItemAtIndexPath:cellIndexPath toIndexPath:attributes.indexPath];
                        
                        
                    }
                }
                
            }else if (panPress.state == UIGestureRecognizerStateEnded) {
                if (!isChanged) {
                    cell.center = [collectionView layoutAttributesForItemAtIndexPath:cellIndexPath].center;
                }
                NSLog(@"排序后---%@",self.imageDatasArray);
            }
        };
        cell.longPressStyle = ^(UILongPressGestureRecognizer *longPress) {
            if (self.isBeginEidit) {
                return;
            }
            if (longPress.state == UIGestureRecognizerStateBegan) {
                self.isBeginEidit = YES;
                [self.collection reloadData];
            }
        };
    }
    return cell;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGFloat margin = 12;
//    CGFloat itemWH = (kScreenW - 2 * margin)/4;
//    
//   return CGSizeMake(itemWH, itemWH);
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 10;
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 12;
//}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusable = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HDTestCollectionHeadViewID forIndexPath:indexPath];
        reusable.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:reusable.bounds];
        label.backgroundColor = [UIColor grayColor];
        label.text = @"就是个测试";
        label.textColor = [UIColor whiteColor];
        [reusable addSubview:label];
    }
    return reusable;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenW, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"you had click the collectioncell at indexpath.section = %lu,indexpath.row = %lu",indexPath.section,indexPath.row);
}

#pragma mark - getter method
- (UICollectionView *)collection {
    if (!_collection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat margin = 8;
        CGFloat itemWH = (kScreenW - 3 * margin)/4;
        layout.itemSize =CGSizeMake(itemWH, itemWH);
        layout.minimumLineSpacing = margin; // 垂直 列
        layout.minimumInteritemSpacing = margin; //水平 行
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.showsVerticalScrollIndicator = NO;
        _collection.showsHorizontalScrollIndicator = NO;
        [_collection registerClass:[HDTestCollectionViewCell class] forCellWithReuseIdentifier:HDTestCollectionViewCellID];
        [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HDTestCollectionHeadViewID];
        
    }
    return _collection;
}
- (NSMutableArray *)imageDatasArray {
    if (!_imageDatasArray) {
        NSArray *array = @[@{@"imageName":@"1",@"state":@"."},@{@"imageName":@"2",@"state":@"-"},@{@"imageName":@"3",@"state":@"-"},@{@"imageName":@"4",@"state":@"."},@{@"imageName":@"5",@"state":@"+"},@{@"imageName":@"6",@"state":@"+"},@{@"imageName":@"7",@"state":@"-"},@{@"imageName":@"8",@"state":@"+"},@{@"imageName":@"9",@"state":@"."}];
        _imageDatasArray = [NSMutableArray arrayWithArray:array];
    }
    return _imageDatasArray;
}
- (NSMutableArray *)cellAttributeArray {
    if (!_cellAttributeArray) {
        _cellAttributeArray = [NSMutableArray array];
    }
    return _cellAttributeArray;
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
