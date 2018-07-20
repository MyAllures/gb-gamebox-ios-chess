//
//  SH_PromoListView.m
//  GameBox
//
//  Created by shin on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoListView.h"
#import "SH_PromoViewCell.h"
#import "View+MASAdditions.h"
#import "SH_NetWorkService.h"
#import "NetWorkLineMangaer.h"
#import "PopTool.h"
#import "SH_PromoListModel.h"
#import "SH_NetWorkService+Promo.h"
#import <SDWebImage/SDWebImageFrame.h>
#import "SH_PromoDeatilViewController.h"

@interface SH_PromoListView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *promoListArr;

@end

@implementation SH_PromoListView

- (void)reloadData
{
    __weak typeof(self) weakSelf = self;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_PromoViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [SH_NetWorkService_Promo getPromoList:1 pageSize:5000 activityClassifyKey:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        weakSelf.promoListArr = [NSMutableArray array];
        NSDictionary *dic = (NSDictionary *)response;
        for (NSDictionary *dict in dic[@"data"][@"list"]) {
            SH_PromoListModel *model = [[SH_PromoListModel alloc]initWithDictionary:dict error:nil];
            [weakSelf.promoListArr addObject:model];
            [weakSelf.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];

}

#pragma mark - UITableViewDataSource M

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.promoListArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_PromoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoViewCell" owner:nil options:nil] lastObject];
    }
    SH_PromoListModel *model = self.promoListArr[indexPath.section];
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageAllowInvalidSSLCertificates];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat with = self.frame.size.width-2*2;
    CGFloat height = with*(75.0/320.0);
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor clearColor];
    return header;
}

#pragma mark - UITableViewDelegate M

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ifRespondsSelector(self.delegate, @selector(promoListView:didSelect:))
    {
        SH_PromoListModel *model = self.promoListArr[indexPath.section];
        [self.delegate promoListView:self didSelect:model];
    }
    
    SH_PromoListModel *model = self.promoListArr[indexPath.section];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SH_Show_PromoDeatil" object:model];
}

@end
