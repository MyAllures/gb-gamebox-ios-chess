//
//  SH_GamesHomeViewController.m
//  GameBox
//
//  Created by Paul on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GamesHomeViewController.h"
#import "SH_WelfareRecordView.h"
#import "AlertViewController.h"
#import "SH_WelfareDetailView.h"
#import "SH_SaftyCenterView.h"
#import "SH_CardRecordView.h"
#import "SH_CardRecordDetailView.h"
@interface SH_GamesHomeViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;
@property (weak, nonatomic) IBOutlet UIView *top_view;
@property (weak, nonatomic) IBOutlet UIView *bottom_view;
@property (weak, nonatomic) IBOutlet UILabel *account_label;
@property (weak, nonatomic) IBOutlet UILabel *money_label;

@property (weak, nonatomic) IBOutlet UIImageView *avatar_imgView;
@end

@implementation SH_GamesHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
}
#pragma mark --- 配置UI
-(void)configUI{
    self.view.backgroundColor = [[UIColor  blackColor] colorWithAlphaComponent:0.5];
    UIImage * img = [UIImage imageNamed:@"top-bg"];
    UIImage * imgs = [UIImage imageNamed:@"menu-bg"];
    self.top_view.layer.contents = (__bridge id _Nullable)(img.CGImage);
    self.bottom_view.layer.contents = (__bridge id _Nullable)(imgs.CGImage);
    
    if (iPhoneX) {
        self.constraintWidth.constant = 200;
        [self.view layoutIfNeeded];
    }
}
- (IBAction)buttonClick:(UIButton *)sender {
    NSInteger  tag = sender.tag-100;
    switch (tag) {
        case 0:{
            SH_WelfareRecordView   *welfare =  [SH_WelfareRecordView instanceWelfareRecordView];
            
            
            AlertViewController *cvc  = [[AlertViewController  alloc] initAlertView:welfare viewHeight:303 titleImageName:@"title09" alertViewType:AlertViewTypeLong];
            
            welfare.backToDetailViewBlock = ^(NSString *searchId,SH_FundListModel * model) {
                SH_WelfareDetailView * detail = [SH_WelfareDetailView  instanceWelfareDetailView];
                detail.searchId = searchId;
                detail.infoModel = model;
                AlertViewController *dvc  = [[AlertViewController  alloc] initAlertView:detail viewHeight:303 titleImageName:@"title09" alertViewType:AlertViewTypeLong];
                [self presentViewController:dvc addTargetViewController:cvc];
            };
            [self presentViewController:cvc addTargetViewController:self];
            break;
        }
        case 1:{
            SH_CardRecordView *crv = [SH_CardRecordView  instanceCardRecordView];
            // 投注记录详情
            AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:crv viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"title10" alertViewType:AlertViewTypeLong];
            crv.backToDetailViewBlock = ^(NSString *info) {
                SH_CardRecordDetailView * cardDetail = [SH_CardRecordDetailView  instanceCardRecordDetailView];
                cardDetail.mId = info;
                AlertViewController *dcr  = [[AlertViewController  alloc] initAlertView:cardDetail viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"title10" alertViewType:AlertViewTypeLong];
                [self presentViewController:dcr addTargetViewController:acr];
            };
            
            [self presentViewController:acr addTargetViewController:self];
            break;
        }
        case 2:{
            SH_SaftyCenterView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_SaftyCenterView" owner:self options:nil].firstObject;
            
            AlertViewController *avc  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-50 titleImageName:@"saftyTtile" alertViewType:AlertViewTypeLong];
            [self presentViewController:avc addTargetViewController:self];
            break;
        }
        case 3:{
            
            break;
        }
        case 4:{
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
}
#pragma mark --- 模态弹出viewController
-(void)presentViewController:(UIViewController*)viewController addTargetViewController:(UIViewController*)targetVC{
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [targetVC presentViewController:viewController animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
