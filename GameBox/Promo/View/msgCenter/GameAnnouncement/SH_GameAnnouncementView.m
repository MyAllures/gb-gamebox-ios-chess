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
#import "HLPopTableView.h"
#import "SH_NiceDatePickerView.h"
#import "SH_BulletinDetailView.h"

@interface SH_GameAnnouncementView ()<UITableViewDataSource, UITableViewDelegate>

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

@property (strong, nonatomic) SH_BulletinDetailView *detailView;

@end

@implementation SH_GameAnnouncementView

#pragma mark 开始时间选择
- (IBAction)startTimeAction:(id)sender {
    SH_NiceDatePickerView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_NiceDatePickerView" owner:self options:nil].firstObject;
    [view setDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormat stringFromDate:date];
        NSLog(@"dateString==%@",dateString);
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:dateString,@"date",nil];
        [self changedDate:dict];
    }];
    [view showPickerView];
}
#pragma mark 结束时间选择
- (IBAction)endTimeAction:(id)sender {
    SH_NiceDatePickerView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_NiceDatePickerView" owner:self options:nil].firstObject;
    [view setDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormat stringFromDate:date];
        NSLog(@"dateString==%@",dateString);
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:dateString,@"date",nil];
        [self changedDate:dict];
    }];
    [view showPickerView];
}
#pragma mark --- 模态弹出viewController
-(void)presentViewController:(UIViewController*)viewController addTargetViewController:(UIViewController*)targetVC{
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [targetVC presentViewController:viewController animated:YES completion:nil];
}
#pragma mark 游戏类型
- (IBAction)tapApiName:(UIButton *)sender {
    if (![RH_UserInfoManager shareUserManager].isLogin) {
        showMessage(self, @"", @"请先登录");
        return;
    }
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width, 110) dependView:sender textArr:self.apiNameArr   textFont:8.0 block:^(NSString *region_name, NSInteger index) {
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
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
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
    SH_GameBulletinModel *model = self.gameAnnouncementArr[indexPath.row];
    self.detailView =[[[NSBundle mainBundle] loadNibNamed:@"SH_BulletinDetailView" owner:nil options:nil] lastObject];
    [[UIApplication sharedApplication].keyWindow addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    self.detailView.context = model.context;
}

-(void)dealloc {
}
@end
