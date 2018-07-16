//
//  SH_PreferentialPopSubView.m
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PreferentialPopSubView.h"
#import "SH_PopSubViewTableViewCell.h"
@interface SH_PreferentialPopSubView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *msgLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *discountLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,copy)NSString  *activityId;
@end
@implementation SH_PreferentialPopSubView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configUI];
}
-(void)configUI{
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.layer.cornerRadius = 5.f;
    self.mainTableView.layer.masksToBounds = YES;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SH_PopSubViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"SH_PopSubViewTableViewCell"];
}
#pragma mark--
#pragma mark--tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_PopSubViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_PopSubViewTableViewCell"];
    [cell updateUIWithSaleDetailModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_BitCoinSaleDetailModel *model = self.dataArray[indexPath.row];
    self.activityId = model.ID;
    
}
- (IBAction)sureBtnClick:(id)sender {
    [UIView animateWithDuration:0.6 animations:^{
        self.center = CGPointMake(self.superview.center.x, screenSize().height+200);
    } completion:^(BOOL finished) {
       [self.delegate selectedActivityId:self.activityId];
       [self.superview removeFromSuperview];
    }];
    
}
-(void)updateUIWithSaleModel:(SH_BitCoinSaleModel *)model moneyString:(NSString *)money{
    self.moneyLab.text = money;
    self.msgLab.text = model.msg;
    self.dataArray = model.sales;
    if (self.dataArray.count == 0) {
        self.discountLab.hidden = YES;
        self.mainTableView.hidden = YES;
    }else{
        [self.mainTableView reloadData];
    }
}
@end
