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
#import "SH_RechargeCenterPaywayModel.h"
#import "SH_RechargeCenterChannelModel.h"
#import "SH_RechargeCenterBasicCollectionViewCell.h"
#import "SH_RechargeCenterDataHandle.h" //处理cell选中状态
#import "SH_BitCoinViewController.h"
#import "SH_RechargeDetailViewController.h"
#import "SH_RechargeBankDetailViewController.h"
#import "SH_KuaiChongViewController.h"
@interface SH_RechargeCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,RH_RechargeCenterFooterViewDelegate>
@property(nonatomic,strong)UICollectionView *mainCollectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UILabel *tipLab;
@property(nonatomic,strong)NSArray *sectionTitles;//头部标题的数据
@property(nonatomic,strong)NSMutableArray *selectedStatusArray;
@property(nonatomic,strong)NSMutableDictionary *platformDic;//记录当前选中哪个平台
@property(nonatomic,copy)NSString *number;//选中金额
@property(nonatomic,strong)SH_RechargeCenterPlatformModel *platformModel;//记录当前选中哪一个平台，方便传值
@property(nonatomic,strong)SH_RechargeCenterChannelModel *channelModel;//选中付款方式后要把这个数据传到跳转的页面
@end

@implementation SH_RechargeCenterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationWithTitle:@"充值中心"];
    [self loadData];
    [self configUI];
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
    self.platformDic = [[NSMutableDictionary alloc]init];
    self.dataArray = [NSMutableArray array];
    self.selectedStatusArray = [NSMutableArray array];
    self.sectionTitles = @[@"",@"付款方式",@"请选择或输入金额"];
      __weak typeof(self) weakSelf = self;
    [SH_NetWorkService RechargeCenterComplete:^(NSArray *array) {
        NSArray *platforms= array;
        [weakSelf.dataArray addObject:platforms?platforms:[NSArray array]];
        if (platforms.count > 0) {
            weakSelf.platformModel = platforms[0];
            //添加第一组cell选择状态
            NSMutableArray *sectionOneArray = [NSMutableArray array];
            for (int i = 0; i < platforms.count; i++) {
                if (i == 0) {
                    [sectionOneArray addObject:@"selected"];
                }else{
                    [sectionOneArray addObject:@"unSelected"];
                }
            }
            [weakSelf.selectedStatusArray addObject:sectionOneArray];
            SH_RechargeCenterPlatformModel *platformModel = platforms[0];
            //请求默认的第一个
            [weakSelf.platformDic setObject:platformModel.code forKey:@"code"] ;
           
            [SH_NetWorkService RechargeCenterPayway:platformModel.code Complete:^(SH_RechargeCenterPaywayModel *model) {
                SH_RechargeCenterPaywayModel *paywayModel = model;
                NSArray *payways = paywayModel.arrayList;
                NSArray *moneys = paywayModel.quickMoneys;
                if (payways.count > 0) {
                    weakSelf.channelModel = payways[0];
                     [weakSelf.platformDic setObject:self.channelModel.type forKey:@"type"] ;
                }
                NSMutableArray *sectionTwoArray = [NSMutableArray array];
                for (int i = 0; i < payways.count; i++) {
                    [sectionTwoArray addObject:@"unSelected"];
                }
                NSMutableArray *sectionThreeArray = [NSMutableArray array];
                NSMutableArray *chooseMoneyArray =  [NSMutableArray array];
                for (int i = 0; i < moneys.count; i++) {
                    [sectionThreeArray addObject:@"unSelected"];
                    //图片名称数组
                    NSArray *picNameArray = @[@"chip_blue",@"chip_red",@"chip_yellow",@"chip_green",@"chip_black"];
                    if (moneys.count == picNameArray.count) {
                            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                            [dic setObject:moneys[i] forKey:@"num"];
                            [dic setObject:picNameArray[i] forKey:@"imageName"];
                            [chooseMoneyArray addObject:dic];
                    }
                }
                [weakSelf.selectedStatusArray addObject:sectionTwoArray];
                [weakSelf.selectedStatusArray addObject:sectionThreeArray];
                [weakSelf.dataArray addObject:payways?payways:[NSArray array]];
                [weakSelf.dataArray addObject:chooseMoneyArray?chooseMoneyArray:[NSArray array]];
                [weakSelf.mainCollectionView reloadData];
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
            
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
-(void)configUI{
     __weak typeof(self) weakSelf = self;
    [self.tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@20);
        make.top.equalTo(self.view).offset(NavigationBarHeight);
    }];
    [self.mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(weakSelf.tipLab.mas_bottom);
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
    if ([self.platformModel.name isEqualToString:@"快充中心"]||[self.platformModel.code isEqualToString:@"bitcoin"]) {
        return 1;
    }else{
        
        return self.dataArray.count;
        
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId ;
    if (indexPath.section == 0) {
        cellId = @"SH_DespositePlatformCollectionViewCell";
    }else if(indexPath.section == 1){
        //因为在线支付只会返回2组 所以要特殊处理
        if ([self.channelModel.type isEqualToString:@"2"]&&[self.channelModel.accountType isEqualToString:@"2"]) {
            cellId = @"SH_DespositeChooseMoneyCollectionViewCell";
        }else{
            cellId = @"SH_DepositeWayCollectionViewCell";
        }
       
    }else if(indexPath.section == 2){
        cellId = @"SH_DespositeChooseMoneyCollectionViewCell";
    }
    SH_RechargeCenterBasicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell updateUIWithContex:self.dataArray[indexPath.section][indexPath.row] Selected:self.selectedStatusArray[indexPath.section][indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //处理cell选中状态
    if (indexPath.section == 2) {
            self.number = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.section][indexPath.row][@"num"]];
            [collectionView reloadData];

    }else{
        if (indexPath.section == 0) {
            self.platformModel = self.dataArray[indexPath.section][indexPath.row];//选中哪一个平台就记录下来
            if ([self.platformModel.name isEqualToString:@"快充中心"]) {
                //这里用name判断是因为快充中心的code是一个路径 所以不能走下面的处理方法
                SH_KuaiChongViewController *vc = [[SH_KuaiChongViewController alloc]init];
                vc.platformModel = self.platformModel;
                [self presentViewController:vc animated:YES completion:nil];
            }
        }
          __weak typeof(self) weakSelf = self;
        [SH_RechargeCenterDataHandle dealSelectedStatusWithSlectedArray:self.selectedStatusArray indexPath:indexPath DataArray:self.dataArray CollectionView:collectionView Platform:self.platformDic Block:^(SH_RechargeCenterChannelModel *model) {
            weakSelf.channelModel = model;
            if (indexPath.section == 0) {
                if ([self.platformModel.code isEqualToString:@"bitcoin"]){
                    SH_BitCoinViewController *bvc = [[SH_BitCoinViewController alloc]init];
                    bvc.channelModel = weakSelf.channelModel;
                    [weakSelf presentViewController:bvc animated:YES completion:nil];
                }
            }
        }];
    }
   
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 1) {
        return UIEdgeInsetsMake(0, 15, 10, 15);
    }else{
        return UIEdgeInsetsMake(0, 10, 20, 10);
    }
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((screenSize().width - 6 * 10.0)/5.0, 70);
    }else if (indexPath.section == 1){
        return CGSizeMake((screenSize().width - 3 * 15.0)/2.0, 40);
    }else{
        return CGSizeMake((screenSize().width - 6 * 11.0)/5.0, (screenSize().width - 6 * 10)/5.0);
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
        footerView.delegate = self;
        [footerView updateUIWithDictionary:self.platformDic Number:self.number];
        return footerView;
    }
    
}

 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
     if (section == 0) {
         return CGSizeMake(0, 0);
     }else{
         return CGSizeMake(SCREEN_WIDTH, 30);
     }
     
     }
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 500);
    }else{
        return CGSizeMake(0, 0);
    }
    
}
#pragma mark--
#pragma mark--footerView delegate
- (void)RH_RechargeCenterFooterViewSubmitBtnClick{
    [self presentViewController:[[SH_RechargeBankDetailViewController alloc]init] animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
