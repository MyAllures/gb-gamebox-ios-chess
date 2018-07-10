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

@interface SH_PromoListView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SH_PromoListView


- (void)getPromoList:(NSInteger )pageNumber pageSize:(NSInteger )pageSize activityClassifyKey:(NSString *)activityClassifyKey complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/discountsOrigin/getActivityTypeList.html"];
    NSDictionary *parameter =  @{@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize),@"search.activityClassifyKey":activityClassifyKey};
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentSID};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self getPromoList:1 pageSize:50 activityClassifyKey:@"全部"  complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict====%@",dict);
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_PromoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
