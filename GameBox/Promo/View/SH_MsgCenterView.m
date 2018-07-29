//
//  SH_MsgCenterView.m
//  GameBox
//
//  Created by shin on 2018/7/25.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_MsgCenterView.h"
#import "SH_MsgCenterCell.h"
#import "SH_NetWorkService+Promo.h"
#import "SH_SystemNotificationModel.h"
#import "SH_GameBulletinModel.h"
#import "SH_SysMsgDataListModel.h"

@interface SH_MsgCenterView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet SH_WebPButton *gameNoticeBt;
@property (weak, nonatomic) IBOutlet SH_WebPButton *systemNoticeBt;
@property (weak, nonatomic) IBOutlet SH_WebPButton *inboxBt;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationBarConstraint;
@property (nonatomic, strong) NSMutableArray *msgArr;
@property (nonatomic, copy) SH_MsgCenterViewShowDetail showDetailBlock;

@end

@implementation SH_MsgCenterView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)showDetail:(SH_MsgCenterViewShowDetail)showDetailBlock
{
    self.showDetailBlock = showDetailBlock;
}

- (NSMutableArray *)msgArr
{
    if (_msgArr == nil) {
        _msgArr = [NSMutableArray array];
    }
    return _msgArr;
}

- (void)reloadData
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_MsgCenterCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 90;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self gameNoticeClick:nil];
}

- (IBAction)gameNoticeClick:(id)sender {
    self.gameNoticeBt.selected = YES;
    self.systemNoticeBt.selected = NO;
    self.inboxBt.selected = NO;
    self.operationBarConstraint.constant = 0;
    
    [self.msgArr removeAllObjects];

    __weak typeof(self) weakSelf = self;

    [SH_NetWorkService_Promo startLoadGameNoticeStartTime:@"" endTime:@"" pageNumber:1 pageSize:5000 apiId:0 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (response && [[response objectForKey:@"code"] intValue] == 0) {
            NSArray *list = response[@"data"][@"list"];
            [weakSelf.msgArr removeAllObjects];
            
            for (NSDictionary *dic in list) {
                NSError *err;
                SH_GameBulletinModel *model = [[SH_GameBulletinModel alloc] initWithDictionary:dic error:&err];
                [self.msgArr addObject:model];
            }
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
        }
        [self.tableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

- (IBAction)systemNoticeClick:(id)sender {
    self.gameNoticeBt.selected = NO;
    self.systemNoticeBt.selected = YES;
    self.inboxBt.selected = NO;
    self.operationBarConstraint.constant = 0;

    [self.msgArr removeAllObjects];
    __weak typeof(self) weakSelf = self;

    [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:@"" endTime:@"" pageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (response && [[response objectForKey:@"code"] intValue] == 0) {
            NSArray *list = response[@"data"][@"list"];
            for (NSDictionary *dic in list) {
                NSError *err;
                SH_SystemNotificationModel *model = [[SH_SystemNotificationModel alloc] initWithDictionary:dic error:&err];
                [weakSelf.msgArr addObject:model];
            }
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

- (IBAction)InboxClick:(id)sender {
    self.gameNoticeBt.selected = NO;
    self.systemNoticeBt.selected = NO;
    self.inboxBt.selected = YES;
    self.operationBarConstraint.constant = 42.5;

    [self.msgArr removeAllObjects];
    __weak typeof(self) weakSelf = self;

    [SH_NetWorkService_Promo startLoadSystemMessageWithpageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (response && [[response objectForKey:@"code"] intValue] == 0) {
            NSArray *list = response[@"data"][@"list"];
            for (NSDictionary *dic in list) {
                NSError *err;
                SH_SysMsgDataListModel *model = [[SH_SysMsgDataListModel alloc] initWithDictionary:dic error:&err];
                [weakSelf.msgArr addObject:model];
            }
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

- (IBAction)allSelectAction:(id)sender {
    SH_WebPButton *bt = (SH_WebPButton *)sender;
    bt.selected = !bt.selected;
    
    for (SH_SysMsgDataListModel *model in self.msgArr) {
        model.selected = bt.isSelected ? YES : NO;
    }
    [self.tableView reloadData];
}

- (IBAction)markReadedAction:(id)sender {
    __weak typeof(self) weakSelf = self;

    NSString *ids = [NSString string];
    for (SH_SysMsgDataListModel *model in self.msgArr) {
        if (model.selected &&model.read == NO) {
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%li,",(long)model.id]];
        }
    }

    if (![ids isEqualToString:@""]) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemMessageReadYesWithIds:ids complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (response && [[response objectForKey:@"code"] integerValue] == 0) {
                for (SH_SysMsgDataListModel *model in self.msgArr) {
                    if (model.selected) {
                        model.read = YES;
                    }
                }
                [weakSelf.tableView reloadData];
            }
            else
            {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            }
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        }];
    }
}

- (IBAction)deleteReadedAction:(id)sender {
    __weak typeof(self) weakSelf = self;

    NSString *ids = [NSString string];
    for (SH_SysMsgDataListModel *model in self.msgArr) {
        if (model.read) {
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%li,",(long)model.id]];
        }
    }
    
    if (![ids isEqualToString:@""]) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemMessageDeleteWithIds:ids complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (response && [[response objectForKey:@"code"] integerValue] == 0) {
                for (int i = 0; i < weakSelf.msgArr.count; i++) {
                    SH_SysMsgDataListModel *model = self.msgArr[i];
                    if (model.read) {
                        [weakSelf.msgArr removeObjectAtIndex:i];
                    }
                }
                [weakSelf.tableView reloadData];
            }
            else
            {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            }
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        }];
    }
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.msgArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_MsgCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_MsgCenterCell" owner:nil options:nil] lastObject];
    }
    if (self.msgArr.count > indexPath.row) {
        cell.model = self.msgArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;

    //只有收件箱有此操作
    id model = self.msgArr[indexPath.row];
    if ([model isMemberOfClass:[SH_SysMsgDataListModel class]]) {
        //模型赋值
        SH_SysMsgDataListModel *tModel = (SH_SysMsgDataListModel *)model;
        tModel.selected = !tModel.selected;
        
        //UI更新
        SH_MsgCenterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell updateSelectedStatus];
        
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemMessageDetailWithSearchId:tModel.searchId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSString *content = response[@"data"][@"content"];
            if (weakSelf.showDetailBlock) {
                weakSelf.showDetailBlock(content);
            }
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        }];
    }
}

#pragma mark - UITableViewDelegate M

#pragma mark - Private M

@end
