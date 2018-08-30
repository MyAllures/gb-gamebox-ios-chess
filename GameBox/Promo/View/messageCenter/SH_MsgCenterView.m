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
#import "RH_WebsocketManagar.h"
#import "SH_SiteMsgUnReadCountModel.h"

@interface SH_MsgCenterView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *game_label;

@property (weak, nonatomic) IBOutlet SH_WebPButton *gameNoticeBt;
@property (weak, nonatomic) IBOutlet UILabel *system_label;
@property (weak, nonatomic) IBOutlet SH_WebPButton *systemNoticeBt;
@property (weak, nonatomic) IBOutlet UILabel *inbox_label;
@property (weak, nonatomic) IBOutlet SH_WebPButton *inboxBt;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationBarConstraint;
@property (weak, nonatomic) IBOutlet SH_WebPButton *selectAllBT;
@property (nonatomic, strong) NSMutableArray *msgArr;
@property (nonatomic, copy) SH_MsgCenterViewShowDetail showDetailBlock;
@property (nonatomic,strong)NSMutableDictionary  *data_dict;
@property(nonatomic,strong)SH_NodataView *noDataView;
@end

@implementation SH_MsgCenterView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self  fetchHttpData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
    [self.data_dict setObject:@"gameMsg" forKey:@"msgNotice"];
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
        [SH_NetWorkService_Promo  getLoadMessageCenterSiteMessageUnReadCountComplete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if ([[response objectForKey:@"code"] isEqualToString:@"0"]) {
                SH_SiteMsgUnReadCountModel * model = [[SH_SiteMsgUnReadCountModel alloc] initWithDictionary:response[@"data"] error:nil];
                if ([model.sysMessageUnReadCount integerValue] >0) {
                    weakSelf.inbox_label.hidden = false;
                    if ([model.sysMessageUnReadCount integerValue] <100) {
                         weakSelf.inbox_label.text = model.sysMessageUnReadCount;
                    }else{
                         weakSelf.inbox_label.text = @"99+";
                    }
                   
                }else{
                    weakSelf.inbox_label.hidden = YES;
                }
                /*if ([model.advisoryUnReadCount integerValue] >0) {
                    weakSelf.game_label.hidden =  false;
                    weakSelf.game_label.text = model.advisoryUnReadCount;
                }else{
                    weakSelf.game_label.hidden = YES;
                }*/
                
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];

}
- (IBAction)gameNoticeClick:(id)sender {
    self.gameNoticeBt.selected = YES;
    self.systemNoticeBt.selected = NO;
    self.inboxBt.selected = NO;
    self.operationBarConstraint.constant = 0;
    [self.data_dict setObject:@"gameMsg" forKey:@"msgNotice"];
    [self.msgArr removeAllObjects];

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
            if (self.msgArr.count==0) {
              self.noDataView = self.noDataView = [SH_NodataView showAddTo:self.tableView Message:@"您暂无消息"];;
            }else{
                [self.noDataView removeFromSuperview];
            }
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            self.noDataView = [SH_NodataView showAddTo:self.tableView Message:@"您暂无消息"];
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        self.noDataView = [SH_NodataView showAddTo:self.tableView Message:@"您暂无消息"];
    }];
}

- (IBAction)systemNoticeClick:(id)sender {
    self.gameNoticeBt.selected = NO;
    self.systemNoticeBt.selected = YES;
    self.inboxBt.selected = NO;
    self.operationBarConstraint.constant = 0;
    [self.data_dict setObject:@"systemMsg" forKey:@"msgNotice"];
    [self fetchSystemMsg];
}
-(void)fetchSystemMsg{
    
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
            if (self.msgArr.count==0) {
                self.noDataView = self.noDataView = [SH_NodataView showAddTo:self.tableView Message:@"您暂无消息"];
            }else{
                [self.noDataView removeFromSuperview];
            }
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            self.noDataView = [SH_NodataView showAddTo:self.tableView Message:@"您暂无消息"];
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
         self.noDataView = [SH_NodataView showAddTo:self.tableView Message:@"您暂无消息"];
    }];
}
- (IBAction)InboxClick:(id)sender {
    self.gameNoticeBt.selected = NO;
    self.systemNoticeBt.selected = NO;
    self.inboxBt.selected = YES;
    self.selectAllBT.selected = NO;
    self.operationBarConstraint.constant = 42.5;
    [self.data_dict setObject:@"inboxMsg" forKey:@"msgNotice"];
    [self fetchInboxMsg];
    [self fetchHttpData];
}
-(void)fetchInboxMsg{
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
            if (self.msgArr.count==0) {
                self.noDataView = self.noDataView = [SH_NodataView showAddTo:self.tableView Message:@"您暂无消息"];
            }else{
                [self.noDataView removeFromSuperview];
            }
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, [response objectForKey:@"message"]);
            self.noDataView = [SH_NodataView showAddTo:self.tableView Message:@"您暂无消息"];
        }
        [weakSelf.tableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        self.noDataView = [SH_NodataView showAddTo:self.tableView Message:@"您暂无消息"];
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
        [SH_WaitingView showOn:self];
        [SH_NetWorkService_Promo startLoadSystemMessageReadYesWithIds:ids complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (response && [[response objectForKey:@"code"] integerValue] == 0) {
                for (SH_SysMsgDataListModel *model in self.msgArr) {
                    if (model.selected) {
                        model.read = YES;
                    }
                }
                [weakSelf fetchHttpData];
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
            ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%li,",(long)model.id]];
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
    if (self.msgArr.count > 0) {
        id model = self.msgArr[indexPath.row];
        if ([model isMemberOfClass:[SH_SysMsgDataListModel class]]) {
            //模型赋值
            SH_SysMsgDataListModel *tModel = (SH_SysMsgDataListModel *)model;
            tModel.selected = !tModel.selected;
            tModel.read = YES;
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
}

#pragma mark - UITableViewDelegate M

#pragma mark - Private M
#pragma mark ==============test webSocket================
- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    NSLog(@"message====%@",message);
    NSMutableArray * array = [NSMutableArray array];
    if ([message isKindOfClass:[NSString  class]]) {
        NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
        id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString * s in obj) {
                NSDictionary* dic = [NSJSONSerialization  JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                [array addObject:dic];
            }
        }else if([obj isKindOfClass:[NSDictionary class]]){
            [array addObject:obj];
        }
    }else if([message isKindOfClass:[NSData  class]]){
        NSData * d = (NSData*)message;
        NSDictionary* dic = [NSJSONSerialization  JSONObjectWithData:d options:0 error:nil];
        [array addObject:dic];
    }
    if (array.count >=1) {
        for (NSDictionary * dic in array) {
            if ([dic[@"subscribeType"] isEqualToString:@"MCENTER_READ_COUNT"] &&[self.data_dict[@"msgNotice"] isEqualToString:@"inboxMsg"]) {
                [self fetchHttpData];
                [self fetchInboxMsg];
            }else if ([dic[@"subscribeType"] isEqualToString:@"SYS_ANN"]&&[self.data_dict[@"msgNotice"] isEqualToString:@"systemMsg"]){
                [self fetchSystemMsg];
                [self fetchHttpData];
            }else if ([dic[@"subscribeType"] isEqualToString:@"SITE_ANN"]&&[self.data_dict[@"msgNotice"] isEqualToString:@"gameMsg"]){
                [self fetchHttpData];
            }
        }
    }
}
@end
