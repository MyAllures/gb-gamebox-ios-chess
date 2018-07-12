//
//  SH_GameAnnouncementView.m
//  GameBox
//
//  Created by sam on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GameAnnouncementView.h"
#import <Masonry/Masonry.h>
#import "SH_GameBulletinTCell.h"
#import "SH_NetWorkService+Promo.h"
#import "SH_GameBulletinModel.h"
#import "AppDelegate.h"
#import "PGDatePicker.h"
#import "PGDatePickManager.h"
@interface SH_GameAnnouncementView ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *gameAnnouncementArr;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@end

@implementation SH_GameAnnouncementView

- (IBAction)startTimeAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"seleteDate" object:nil];
}
- (IBAction)endTimeAction:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"end",@"isEnd", nil];
    NSNotification *notification = [NSNotification notificationWithName:@"seleteEndTime" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(void)changedDate:(NSNotification *)nt {
    [self.startTimeBtn setTitle:nt.userInfo[@"date"] forState:UIControlStateNormal];
}

-(void)seletedEndDate:(NSNotification *)nt {
    [self.endTimeBtn setTitle:nt.userInfo[@"date"] forState:UIControlStateNormal];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedDate:) name:@"seletedDate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seletedEndDate:) name:@"seletedEndDate" object:nil];
//    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    self.gameAnnouncementArr = [NSMutableArray array];
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdelegate.isLogin) {
        [SH_NetWorkService_Promo startLoadGameNoticeStartTime:@"" endTime:@"" pageNumber:1 pageSize:2 apiId:-1 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dic = (NSDictionary *)response;
            NSLog(@"dic===%@",dic);
            for (NSDictionary *dict in dic[@"data"][@"list"]) {
                NSError *err;
                SH_GameBulletinModel *model = [[SH_GameBulletinModel alloc] initWithDictionary:dict error:&err];
                [self.gameAnnouncementArr addObject:model];
            }
            [self.tableView reloadData];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_GameBulletinTCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
    
//    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
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
    return self.gameAnnouncementArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_GameBulletinTCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_GameBulletinTCell" owner:nil options:nil] lastObject];
    }
    SH_GameBulletinModel *model = self.gameAnnouncementArr[indexPath.row];

    cell.publishTimeLabel.text = [self timeStampWithDate:model.publishTime];
    cell.contentLabel.text = model.context;
    cell.gameNameLabel.text = model.gameName;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"seletedDate" object:nil];
}

@end
