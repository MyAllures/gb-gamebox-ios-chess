//
//  SH_MyMsgView.m
//  GameBox
//
//  Created by sam on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_MyMsgView.h"
#import "SH_MyMsgTabelViewCell.h"
#import "SH_NetWorkService+Promo.h"
#import "SH_MyMsgDataListModel.h"
@interface SH_MyMsgView ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataListArr;
@property (weak, nonatomic) IBOutlet UIImageView *seleteAllImageView;
@property (weak, nonatomic) IBOutlet UIButton *seleteAllBtn;
@property (strong, nonatomic) NSIndexPath *indexPath1;

@property (strong, nonatomic) NSMutableArray *deleteArr;
@property (assign, nonatomic) BOOL isSelete;
@end

@implementation SH_MyMsgView

- (IBAction)seleteAllBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.seleteAllImageView.image = [UIImage imageNamed:@"choose"];
        [self.seleteAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        for (SH_MyMsgDataListModel *model in self.dataListArr) {
            [model updateSelectedFlag:YES];
        }
        self.isSelete = YES;
        [self.tableView reloadData];
    }else{
        self.seleteAllImageView.image = [UIImage imageNamed:@"not-choose"];
        [self.seleteAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        for (SH_MyMsgDataListModel *model in self.dataListArr) {
            [model updateSelectedFlag:NO];
        }
        self.isSelete = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - 删除
- (IBAction)deleteAction:(id)sender {
    if (self.isSelete) {
        for (SH_MyMsgDataListModel *model in self.dataListArr) {
            [self.deleteArr addObject:model];
        }
        NSString *str = @"";
        for (SH_MyMsgDataListModel *siteModel in self.deleteArr) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",siteModel.id]];
        }
        if([str length] > 0){
            str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
        }
        [self.deleteArr removeAllObjects];
        [self.dataListArr removeAllObjects];
        [SH_NetWorkService_Promo startLoadMyMessageDeleteWithIds:str complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dict =(NSDictionary *)response;
            NSLog(@"dict===%@",dict);
            NSLog(@"message===%@",dict[@"message"]);
            
            
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }else{
        if (self.deleteArr.count>0) {
            NSString *str = @"";
            for (SH_MyMsgDataListModel *siteModel in self.deleteArr) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",siteModel.id]];
            }
            if([str length] > 0){
                str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
            }
            NSLog(@"str=====%@",str);
            NSLog(@"count=====%lu",(unsigned long)self.dataListArr.count);
            for (SH_MyMsgDataListModel *model in self.deleteArr) {
                for (SH_MyMsgDataListModel *mod in self.dataListArr) {
                    if (model.id == mod.id) {
                        [self.dataListArr removeObject:mod];
                    }
                }
            }
            NSLog(@"count1=====%lu",(unsigned long)self.dataListArr.count);
            [self.deleteArr removeAllObjects];
            [SH_NetWorkService_Promo startLoadMyMessageDeleteWithIds:str complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSDictionary *dict =(NSDictionary *)response;
                NSLog(@"dict===%@",dict);
                NSLog(@"message===%@",dict[@"message"]);
                
                
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
        }else
        {
            showAlertView(@"提示", @"请选择消息记录");
        }
    }
    
    
    [self.tableView reloadData];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    //    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    //    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCell:) name:@"changedImage1" object:nil];
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.isSelete = NO;
    self.dataListArr = [NSMutableArray array];
    self.deleteArr = [NSMutableArray array];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [SH_NetWorkService_Promo startSiteMessageMyMessageWithpageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dict = (NSDictionary *)response;
            NSLog(@"dict===%@",dict);
            for (NSDictionary *dic in dict[@"data"][@"dataList"]) {
                NSError *err;
                SH_MyMsgDataListModel *model = [[SH_MyMsgDataListModel alloc] initWithDictionary:dic error:&err];
                [self.dataListArr addObject:model];
                [self.tableView reloadData];
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }else{
        showMessage(self, @"", @"请先登录");
    }
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_MyMsgTabelViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
}

-(void)updateCell: (NSNotification *)noti {
    NSString *row = noti.userInfo[@"row"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[row integerValue] inSection:0];
//    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    SH_MyMsgDataListModel *model = self.dataListArr[[row integerValue]];
    if (model.selectedFlag == NO) {
        [model updateSelectedFlag:YES];
        if (![self.deleteArr containsObject:model]) {
            [self.deleteArr addObject:model];
        }
    }else{
        [model updateSelectedFlag:NO];
        if ([self.deleteArr containsObject:model]) {
            [self.deleteArr addObject:model];
        }
    }
    
    self.indexPath1 = indexPath;
//    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_MyMsgTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_MyMsgTabelViewCell" owner:nil options:nil] lastObject];
    }
    SH_MyMsgDataListModel *model = self.dataListArr[indexPath.row];
    cell.seleteBtn.tag = indexPath.row;
    cell.advisoryContentLabel.text = model.advisoryContent;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.advisoryTimeLabel.text = [self timeStampWithDate:model.advisoryTime];
    if (model.selectedFlag) {
        [cell.seleteBtn setBackgroundImage: [UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }else{
        [cell.seleteBtn setBackgroundImage: [UIImage imageNamed:@"not-choose"] forState:UIControlStateNormal];
    }
    return cell;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
