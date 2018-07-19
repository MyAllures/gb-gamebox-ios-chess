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
#import "SH_ApiSelectModel.h"
#import "RH_UserInfoManager.h"
#import "PGDatePicker.h"
#import "PGDatePickManager.h"
#import "HLPopTableView.h"

@interface SH_GameAnnouncementView ()<UITableViewDataSource, UITableViewDelegate,PGDatePickerDelegate>
{
    PGDatePickManager *_datePickManager;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *gameAnnouncementArr;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *gameTypeBtn;

@property (nonatomic, strong) NSMutableArray *apiNameArr;//保存游戏类型名称
@property (nonatomic, strong) NSMutableArray *apiNameModelArr;

@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;
@property(nonatomic, strong) NSString *startAndEndDateStr;
@property (assign, nonatomic) NSInteger apiId;//选择游戏类型的id
@end

@implementation SH_GameAnnouncementView

#pragma mark 开始时间选择
- (IBAction)startTimeAction:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyle1;
    datePickManager.isShadeBackgroud = true;
    
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    _datePickManager = datePickManager;
    UIWindow  * window = [UIApplication  sharedApplication].keyWindow;
    window.backgroundColor = [UIColor  yellowColor];
    [window addSubview:_datePickManager.view];
}
#pragma mark 结束时间选择
- (IBAction)endTimeAction:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"end",@"isEnd", nil];
    self.startAndEndDateStr = dict[@"isEnd"];
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyle1;
    datePickManager.isShadeBackgroud = true;
    
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    _datePickManager = datePickManager;
    [self.window addSubview:datePickManager.view];
}
#pragma mark 游戏类型
- (IBAction)tapApiName:(UIButton *)sender {
    if (![RH_UserInfoManager shareUserManager].isLogin) {
        showMessage(self, @"", @"请先登录");
        return;
    }
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width+5, 110) dependView:sender textArr:self.apiNameArr block:^(NSString *region_name, NSInteger index) {
        [self.gameTypeBtn setTitle:region_name forState:UIControlStateNormal];
        SH_ApiSelectModel *model = self.apiNameModelArr[index];
        self.apiId = model.apiId;
        if (!self.endTimeStr) {
            self.endTimeStr = [self getCurrentTimes];
        }
        if (!self.startTimeStr) {
            self.startTimeStr = [self getCurrentTimes];
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *startDate = [dateFormatter dateFromString:self.startTimeStr];
        NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];
        if (startDate > endDate) {
            showMessage(self, @"提示", @"时间选择有误,请重试选择");
            return;
        }
        [self.gameAnnouncementArr removeAllObjects];
        if ([RH_UserInfoManager shareUserManager].isLogin) {
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            [SH_NetWorkService_Promo startLoadGameNoticeStartTime:self.startTimeStr endTime:self.endTimeStr pageNumber:1 pageSize:50000 apiId:model.apiId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSDictionary *dic = (NSDictionary *)response;
                NSLog(@"dic===%@",dic);
                for (NSDictionary *dict in dic[@"data"][@"list"]) {
                    NSError *err;
                    SH_GameBulletinModel *model = [[SH_GameBulletinModel alloc] initWithDictionary:dict error:&err];
                    [self.gameAnnouncementArr addObject:model];
                }
                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self animated:YES];
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
        }
    }];
    [self addSubview:popTV];
}

-(void)changedDate:(NSDictionary *)nt {
    [self.startTimeBtn setTitle:nt[@"date"] forState:UIControlStateNormal];
    self.startTimeStr = nt[@"date"];
    if (!self.endTimeStr) {
        self.endTimeStr = [self getCurrentTimes];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:self.startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];
    if (startDate > endDate) {
        showMessage(self, @"提示", @"时间选择有误,请重试选择");
        return;
    }
    [self.gameAnnouncementArr removeAllObjects];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadGameNoticeStartTime:self.startTimeStr endTime:self.endTimeStr pageNumber:1 pageSize:50000 apiId:self.apiId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dic = (NSDictionary *)response;
            NSLog(@"dic===%@",dic);
            for (NSDictionary *dict in dic[@"data"][@"list"]) {
                NSError *err;
                SH_GameBulletinModel *model = [[SH_GameBulletinModel alloc] initWithDictionary:dict error:&err];
                [self.gameAnnouncementArr addObject:model];
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}

-(void)seletedEndDate:(NSDictionary *)nt {
    [self.endTimeBtn setTitle:nt[@"date"] forState:UIControlStateNormal];
    self.endTimeStr = nt[@"date"];
    if (!self.startTimeStr) {
        self.startTimeStr = [self getCurrentTimes];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:self.startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];
    if (startDate > endDate) {
        showMessage(self, @"提示", @"时间选择有误,请重试选择");
        return;
    }
    [self.gameAnnouncementArr removeAllObjects];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadGameNoticeStartTime:self.startTimeStr endTime:self.endTimeStr pageNumber:1 pageSize:50000 apiId:self.apiId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dic = (NSDictionary *)response;
            NSLog(@"dic===%@",dic);
            for (NSDictionary *dict in dic[@"data"][@"list"]) {
                NSError *err;
                SH_GameBulletinModel *model = [[SH_GameBulletinModel alloc] initWithDictionary:dict error:&err];
                [self.gameAnnouncementArr addObject:model];
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self animated:YES];
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
    self.apiNameArr = [NSMutableArray array];
    self.apiNameModelArr = [NSMutableArray array];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadGameNoticeStartTime:[self getCurrentTimes] endTime:[self getCurrentTimes] pageNumber:1 pageSize:20 apiId:self.apiId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {

            NSDictionary *dic = (NSDictionary *)response;
            NSLog(@"dic===%@",dic);
            for (NSDictionary *dict in dic[@"data"][@"list"]) {
                NSError *err;
                SH_GameBulletinModel *model = [[SH_GameBulletinModel alloc] initWithDictionary:dict error:&err];
                [self.gameAnnouncementArr addObject:model];
            }
            
            for (NSDictionary *dict in dic[@"data"][@"apiSelect"]) {
                NSError *err;
                SH_ApiSelectModel *model = [[SH_ApiSelectModel alloc] initWithDictionary:dict error:&err];
                [self.apiNameArr addObject:model.apiName];
                [self.apiNameModelArr addObject:model];
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }else{
        showMessage(self, @"", @"请先登录");
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

#pragma mark - PGDatePickerDelegate M
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSString *month ;
    NSString *day;
    if (dateComponents.month < 10) {
        month = [NSString stringWithFormat:@"0%@",@(dateComponents.month)];
    }else{
        month = [NSString stringWithFormat:@"%@",@(dateComponents.month)];
    }
    
    if (dateComponents.day < 10) {
        day = [NSString stringWithFormat:@"0%@",@(dateComponents.day)];
    }else{
        day = [NSString stringWithFormat:@"%@",@(dateComponents.day)];
    }
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year),month,day];
    NSLog(@"---%@",dateStr);
    if ([self.startAndEndDateStr isEqualToString:@"end"]) {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year),month,day];
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:dateStr,@"date",nil];
        [self seletedEndDate:dict];
                self.startAndEndDateStr = @"";
        
    } else {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year),month,day];
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:dateStr,@"date",nil];
        [self changedDate:dict];
    }
}
@end
