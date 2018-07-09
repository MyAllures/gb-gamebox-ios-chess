//
//  SH_PromoListView.m
//  GameBox
//
//  Created by shin on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoListView.h"
#import "SH_PromoViewCell.h"

@interface SH_PromoListView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SH_PromoListView

- (void)reloadData
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_PromoViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_PromoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoViewCell" owner:nil options:nil] lastObject];
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
