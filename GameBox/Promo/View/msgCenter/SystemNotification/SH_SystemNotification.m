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
#import "RH_UserInfoManager.h"
@interface SH_SystemNotification () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIButton *quickSeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (strong, nonatomic) NSMutableArray *gameBulletinArr;
@property (strong, nonatomic) NSMutableArray *quickSeleteArr;

@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;

@property (strong, nonatomic) UIPickerView *pickView;

@end

@implementation SH_SystemNotification
@synthesize pickView = _pickView;

-(UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (IBAction)startTimeAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"seleteDate" object:nil];
}
- (IBAction)endTimeAction:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"end",@"isEnd", nil];
    NSNotification *notification = [NSNotification notificationWithName:@"seleteEndTime" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)quickSeleteAction:(id)sender {
    self.pickView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    [self addSubview:self.pickView];
    [_pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.frame.size.height-150);
    }];
}


-(void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedDate:) name:@"seletedDate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seletedEndDate:) name:@"seletedEndDate" object:nil];
//    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.startTimeBtn setTitle:[self getCurrentTimes] forState:UIControlStateNormal];
    [self.endTimeBtn setTitle:[self getCurrentTimes] forState:UIControlStateNormal];
//    self.quickSeleteBtn.backgroundColor = [UIColor blueColor];
//    self.quickSeleteBtn.layer.cornerRadius = 5;
//    self.quickSeleteBtn.clipsToBounds = YES;
    self.gameBulletinArr = [NSMutableArray array];
    self.quickSeleteArr = [NSMutableArray array];
    NSArray *arr = @[@"今天",@"昨天",@"本周",@"上周",@"本月"];
    self.quickSeleteArr = [NSMutableArray arrayWithArray:arr];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:[self getCurrentTimes] endTime:[self getCurrentTimes] pageNumber:1 pageSize:500 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_GameBulletinTCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
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
    [self.gameBulletinArr removeAllObjects];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:self.startTimeStr endTime:self.endTimeStr pageNumber:1 pageSize:50000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
    [self.gameBulletinArr removeAllObjects];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:self.startTimeStr endTime:self.endTimeStr pageNumber:1 pageSize:50000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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

#pragma mark -UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.quickSeleteArr.count;
}

#pragma mark -
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    return [self.quickSeleteArr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    
}

@end
