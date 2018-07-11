//
//  SH_GameAnnouncementView.m
//  GameBox
//
//  Created by sam on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GameAnnouncementView.h"
#import <Masonry/Masonry.h>
#import "SH_GameBulletinTCell.h"

@interface SH_GameAnnouncementView ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SH_GameAnnouncementView

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_GameBulletinTCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
    
//    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
//    [self.view3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_GameBulletinTCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_GameBulletinTCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
