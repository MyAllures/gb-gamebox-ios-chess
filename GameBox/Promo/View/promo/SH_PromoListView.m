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

@interface SH_PromoListView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *promoListArr;

@end

@implementation SH_PromoListView

-(void)awakeFromNib {
    [super awakeFromNib];
    [SH_NetWorkService_Promo getPromoList:1 pageSize:50 activityClassifyKey:@"全部" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        self.promoListArr = [NSMutableArray array];
        SH_PromoListModel *model;
        NSDictionary *dic = (NSDictionary *)response;
        for (NSDictionary *dict in dic[@"data"][@"list"]) {
            [self.promoListArr addObject:[model initWithDict:dict]];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

- (void)reloadData
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_PromoViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.promoListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_PromoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoViewCell" owner:nil options:nil] lastObject];
    }
    SH_PromoListModel *model = self.promoListArr[indexPath.row];
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[NetWorkLineMangaer sharedManager].currentPreUrl,model.mPhoto]]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
