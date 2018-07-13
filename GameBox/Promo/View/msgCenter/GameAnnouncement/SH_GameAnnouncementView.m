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
#import "RH_UserInfoManager.h"
#import "PGDatePicker.h"
#import "PGDatePickManager.h"
#import "PGPickerView.h"
@interface SH_GameAnnouncementView ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *gameAnnouncementArr;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;
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
    self.startTimeStr = nt.userInfo[@"date"];
    if (!self.endTimeStr) {
        self.endTimeStr = [self getCurrentTimes];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:self.startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];
    if (startDate > endDate) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
        return;
    }
    [self.gameAnnouncementArr removeAllObjects];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [SH_NetWorkService_Promo startLoadGameNoticeStartTime:self.startTimeStr endTime:self.endTimeStr pageNumber:1 pageSize:50000 apiId:-1 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
}

-(void)seletedEndDate:(NSNotification *)nt {
    [self.endTimeBtn setTitle:nt.userInfo[@"date"] forState:UIControlStateNormal];
    self.endTimeStr = nt.userInfo[@"date"];
    if (!self.startTimeStr) {
        self.startTimeStr = [self getCurrentTimes];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:self.startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];
    if (startDate > endDate) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
        return;
    }
    [self.gameAnnouncementArr removeAllObjects];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [SH_NetWorkService_Promo startLoadGameNoticeStartTime:[self getCurrentTimes] endTime:self.endTimeStr pageNumber:1 pageSize:50000 apiId:-1 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
}

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
    
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedDate:) name:@"seletedDate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seletedEndDate:) name:@"seletedEndDate" object:nil];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    [self.startTimeBtn setTitle:[self getCurrentTimes] forState:UIControlStateNormal];
    [self.endTimeBtn setTitle:[self getCurrentTimes] forState:UIControlStateNormal];
    self.gameAnnouncementArr = [NSMutableArray array];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [SH_NetWorkService_Promo startLoadGameNoticeStartTime:[self getCurrentTimes] endTime:[self getCurrentTimes] pageNumber:1 pageSize:20 apiId:-1 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {

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
    if (self.gameAnnouncementArr.count > 0) {
        SH_GameBulletinModel *model = self.gameAnnouncementArr[indexPath.row];
        
        cell.publishTimeLabel.text = [self timeStampWithDate:model.publishTime];
        cell.contentLabel.text = model.context;
        cell.gameNameLabel.text = model.gameName;
    }
    
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
