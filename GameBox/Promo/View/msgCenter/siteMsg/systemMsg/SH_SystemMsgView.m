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

@interface SH_SystemMsgView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataListArr;
@property (strong, nonatomic) NSIndexPath *indexPath1;
@property (weak, nonatomic) IBOutlet UIImageView *seleteAllImageView;
@property (weak, nonatomic) IBOutlet UIButton *seleteAllBtn;

@end

@implementation SH_SystemMsgView
#pragma mark - 全选
- (IBAction)seleteAllBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.seleteAllImageView.image = [UIImage imageNamed:@"choose"];
        [self.seleteAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        for (SH_SysMsgDataListModel *model in self.dataListArr) {
            [model updateSelectedFlag:YES];
        }
        [self.tableView reloadData];
    }else{
        self.seleteAllImageView.image = [UIImage imageNamed:@"not-choose"];
        [self.seleteAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        for (SH_SysMsgDataListModel *model in self.dataListArr) {
            [model updateSelectedFlag:NO];
        }
        [self.tableView reloadData];
    }
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCell:) name:@"changedImage" object:nil];
    
    self.dataListArr = [NSMutableArray array];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    [SH_NetWorkService_Promo startLoadSystemMessageWithpageNumber:1 pageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict====%@",dict);
        for (NSDictionary *dic in dict[@"data"][@"dataList"]) {
            NSError *err;
            SH_SysMsgDataListModel *model = [[SH_SysMsgDataListModel alloc] initWithDictionary:dic error:&err];
            [self.dataListArr addObject:model];
            [self.tableView reloadData];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_SiteMsgViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
}

-(void)updateCell: (NSNotification *)noti {
    NSString *row = noti.userInfo[@"row"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[row integerValue] inSection:0];
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    SH_SysMsgDataListModel *model = self.dataListArr[indexPath.row];
    if (model.selectedFlag == NO) {
        [model updateSelectedFlag:YES];
    }else{
        [model updateSelectedFlag:NO];
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
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SH_SysMsgDataListModel *model = self.dataListArr[indexPath.row];
    cell.advisoryContentLabel.text = model.advisoryContent;
    cell.advisoryTimeLabel.text = [self timeStampWithDate:model.advisoryTime];
    if (model.selectedFlag) {
        [cell.seleteBtn setBackgroundImage: [UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    }else{
        [cell.seleteBtn setBackgroundImage: [UIImage imageNamed:@"not-choose"] forState:UIControlStateNormal];
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
    
}


@end
