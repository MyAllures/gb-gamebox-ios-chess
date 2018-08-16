//
//  SH_OutCoinDetailView.m
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_OutCoinDetailView.h"
#import "SH_OutCoinDetailTableViewCell.h"
#import "SH_LookJiHeView.h"
#import "SH_NetWorkService+Profit.h"
#import "SH_ConfirSaftyPassWordView.h"
#import "SH_ProfitAlertView.h"
#import "SH_SmallWindowViewController.h"
#import "SH_BigWindowViewController.h"
#import "SH_TopLevelControllerManager.h"
@interface SH_OutCoinDetailView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,strong)NSArray *details;
@property(nonatomic,strong)NSArray *titles;
@property(nonatomic,copy)NSString *token;
@end
@implementation SH_OutCoinDetailView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.titles = @[@"福利账号",@"取款金额",@"手续费",@"行政费",@"扣除优惠",@"最终出币"];
    [self configUI];
}
-(void)configUI{
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
    return 32*screenSize().width/375.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_OutCoinDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_OutCoinDetailTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateUIWithTitle:self.titles[indexPath.row] Detail:self.details[indexPath.row]];
    return cell;
}
- (IBAction)lookJiHeBtnClick:(id)sender {
    SH_LookJiHeView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_LookJiHeView" owner:self options:nil].firstObject;
    SH_BigWindowViewController * acr = [SH_BigWindowViewController new];
    acr.customView = view;
    acr.titleImageName = @"title15";
    acr.title = @"牌局记录";
    acr.modalPresentationStyle = UIModalPresentationCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     UIViewController * svc = [SH_TopLevelControllerManager fetchTopLevelController];
    [svc presentViewController:acr animated:YES completion:nil];
}

- (IBAction)sureOutCoinBtnClick:(id)sender {
    NSString *actualWithdraw = self.details[5];
    if ([actualWithdraw floatValue] <= 0) {
        [self popAlertView:@"最后出币数量应大于0"];
        return;
    }
    SH_ConfirSaftyPassWordView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_ConfirSaftyPassWordView" owner:self options:nil].firstObject;
    view.money = self.details[1];
    view.token = self.token;
    SH_SmallWindowViewController *acr = [SH_SmallWindowViewController new];
    acr.customView = view;
    acr.contentHeight = 210;
    acr.titleImageName = @"title17";
    acr.modalPresentationStyle = UIModalPresentationCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     UIViewController * svc = [SH_TopLevelControllerManager fetchTopLevelController];
    [svc presentViewController:acr animated:YES completion:nil];
    [view updateUIWithDetailArray:nil TargetVC:nil Token:nil];
}

-(void)popAlertView: (NSString *)content{
    SH_ProfitAlertView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_ProfitAlertView" owner:self options:nil].firstObject;
    view.content = content;
    SH_SmallWindowViewController * acr = [SH_SmallWindowViewController new];
    acr.customView = view;
    acr.contentHeight = 202;
    acr.titleImageName =@"title03";
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     UIViewController * svc = [SH_TopLevelControllerManager fetchTopLevelController];
    [svc presentViewController:acr animated:YES completion:nil];
}

- (void)updateUIWithDetailArray:(NSArray *)details
                       TargetVC:(UIViewController *)targetVC
                          Token:(NSString *)token{
    self.details = details;
    self.token = token;
    [self.mainTableView reloadData];
}
@end
