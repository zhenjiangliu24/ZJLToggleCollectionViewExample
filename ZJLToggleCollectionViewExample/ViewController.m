//
//  ViewController.m
//  ZJLToggleCollectionViewExample
//
//  Created by ZhongZhongzhong on 16/6/13.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ViewController.h"
#import "ZJLCityCollectionViewCell.h"
#import "ZJLProvinceCollectionReusableView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, copy) NSArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *stateArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZJLCityCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"city_cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZJLProvinceCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"province_cell"];
    [self.view addSubview:self.collectionView];
    [self dataInitialize];
}

- (void)dataInitialize
{
    self.sectionArray = [NSArray arrayWithObjects:@"Quebec",@"Ontario",@"Alberta",@"British Columbia",@"Manitoba", nil];
    NSArray *quebec = [NSArray arrayWithObjects:@"Montreal",@"Quebec City", nil];
    NSArray *ontario = [NSArray arrayWithObjects:@"Toronto",@"Kingston",@"Ottawa",@"Waterloo", nil];
    NSArray *alberta = [NSArray arrayWithObjects:@"Calgary",@"Brooks",@"Edmonton",@"Cold Lake", nil];
    NSArray *british = [NSArray arrayWithObjects:@"Victoria",@"Vancouver",@"Richmond", nil];
    NSArray *manitoba = [NSArray arrayWithObjects:@"Winnipeg",@"Brandon",@"Mordon",@"Thompson", nil];
    self.data = [NSArray arrayWithObjects:quebec,ontario,alberta,british,manitoba, nil];
    self.stateArray = [NSMutableArray arrayWithObjects:@NO,@NO,@NO,@NO,@NO, nil];
}

#pragma mark - collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.stateArray[section] boolValue]) {
        return [self.data[section] count];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJLCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"city_cell" forIndexPath:indexPath];
    NSArray *temp = self.data[indexPath.section];
    cell.cityLabel.text = temp[indexPath.row];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ZJLProvinceCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"province_cell" forIndexPath:indexPath];
    header.provinceLabel.text = self.sectionArray[indexPath.section];
    header.tag = indexPath.section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTap:)];
    [header addGestureRecognizer:tap];
    if ([self.stateArray[indexPath.section] boolValue]) {
        header.arrowImageView.image = [UIImage imageNamed:@"arrow_show"];
    }else{
        header.arrowImageView.image = [UIImage imageNamed:@"arrow_hide"];
    }
    return header;
}

#pragma mark - collection view flow layout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth)/4,(ScreenWidth)/4);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (void)headerTap:(UITapGestureRecognizer *)tap
{
    if ([self.stateArray[tap.view.tag] boolValue]) {
        [self.stateArray replaceObjectAtIndex:tap.view.tag withObject:[NSNumber numberWithBool:NO]];
    }else{
        [self.stateArray replaceObjectAtIndex:tap.view.tag withObject:[NSNumber numberWithBool:YES]];
    }
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
