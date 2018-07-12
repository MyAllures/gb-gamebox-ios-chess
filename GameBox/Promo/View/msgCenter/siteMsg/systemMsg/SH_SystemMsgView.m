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

@interface SH_SystemMsgView () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SH_SystemMsgView

-(void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_SiteMsgViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_SiteMsgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_SiteMsgViewCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
