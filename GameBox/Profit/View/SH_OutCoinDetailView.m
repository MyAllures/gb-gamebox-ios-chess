//
//  SH_OutCoinDetailView.m
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_OutCoinDetailView.h"
#import "SH_OutCoinDetailTableViewCell.h"
#import "AlertViewController.h"
#import "SH_LookJiHeView.h"
#import "SH_NetWorkService+Profit.h"
#import "SH_ConfirSaftyPassWordView.h"
@interface SH_OutCoinDetailView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,strong)NSArray *details;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,strong)UIViewController *targetVC;
@property(nonatomic,copy)NSString *token;
@end
@implementation SH_OutCoinDetailView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titles = @[@"福利账号",@"取款金额",@"手续费",@"行政费",@"扣除优惠",@"最终出币"];
    [self configUI];
}
-(void)configUI{
    self.bgView.layer.borderWidth = 2;
    self.bgView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SH_OutCoinDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_OutCoinDetailTableViewCell"];
}
#pragma mark--
#pragma mark--tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_OutCoinDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_OutCoinDetailTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateUIWithTitle:self.titles[indexPath.row] Detail:self.details[indexPath.row]];
    return cell;
}
- (IBAction)lookJiHeBtnClick:(id)sender {
    SH_LookJiHeView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_LookJiHeView" owner:self options:nil].firstObject;
    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-77 titleImageName:@"lookProfit" alertViewType:AlertViewTypeLong];
    acr.title = @"牌局记录";
    acr.modalPresentationStyle = UIModalPresentationCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.targetVC presentViewController:acr animated:YES completion:nil];
    view.targetVC = acr;
}
- (IBAction)sureOutCoinBtnClick:(id)sender {
    SH_ConfirSaftyPassWordView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_ConfirSaftyPassWordView" owner:self options:nil].firstObject;
    view.money = self.details[1];
    view.token = self.token;
    view.targetVC = self.targetVC;
    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-175 titleImageName:@"title17" alertViewType:AlertViewTypeLong];
    acr.title = @"牌局记录";
    acr.modalPresentationStyle = UIModalPresentationCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.targetVC presentViewController:acr animated:YES completion:nil];

}
- (void)updateUIWithDetailArray:(NSArray *)details
                       TargetVC:(UIViewController *)targetVC
                          Token:(NSString *)token{
    self.targetVC = targetVC;
    self.details = details;
    self.token = token;
    [self.mainTableView reloadData];
}
@end
