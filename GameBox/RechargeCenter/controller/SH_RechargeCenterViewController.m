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
#import "DepositeHeadCollectionReusableView.h"
#import "RH_RechargeCenterFooterView.h"
#import "SH_NetWorkService+RechargeCenter.h"
#import "SH_RechargeCenterPlatformModel.h"
@interface SH_RechargeCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UILabel *tipLab;
@property(nonatomic,strong)NSArray *sectionTitles;//头部标题的数据
@end

@implementation SH_RechargeCenterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillshow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardDidHideNotification object:nil];
    [self loadData];
    [self configUI];
}
-(UIInterfaceOrientationMask)orientation{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark--
#pragma mark--lazy UI
- (UICollectionView *)mainCollectionView{
    if (!_mainCollectionView) {
        UICollectionViewFlowLayout *flowLaout = [[UICollectionViewFlowLayout alloc]init];
        flowLaout.minimumLineSpacing = 10;
        flowLaout.minimumInteritemSpacing = 10;
        _mainCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLaout];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
        _mainCollectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_mainCollectionView];
    }
    return _mainCollectionView;
}
- (UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = [[UILabel alloc]init];
        _tipLab.backgroundColor = [UIColor yellowColor];
        _tipLab.text = @"温馨提示:完成存款后，请前往活动大厅申请活动优惠";
        _tipLab.font = [UIFont systemFontOfSize:14];
        _tipLab.textColor = [UIColor grayColor];
         [self.view addSubview:_tipLab];
    }
    return _tipLab;
}
-(void)loadData{
    self.sectionTitles = @[@"",@"付款方式",@"请选择或输入金额"];
    [SH_NetWorkService RechargeCenterComplete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dic = response;
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
-(void)configUI{
   
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SH_DepositeWayCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SH_DepositeWayCollectionViewCell"];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SH_DespositePlatformCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SH_DespositePlatformCollectionViewCell"];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"SH_DespositeChooseMoneyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SH_DespositeChooseMoneyCollectionViewCell"];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"DepositeHeadCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DepositeHeadCollectionReusableView"];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"RH_RechargeCenterFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RH_RechargeCenterFooterView"];
    //添加footerView
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
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(0, 15, 0, 15);
    }else{
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1){
        
    }else{
        
    }
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((self.view.frame.size.width - 6 * 10)/5.0, 70);
    }else if (indexPath.section == 1){
        return CGSizeMake((self.view.frame.size.width - 3 * 15)/2.0, 40);
    }else{
        return CGSizeMake((self.view.frame.size.width - 6 * 10)/5.0, (self.view.frame.size.width - 6 * 10)/5.0);
    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
         // 复用SectionHeaderView,SectionHeaderView是xib创建的
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        DepositeHeadCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DepositeHeadCollectionReusableView" forIndexPath:indexPath];
        [headerView updateWithTitle:self.sectionTitles[indexPath.section]];
        return headerView;
    }else{
        RH_RechargeCenterFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"RH_RechargeCenterFooterView" forIndexPath:indexPath];
        return footerView;
    }
    
}

 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
     if (section == 0) {
         return CGSizeMake(0, 0);
     }else{
         return CGSizeMake(self.view.frame.size.width, 30);
     }
     
     }
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        return CGSizeMake(self.view.frame.size.width, 300);
    }else{
        return CGSizeMake(0, 0);
    }
    
}
#pragma mark--
#pragma mark--keyboard
-(void)keyboardWillshow:(NSNotification *)notify{
     CGRect keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]; //获得键盘的rect
      CGFloat duration = [[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
      __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.mainCollectionView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - keyboardFrame.size.height - 20);
    });
}
-(void)keyboardWillHidden:(NSNotification *)notify{
   self.mainCollectionView.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
