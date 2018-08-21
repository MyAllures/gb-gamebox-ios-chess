//
//  SH_PromoActivitiesView.m
//  GameBox
//
//  Created by jun on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoActivitiesView.h"
#import "SH_LeftTableViewCell.h"
#import "SH_TopCollectionViewCell.h"
#import "SH_PromoDetailView.h"
#import "SH_NetWorkService+PromoActivities.h"
#import "SH_PromoModel.h"
#import "SH_NodataView.h"
@interface SH_PromoActivitiesView()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *topCollectionView;
@property(nonatomic,strong)SH_PromoDetailView *detailView;
@property(nonatomic,strong)NSArray *topDatas;
@property(nonatomic,strong)NSMutableArray *leftDatas;
@property(nonatomic,strong)NSMutableArray *topSelectedArray;
@property(nonatomic,strong)NSMutableArray *leftSelectedArray;
@end
@implementation SH_PromoActivitiesView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.topSelectedArray = [NSMutableArray array];
    self.leftDatas = [NSMutableArray array];
    self.leftSelectedArray = [NSMutableArray array];
   [self loadData];
    [self configUI];
    
}

-(void)loadData{
   
    [SH_NetWorkService getActivityTypesSucess:^(NSArray *datas) {
        if (datas.count > 0) {
            self.topDatas = datas;
            for (int i = 0; i < datas.count; i++) {
                if (i == 0) {
                    [self.topSelectedArray addObject:@"1"];
                }else{
                    [self.topSelectedArray addObject:@"0"];
                }
            }
            //默认显示第一个
            [self selectTopIndex:0];
            [self.topCollectionView reloadData];
        }else{
            [SH_NodataView showAddTo:self Message:@"当前没有活动可参与"];
        }
      

    } Failure:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        [SH_NodataView showAddTo:self Message:err];
    }];
}
-(void)configUI{
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    [self.leftTableView registerNib:[UINib nibWithNibName:@"SH_LeftTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_LeftTableViewCell"];
    
    self.topCollectionView.delegate = self;
    self.topCollectionView.dataSource = self;
    [self.topCollectionView registerNib:[UINib nibWithNibName:@"SH_TopCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SH_TopCollectionViewCell"];

    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(40);
        make.left.equalTo(self).offset(135*screenSize().width/375.0);
        make.bottom.equalTo(self);
        make.width.equalTo(@(350*screenSize().width/375.0));
    }];
}
#pragma mark--
#pragma mark--lazy
- (SH_PromoDetailView *)detailView{
    if (!_detailView) {
        _detailView = [[NSBundle mainBundle]loadNibNamed:@"SH_PromoDetailView" owner:self options:nil].firstObject;
        [self addSubview:_detailView];
    }
    return _detailView;
}

#pragma mark--
#pragma mark--tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leftDatas.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_LeftTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateUIWithPromoSubModel:self.leftDatas[indexPath.row] SelectedStatus:self.leftSelectedArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.leftSelectedArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:[self.leftSelectedArray indexOfObject:@"1"]];
    [self selectLeftIndex:indexPath.row];
    [self.leftTableView reloadData];
}
#pragma mark--
#pragma mark--collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.topDatas.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SH_TopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SH_TopCollectionViewCell" forIndexPath:indexPath];
    [cell updateUIWithPromoModel:self.topDatas[indexPath.row] SelectedStatus:self.topSelectedArray[indexPath.row]];
    return cell;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
        return UIEdgeInsetsMake(5, 0, 5, 0);

}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 30);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.topSelectedArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:[self.topSelectedArray indexOfObject:@"1"]];
    [self selectTopIndex:indexPath.row];
    [self.topCollectionView reloadData];
}
//选中Top部分
-(void)selectTopIndex:(NSInteger)index{
    SH_PromoModel *model = self.topDatas[index];
    [self.leftDatas removeAllObjects];
    [self.leftSelectedArray removeAllObjects];
    [self.leftDatas addObjectsFromArray:model.activityList];
    for (int i = 0; i < self.leftDatas.count; i++) {
        if (i == 0) {
            [self.leftSelectedArray addObject:@"1"];
        }else{
            [self.leftSelectedArray addObject:@"0"];
        }
    }
    [self.leftTableView reloadData];
    //左侧默认第一个
    [self selectLeftIndex:0];
}
//选中left部分
-(void)selectLeftIndex:(NSInteger)index{
    SH_PromoSubModel *model1 = self.leftDatas[index];
    [self getPromoDetailProId:model1.searchId Name:model1.name ImageUrl:model1.photo  Date:model1.time];
}
-(void)getPromoDetailProId:(NSString *)proId Name:(NSString *)name ImageUrl:(NSString *)imageUrl Date:(NSString *)date{
   
    [SH_NetWorkService getPromoActivitiesDetailPromoId:proId Sucess:^(SH_PromoDetailModel *model) {
        [self.detailView updateWithModel:model Name:name ImageUrl:imageUrl Date:date];
    } Failure:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
@end
