//
//  SH_SendMsgView.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SendMsgView.h"
#import "SH_SendMsgTabelViewCell.h"
#import "SH_NetWorkService+Promo.h"
#import "SH_AdvisoryTypeModel.h"

@interface SH_SendMsgView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SH_SendMsgView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self configUI];
}

-(void)configUI {
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_SendMsgTabelViewCell" bundle:nil] forCellReuseIdentifier:@"SH_SendMsgTabelViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SH_SendMsgTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_SendMsgTabelViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_SendMsgTabelViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pickView" object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementationSH_SendMsgView adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
