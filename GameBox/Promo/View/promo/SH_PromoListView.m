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
    
    [SH_NetWorkService_Promo getPromoList:1 pageSize:5000 activityClassifyKey:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        self.promoListArr = [NSMutableArray array];
        NSDictionary *dic = (NSDictionary *)response;
        for (NSDictionary *dict in dic[@"data"][@"list"]) {
            SH_PromoListModel *model = [[SH_PromoListModel alloc]initWithDictionary:dict error:nil];
            [self.promoListArr addObject:model];
            [self.tableView reloadData];
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
    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@%@",[NetWorkLineMangaer sharedManager].currentHost,model.photo]]];
    //    [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.photo]
    //                                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    //                                       if (image){
    //                                           [self.discountActivityModel updateImageSize:image.size] ;
    //                                       }
    //                                   }] ;
    NSLog(@"model.photo==%@",[NSString stringWithFormat:@"https://%@%@",[NetWorkLineMangaer sharedManager].currentHost,model.photo]);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
