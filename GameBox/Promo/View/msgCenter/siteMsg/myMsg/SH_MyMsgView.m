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
@end

@implementation SH_MyMsgView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    //    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    //    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.dataListArr = [NSMutableArray array];
    
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_MyMsgTabelViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
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
    cell.advisoryContentLabel.text = model.advisoryContent;
    cell.advisoryTimeLabel.text = [self timeStampWithDate:model.advisoryTime];
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
