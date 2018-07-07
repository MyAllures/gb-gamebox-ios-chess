//
//  SH_RechargeCenterViewController.m
//  GameBox
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeCenterViewController.h"
#import "SH_DepositeWayCollectionViewCell.h"
#import "SH_DespositePlatformCollectionViewCell.h"
#import "SH_DespositeChooseMoneyCollectionViewCell.h"

@interface SH_RechargeCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation SH_RechargeCenterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self loadData];
    [self configUI];
}
- (UIInterfaceOrientationMask)orientation
{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark--
#pragma mark--lazy UI
- (UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLaout = [[UICollectionViewFlowLayout alloc]init];
        flowLaout.minimumLineSpacing = 10;
        flowLaout.minimumInteritemSpacing = 10;
        flowLaout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLaout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        [self.view addSubview:_mainCollectionView];
    }
    return _mainCollectionView;
}
-(void)loadData{
    
}
-(void)configUI{
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SH_DepositeWayCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SH_DepositeWayCollectionViewCell"];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SH_DespositePlatformCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SH_DespositePlatformCollectionViewCell"];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SH_DespositeChooseMoneyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SH_DespositeChooseMoneyCollectionViewCell"];
    
}
#pragma mark--
#pragma mark--collectionViewDelegate,datasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId ;
    if (indexPath.section == 0) {
        cellId = @"SH_DespositePlatformCollectionViewCell";
    }else if(indexPath.section == 1){
        cellId = @"SH_DepositeWayCollectionViewCell";
    }else{
        cellId = @"SH_DespositeChooseMoneyCollectionViewCell";
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((self.view.frame.size.width - 6 * 10)/5.0, 70);
    }else if (indexPath.section == 1){
        return CGSizeMake((self.view.frame.size.width - 3 * 15)/5.0, 70);
    }else{
        return CGSizeMake((self.view.frame.size.width - 6 * 10)/5.0, (self.view.frame.size.width - 6 * 10)/5.0);
    }
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
