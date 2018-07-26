
//
//  SH_HandRecordView.m
//  GameBox
//
//  Created by sam on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_HandRecordView.h"
#import "SH_HandRecordTableViewCell.h"
#import "SH_HandRecordHeaderView.h"
@interface SH_HandRecordView() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SH_HandRecordHeaderView *headerView;
@end

@implementation SH_HandRecordView
+(instancetype)instanceCardRecordView {
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 95)];
    [v addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = v;
}

-(SH_HandRecordHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"SH_HandRecordHeaderView" owner:nil options:nil] lastObject];
    }
    return _headerView;
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SH_HandRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_HandRecordTableViewCell.h" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_HandRecordTableViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 29;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
