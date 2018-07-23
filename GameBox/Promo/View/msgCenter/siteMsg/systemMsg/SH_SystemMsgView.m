//
//  SH_SystemMsgView.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SystemMsgView.h"
#import <Masonry/Masonry.h>
#import "SH_SiteMsgViewCell.h"
#import "SH_NetWorkService+Promo.h"
#import "SH_SysMsgDataListModel.h"
#import "SH_MsgDetailView.h"
#import "SH_WebPImageView.h"

@interface SH_SystemMsgView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataListArr;
@property (strong, nonatomic) NSIndexPath *indexPath1;
@property (weak, nonatomic) IBOutlet SH_WebPImageView *seleteAllImageView;
@property (weak, nonatomic) IBOutlet UIButton *seleteAllBtn;
//删除的数据
@property (strong, nonatomic) NSMutableArray *deleteArr;
@property (assign, nonatomic) BOOL isSelete;
@property (strong, nonatomic) SH_MsgDetailView *detailView ;
@end

@implementation SH_SystemMsgView
#pragma mark - 全选
- (IBAction)seleteAllBtn:(UIButton *)sender {
    if (self.dataListArr.count > 0) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            self.seleteAllImageView.imageName = @"choose";
            [self.seleteAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
            for (SH_SysMsgDataListModel *model in self.dataListArr) {
                [model updateSelectedFlag:YES];
            }
            self.isSelete = YES;
            [self.tableView reloadData];
        }else{
            self.seleteAllImageView.imageName = @"not-choose";
            [self.seleteAllBtn setTitle:@"全选" forState:UIControlStateNormal];
            for (SH_SysMsgDataListModel *model in self.dataListArr) {
                [model updateSelectedFlag:NO];
            }
            self.isSelete = NO;
            [self.tableView reloadData];
        }
    }
}
#pragma mark - 删除
- (IBAction)deleteAction:(id)sender {
    if (self.isSelete) {
        for (SH_SysMsgDataListModel *model in self.dataListArr) {
            [self.deleteArr addObject:model];
        }
        NSString *str = @"";
        for (SH_SysMsgDataListModel *siteModel in self.deleteArr) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",siteModel.id]];
        }
        if([str length] > 0){
            str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
        }
        [self.deleteArr removeAllObjects];
        [self.dataListArr removeAllObjects];
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemMessageDeleteWithIds:str complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dict =(NSDictionary *)response;
            NSLog(@"dict===%@",dict);
            NSLog(@"message===%@",dict[@"message"]);
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }else{
        if (self.deleteArr.count>0) {
            NSString *str = @"";
            for (SH_SysMsgDataListModel *siteModel in self.deleteArr) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",siteModel.id]];
            }
            if([str length] > 0){
                str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
            }
            NSLog(@"str=====%@",str);
            for (SH_SysMsgDataListModel *model in self.deleteArr) {
                if ([self.dataListArr containsObject:model]) {
                    [self.dataListArr removeObject:model];
                }
            }
            [self.deleteArr removeAllObjects];
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            [SH_NetWorkService_Promo startLoadSystemMessageDeleteWithIds:str complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSDictionary *dict =(NSDictionary *)response;
                NSLog(@"dict===%@",dict);
                NSLog(@"message===%@",dict[@"message"]);
                [MBProgressHUD hideHUDForView:self animated:YES];
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
        }else
        {
            showMessage(self, @"提示", @"请选择消息记录");
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark -  标记已读

- (IBAction)markReadAction:(id)sender {
    
    if (self.isSelete) {
        for (SH_SysMsgDataListModel *model in self.dataListArr) {
            [self.deleteArr addObject:model];
        }
        NSString *str = @"";
        for (SH_SysMsgDataListModel *siteModel in self.deleteArr) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",siteModel.id]];
        }
        if([str length] > 0){
            str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
        }
        [self.deleteArr removeAllObjects];
        [self.dataListArr removeAllObjects];
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemMessageDeleteWithIds:str complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dict =(NSDictionary *)response;
            NSLog(@"dict===%@",dict);
            NSLog(@"message===%@",dict[@"message"]);
            [MBProgressHUD hideHUDForView:self animated:YES];
            [SH_NetWorkService_Promo startLoadSystemMessageWithpageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSDictionary *dict = (NSDictionary *)response;
                NSLog(@"dict====%@",dict);
                NSLog(@"message====%@",dict[@"message"]);
                for (NSDictionary *dic in dict[@"data"][@"list"]) {
                    NSError *err;
                    SH_SysMsgDataListModel *model = [[SH_SysMsgDataListModel alloc] initWithDictionary:dic error:&err];
                    [self.dataListArr addObject:model];
                    [self.tableView reloadData];
                }
                [MBProgressHUD hideHUDForView:self animated:YES];
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                NSLog(@"%@",err);
                showAlertView(@"", err);
            }];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    } else {
        if (self.deleteArr.count>0) {
            NSString *str = @"";
            for (SH_SysMsgDataListModel *siteModel in self.deleteArr) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",siteModel.id]];
            }
            if([str length] > 0){
                str = [str substringToIndex:([str length]-1)];// 去掉最后一个","
            }
            NSLog(@"str=====%@",str);
            [self.deleteArr removeAllObjects];
            [self.dataListArr removeAllObjects];
            [SH_NetWorkService_Promo startLoadSystemMessageReadYesWithIds:str complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSDictionary *dict =(NSDictionary *)response;
                NSLog(@"dict===%@",dict);
                [MBProgressHUD showHUDAddedTo:self animated:YES];
                [SH_NetWorkService_Promo startLoadSystemMessageWithpageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                    NSDictionary *dict = (NSDictionary *)response;
                    NSLog(@"dict====%@",dict);
                    NSLog(@"message====%@",dict[@"message"]);
                    for (NSDictionary *dic in dict[@"data"][@"list"]) {
                        NSError *err;
                        SH_SysMsgDataListModel *model = [[SH_SysMsgDataListModel alloc] initWithDictionary:dic error:&err];
                        [self.dataListArr addObject:model];
                        [self.tableView reloadData];
                    }
                    [MBProgressHUD hideHUDForView:self animated:YES];
                } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                    NSLog(@"%@",err);
                    showAlertView(@"", err);
                }];
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
        }
    }
    
    
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCell:) name:@"changedImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSysMsgData) name:@"reloadSysMsgData" object:nil];
    self.isSelete = NO;
    self.dataListArr = [NSMutableArray array];
    self.deleteArr = [NSMutableArray array];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemMessageWithpageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dict = (NSDictionary *)response;
            NSLog(@"dict====%@",dict);
            NSLog(@"message====%@",dict[@"message"]);
            for (NSDictionary *dic in dict[@"data"][@"list"]) {
                NSError *err;
                SH_SysMsgDataListModel *model = [[SH_SysMsgDataListModel alloc] initWithDictionary:dic error:&err];
                [self.dataListArr addObject:model];
                [self.tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            NSLog(@"%@",err);
            showAlertView(@"", err);
        }];
    }else{
        showMessage(self, @"", @"请先登录");
    }
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_SiteMsgViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
}

-(void)reloadSysMsgData {
    [self.dataListArr removeAllObjects];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemMessageWithpageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dict = (NSDictionary *)response;
            NSLog(@"dict====%@",dict);
            NSLog(@"message====%@",dict[@"message"]);
            for (NSDictionary *dic in dict[@"data"][@"list"]) {
                NSError *err;
                SH_SysMsgDataListModel *model = [[SH_SysMsgDataListModel alloc] initWithDictionary:dic error:&err];
                [self.dataListArr addObject:model];
                [self.tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            NSLog(@"%@",err);
            showAlertView(@"", err);
        }];
    }else{
        showMessage(self, @"", @"请先登录");
    }
}

-(void)updateCell: (NSNotification *)noti {
    NSString *row = noti.userInfo[@"row"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[row integerValue] inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    SH_SysMsgDataListModel *model = self.dataListArr[indexPath.row];
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
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_SiteMsgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.seleteBtn.tag = indexPath.row;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_SiteMsgViewCell" owner:nil options:nil] lastObject];
    }
    SH_SysMsgDataListModel *model = self.dataListArr[indexPath.row];
    cell.advisoryContentLabel.text = model.title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    if (model.read == 1) {
        cell.mearkReadImageView.image = nil;
    }else{
        cell.mearkReadImageView.image = [UIImage imageNamed:@"mearkRead"];
    }
    cell.advisoryTimeLabel.text = [self timeStampWithDate:model.publishTime];
    NSLog(@"id=====%ld",(long)model.id);
    if (model.selectedFlag) {
        [cell.seleteBtn setWebpImage:@"choose" forState:UIControlStateNormal];
    }else{
        [cell.seleteBtn setWebpImage:@"not-choose" forState:UIControlStateNormal];
    }
    
    return cell;
}

- (NSArray *)cellsForTableView:(UITableView *)tableView

{
    
    NSInteger sections = tableView.numberOfSections;
    
    NSMutableArray *cells = [[NSMutableArray alloc]  init];
    
    for (int section = 0; section < sections; section++) {
        
        NSInteger rows =  [tableView numberOfRowsInSection:section];
        
        for (int row = 0; row < rows; row++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            [cells addObject:[tableView cellForRowAtIndexPath:indexPath]];
            
        }
        
    }
    
    return cells;
    
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
    
    SH_SysMsgDataListModel *model = self.dataListArr[indexPath.row];
    self.detailView =[[[NSBundle mainBundle] loadNibNamed:@"SH_MsgDetailView" owner:nil options:nil] lastObject];
    [[UIApplication sharedApplication].keyWindow addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    self.detailView.searchId = model.searchId;
    self.detailView.mId = model.id;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadSysMsgData" object:nil];
}

@end
