//
//  SH_SystemNotification.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SystemNotification.h"
#import <Masonry/Masonry.h>
#import "SH_GameBulletinTCell.h"
#import "SH_PromoViewCell.h"
#import "SH_NetWorkService+Promo.h"
#import "SH_SystemNotificationModel.h"
@interface SH_SystemNotification () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIButton *quickSeleteBtn;

@property (strong, nonatomic) NSMutableArray *gameBulletinArr;

@end

@implementation SH_SystemNotification

-(void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
//    self.quickSeleteBtn.backgroundColor = [UIColor blueColor];
//    self.quickSeleteBtn.layer.cornerRadius = 5;
//    self.quickSeleteBtn.clipsToBounds = YES;
    self.gameBulletinArr = [NSMutableArray array];
    
    [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:@"" endTime:@"" pageNumber:1 pageSize:50 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dic = (NSDictionary *)response;
        for (NSDictionary *dict in dic[@"data"][@"list"]) {
            NSError *err;
            SH_SystemNotificationModel *model = [[SH_SystemNotificationModel alloc] initWithDictionary:dict error:&err];
            if (model) {
                [self.gameBulletinArr addObject:model];
            }
            
            [self.tableView reloadData];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_GameBulletinTCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
}

-(NSString *)timeStampWithDate: (NSInteger)timeStamp {
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =timeStamp / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gameBulletinArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_GameBulletinTCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_GameBulletinTCell" owner:nil options:nil] lastObject];
    }
    SH_SystemNotificationModel *model = self.gameBulletinArr[indexPath.row];
    cell.contentLabel.text = model.content;
    cell.publishTimeLabel.text = [self timeStampWithDate:model.publishTime];
//    cell.gameNameLabel.text = model.title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
