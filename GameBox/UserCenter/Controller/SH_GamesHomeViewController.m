//
//  SH_GamesHomeViewController.m
//  GameBox
//
//  Created by Paul on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GamesHomeViewController.h"
#import "SH_SaftyCenterView.h"
#import "SH_NetWorkService+RegistAPI.h"
#import "UIImage+SH_WebPImage.h"
#import "SH_WebPButton.h"
#import "SH_WelfareNotesView.h"
#import "SH_HandRecordView.h"
#import "SH_CustomerServiceManager.h"

#import "SH_BigWindowViewController.h"
#import "SH_SmallWindowViewController.h"
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
    [self loadUserInfomationData];
}
#pragma mark --- 配置UI
-(void)configUI{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"dismiss" object:nil];
    self.view.backgroundColor = [[UIColor  blackColor] colorWithAlphaComponent:0.5];
    UIImage *img = [UIImage imageWithWebPImageName:@"top-bg"];
    UIImage *imgs = [UIImage imageWithWebPImageName:@"menu-bg"];
    self.top_view.layer.contents = (__bridge id _Nullable)(img.CGImage);
    self.bottom_view.layer.contents = (__bridge id _Nullable)(imgs.CGImage);
    self.account_label.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.username;
    self.money_label.text = [NSString  stringWithFormat:@"%.2f",[RH_UserInfoManager shareUserManager].mineSettingInfo.walletBalance];
    if ([RH_UserInfoManager  shareUserManager].isLogin) {
        if ([RH_UserInfoManager shareUserManager].mineSettingInfo.userSex.length > 0) {
            if ([[RH_UserInfoManager shareUserManager].mineSettingInfo.userSex isEqualToString:@"男"]) {
                self.avatar_imgView.image = [UIImage imageWithWebPImageName:@"photo_male"];
            } else  if ([[RH_UserInfoManager shareUserManager].mineSettingInfo.userSex isEqualToString:@"女"]){
                self.avatar_imgView.image = [UIImage imageWithWebPImageName:@"photo_female"];
            } else {
                self.avatar_imgView.image = [UIImage imageWithWebPImageName:@"photo_male"];
            }
        } else {
            self.avatar_imgView.image = [UIImage imageWithWebPImageName:@"photo_male"];
        }
        //刷新随身福利
    }else{
        self.avatar_imgView.image = [UIImage imageWithWebPImageName:@"avatar"];
    }
    if (iPhoneX) {
        self.constraintWidth.constant = 200;
        [self.view layoutIfNeeded];
    }
}
#pragma mark --- 获取玩家个人信息数据
-(void)loadUserInfomationData{
    __weak  typeof(self)  weakSelf = self;
    [SH_NetWorkService  fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary * dict = ConvertToClassPointer(NSDictionary, response);
        if ([dict[@"code"] isEqualToString:@"0"]) {
            NSError *err;
            NSArray *arr = [SH_BankListModel arrayOfModelsFromDictionaries:response[@"data"][@"bankList"] error:&err];
            [[RH_UserInfoManager shareUserManager] setBankList:arr];
            RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[dict[@"data"] objectForKey:@"user"] error:nil];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];
            //通知首页余额刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"configUI" object:nil];
            [weakSelf  configUI];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
#pragma  mark --- 玩家中心界面跳转
- (IBAction)buttonClick:(UIButton *)sender {
    NSInteger  tag = sender.tag-100;
    switch (tag) {
        case 0:{
            //福利记录
            SH_WelfareNotesView   *welfare =  [SH_WelfareNotesView instanceWelfareRecordView];
            SH_BigWindowViewController * cvc = [SH_BigWindowViewController new];
            cvc.customView = welfare;
            cvc.titleImageName = @"title09";
            //             welfare.vc = cvc;
            [self presentViewController:cvc addTargetViewController:self];

            break;
        }
        case 1:{
            //牌局记录
            SH_HandRecordView *crv = [SH_HandRecordView  instanceCardRecordView];
            // 投注记录详情
            SH_BigWindowViewController * acr = [SH_BigWindowViewController new];
            acr.customView = crv;
            acr.titleImageName = @"title10";
            [self presentViewController:acr addTargetViewController:self];
            
            break;
        }
        case 2:{
            // 安全中心
            SH_SaftyCenterView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_SaftyCenterView" owner:self options:nil].firstObject;
            SH_BigWindowViewController *avc = [SH_BigWindowViewController new];
            avc.customView = view;
            avc.titleImageName = @"title12";
            [self presentViewController:avc addTargetViewController:self];
            view.targetVC = avc;
            break;
        }
        case 3:{
            //联系客服
            [[SH_CustomerServiceManager sharedManager] open];
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

-(void)dismiss {
    [self dismiss:nil];
}
- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
