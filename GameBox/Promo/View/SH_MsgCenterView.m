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
#import "SH_WaitingView.h"

@interface SH_MsgCenterView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *game_label;

@property (weak, nonatomic) IBOutlet SH_WebPButton *gameNoticeBt;
@property (weak, nonatomic) IBOutlet UILabel *system_label;
@property (weak, nonatomic) IBOutlet SH_WebPButton *systemNoticeBt;
@property (weak, nonatomic) IBOutlet UILabel *inbox_label;
@property (weak, nonatomic) IBOutlet SH_WebPButton *inboxBt;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationBarConstraint;
@property (weak, nonatomic) IBOutlet SH_WebPImageView *nodataMarkView;
@property (weak, nonatomic) IBOutlet SH_WebPButton *selectAllBT;
@property (nonatomic, strong) NSMutableArray *msgArr;
@property (nonatomic, copy) SH_MsgCenterViewShowDetail showDetailBlock;

@property (nonatomic,strong)NSMutableDictionary  *data_dict;

@end

@implementation SH_MsgCenterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self  fetchHttpData];
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

-(NSMutableDictionary *)data_dict{
    if (!_data_dict) {
        _data_dict = [NSMutableDictionary  dictionary];
    }
    return _data_dict;
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
-(void)fetchHttpData{
    __weak typeof(self) weakSelf = self;
    __block NSMutableArray  * notice_array = [NSMutableArray  array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [SH_NetWorkService_Promo startLoadGameNoticeStartTime:@"" endTime:@"" pageNumber:1 pageSize:5000 apiId:0 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (response && [[response objectForKey:@"code"] intValue] == 0) {
                NSArray *list = response[@"data"][@"list"];
                [weakSelf.msgArr removeAllObjects];
                
                for (NSDictionary *dic in list) {
                    NSError *err;
                    SH_GameBulletinModel *model = [[SH_GameBulletinModel alloc] initWithDictionary:dic error:&err];
                    [notice_array addObject:model];
                }
                [self.data_dict setValue:notice_array forKey:@"notice"];
            }
            else
            {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            }
//            [weakSelf.tableView reloadData];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    });
    __block NSMutableArray  * system_array = [NSMutableArray  array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:@"" endTime:@"" pageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (response && [[response objectForKey:@"code"] intValue] == 0) {
                NSArray *list = response[@"data"][@"list"];
                for (NSDictionary *dic in list) {
                    NSError *err;
                    SH_SystemNotificationModel *model = [[SH_SystemNotificationModel alloc] initWithDictionary:dic error:&err];
                    [system_array addObject:model];
                }
                [self.data_dict setValue:system_array forKey:@"system"];
            }
            else
            {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            }
//            [weakSelf.tableView reloadData];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    });
    __block NSMutableArray  * game_array = [NSMutableArray  array];
    __block NSMutableArray  * gameId_array = [NSMutableArray  array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [SH_NetWorkService_Promo startLoadSystemMessageWithpageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (response && [[response objectForKey:@"code"] intValue] == 0) {
                NSArray *list = response[@"data"][@"list"];
                for (NSDictionary *dic in list) {
                    NSError *err;
                    SH_SysMsgDataListModel *model = [[SH_SysMsgDataListModel alloc] initWithDictionary:dic error:&err];
                    if (!model.read) {
                       [gameId_array addObject:[NSString  stringWithFormat:@"%ld",model.mId]];
                    }
                    [game_array addObject:model];
                    [gameId_array writeToFile:[self pathForFile:@"inbox"] atomically:YES];
                }
                [self.data_dict setValue:game_array forKey:@"inbox"];
                self.inbox_label.text = [NSString  stringWithFormat:@"%ld",gameId_array.count];
            }
            else
            {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            }
//            [weakSelf.tableView reloadData];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    });
}
- (IBAction)gameNoticeClick:(id)sender {
    self.gameNoticeBt.selected = YES;
    self.systemNoticeBt.selected = NO;
    self.inboxBt.selected = NO;
    self.operationBarConstraint.constant = 0;
    if (self.msgArr.count >0) {
        [self.msgArr removeAllObjects];
    }
    self.msgArr = [self.data_dict[@"notice"] mutableCopy];
    [self.tableView reloadData];
    
   /* [self.msgArr removeAllObjects];
    __weak typeof(self) weakSelf = self;

    [SH_NetWorkService_Promo startLoadGameNoticeStartTime:@"" endTime:@"" pageNumber:1 pageSize:5000 apiId:0 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (response && [[response objectForKey:@"code"] intValue] == 0) {
            NSArray *list = response[@"data"][@"list"];
            [weakSelf.msgArr removeAllObjects];
            
            for (NSDictionary *dic in list) {
                NSError *err;
                SH_GameBulletinModel *model = [[SH_GameBulletinModel alloc] initWithDictionary:dic error:&err];
                [weakSelf.msgArr addObject:model];
            }
            weakSelf.nodataMarkView.hidden = weakSelf.msgArr.count > 0;
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            weakSelf.nodataMarkView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];*/
//        weakSelf.nodataMarkView.hidden = NO;
//    }];
}

- (IBAction)systemNoticeClick:(id)sender {
    self.gameNoticeBt.selected = NO;
    self.systemNoticeBt.selected = YES;
    self.inboxBt.selected = NO;
    self.operationBarConstraint.constant = 0;
    if (self.msgArr.count >0) {
        [self.msgArr removeAllObjects];
    }
    self.msgArr = [self.data_dict[@"system"] mutableCopy];
    [self.tableView reloadData];
   /* [self.msgArr removeAllObjects];
    __weak typeof(self) weakSelf = self;

    [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:@"" endTime:@"" pageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (response && [[response objectForKey:@"code"] intValue] == 0) {
            NSArray *list = response[@"data"][@"list"];
            for (NSDictionary *dic in list) {
                NSError *err;
                SH_SystemNotificationModel *model = [[SH_SystemNotificationModel alloc] initWithDictionary:dic error:&err];
                [weakSelf.msgArr addObject:model];
            }
            weakSelf.nodataMarkView.hidden = weakSelf.msgArr.count > 0;
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            weakSelf.nodataMarkView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];*/
}

- (IBAction)InboxClick:(id)sender {
    self.gameNoticeBt.selected = NO;
    self.systemNoticeBt.selected = NO;
    self.inboxBt.selected = YES;
    self.selectAllBT.selected = NO;
    self.operationBarConstraint.constant = 42.5;
    if (self.msgArr.count >0) {
        [self.msgArr removeAllObjects];
    }
    self.msgArr = [self.data_dict[@"inbox"] mutableCopy];
    [self.tableView reloadData];
   /* [self.msgArr removeAllObjects];
    __weak typeof(self) weakSelf = self;

    [SH_NetWorkService_Promo startLoadSystemMessageWithpageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (response && [[response objectForKey:@"code"] intValue] == 0) {
            NSArray *list = response[@"data"][@"list"];
            for (NSDictionary *dic in list) {
                NSError *err;
                SH_SysMsgDataListModel *model = [[SH_SysMsgDataListModel alloc] initWithDictionary:dic error:&err];
                [weakSelf.msgArr addObject:model];
            }
            weakSelf.nodataMarkView.hidden = weakSelf.msgArr.count > 0;
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            weakSelf.nodataMarkView.hidden = NO;
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];*/
}
-(NSString*)pathForFile:(NSString*)fileName{
    NSString  * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePatch = [path stringByAppendingPathComponent:fileName];
    return filePatch;
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
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%li,",(long)model.mId]];
        }
    }

    if (![ids isEqualToString:@""]) {
        [SH_WaitingView showOn:self];
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
            [SH_WaitingView hide:weakSelf];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [SH_WaitingView hide:weakSelf];
        }];
    }
}

- (IBAction)deleteReadedAction:(id)sender {
    __weak typeof(self) weakSelf = self;

    NSString *ids = [NSString string];
    for (SH_SysMsgDataListModel *model in self.msgArr) {
        if (model.read) {
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%li,",(long)model.mId]];
        }
    }
    
    if (![ids isEqualToString:@""]) {
        [SH_WaitingView showOn:self];
        [SH_NetWorkService_Promo startLoadSystemMessageDeleteWithIds:ids complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (response && [[response objectForKey:@"code"] integerValue] == 0) {
                NSMutableArray *readedObjs = [NSMutableArray array];
                for (int i = 0; i < weakSelf.msgArr.count; i++) {
                    SH_SysMsgDataListModel *model = self.msgArr[i];
                    if (model.read) {
                        [readedObjs addObject:model];
                    }
                }
                for (SH_SysMsgDataListModel *model in readedObjs) {
                    [weakSelf.msgArr removeObject:model];
                }
                
                [weakSelf.tableView reloadData];
            }
            else
            {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            }
            [SH_WaitingView hide:weakSelf];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [SH_WaitingView hide:weakSelf];
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
        NSMutableArray  * temp_array = [NSArray  arrayWithContentsOfFile:[self pathForFile:@"inbox"]].mutableCopy;
        //模型赋值
        SH_SysMsgDataListModel *tModel = (SH_SysMsgDataListModel *)model;
        if ([temp_array containsObject:[NSString  stringWithFormat:@"%ld",tModel.mId]]) {
            [temp_array removeObject:[NSString stringWithFormat:@"%ld",tModel.mId]];
            self.inbox_label.text = [NSString  stringWithFormat:@"%ld",temp_array.count];
            [temp_array writeToFile:[self pathForFile:@"inbox"] atomically:YES];
        }
        tModel.selected = !tModel.selected;
        
        //UI更新
        SH_MsgCenterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell updateSelectedStatus];
        
        [SH_WaitingView showOn:self];
        [SH_NetWorkService_Promo startLoadSystemMessageDetailWithSearchId:tModel.searchId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSString *content = response[@"data"][@"content"];
            if (weakSelf.showDetailBlock) {
                weakSelf.showDetailBlock(content);
            }
            [SH_WaitingView hide:weakSelf];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [SH_WaitingView hide:weakSelf];
        }];
    }
    else if ([model isMemberOfClass:[SH_GameBulletinModel class]])
    {
        SH_GameBulletinModel *tModel = (SH_GameBulletinModel *)model;
        
        [SH_WaitingView showOn:self];
        [SH_NetWorkService_Promo getGameNoticeDetail:tModel.id complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSString *content = response[@"data"][@"context"];
            if (weakSelf.showDetailBlock) {
                weakSelf.showDetailBlock(content);
            }
            [SH_WaitingView hide:weakSelf];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [SH_WaitingView hide:weakSelf];
        }];
    }
    else if ([model isMemberOfClass:[SH_SystemNotificationModel class]])
    {
        SH_SystemNotificationModel *tModel = (SH_SystemNotificationModel *)model;
        
        [SH_WaitingView showOn:self];
        [SH_NetWorkService_Promo getSysNoticeDetail:tModel.searchId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSString *content = response[@"data"][@"content"];
            if (weakSelf.showDetailBlock) {
                weakSelf.showDetailBlock(content);
            }
            [SH_WaitingView hide:weakSelf];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [SH_WaitingView hide:weakSelf];
        }];
    }
}

#pragma mark - UITableViewDelegate M

#pragma mark - Private M

@end
