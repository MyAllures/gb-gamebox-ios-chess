//
//  SH_LoginView.m
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_LoginView.h"
#import "SH_NetWorkService.h"
#import "SH_NetWorkService+Login.h"
#import "AppDelegate.h"
#import "RH_UserInfoManager.h"
#import "RH_WebsocketManagar.h"
#import "SH_NetWorkService+RegistAPI.h"
#import "UIColor+HexString.h"
#import "RH_MineInfoModel.h"
#import "RH_RegisetInitModel.h"
#import "RH_RegistrationViewItem.h"
#import "SH_RegistView.h"
#import "SH_BankCardModel.h"
#import "UIImage+SH_WebPImage.h"
#import "SH_TimeZoneManager.h"
#import "SH_FindPSWView.h"
#import "AlertViewController.h"
#import "SH_SafeCenterAlertView.h"
#import "SH_CustomerServiceManager.h"

@interface SH_LoginView(){
     RH_RegisetInitModel *registrationInitModel;
}
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UITextField *account_textField;
@property (weak, nonatomic) IBOutlet UITextField *password_textField;
@property (weak, nonatomic) IBOutlet UITextField *check_textField;
@property (weak, nonatomic) IBOutlet UIImageView *check_image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCaptchaHeight;
@property (weak, nonatomic) IBOutlet UIView *rightContrainerView;
@property (weak, nonatomic) IBOutlet UILabel *captcha_label;

@property (nonatomic,assign) BOOL isOpenCaptcha ;
@property (nonatomic,assign) BOOL isLogin;



/**
 stackView 注册页面的容器
 */
@property (weak, nonatomic) IBOutlet UIView *stackView;

/**
 registView 注册页面
 */
@property (nonatomic,strong)SH_RegistView  * registView;
@end
@implementation SH_LoginView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- Create  SH_LoginView
+(instancetype)InstanceLoginView{
    return  [[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil] lastObject];
}
-(void)awakeFromNib{
    [super  awakeFromNib];
    [self  fetchHttpData];
    [self  configurationUI];
}
#pragma mark -- 登录是否需要验证码 返回bool
-(void)fetchHttpData{
    __weak  typeof(self) weakSelf = self;
    [SH_NetWorkService  fetchIsOpenCodeVerifty:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *result = ConvertToClassPointer(NSDictionary, response) ;
        weakSelf.isOpenCaptcha = [result boolValueForKey:@"isOpenCaptcha"];
        if (weakSelf.isOpenCaptcha) {
            [weakSelf  startGetVerifyCode];
            weakSelf.captcha_label.hidden = false;
            weakSelf.check_textField.hidden = false;
            weakSelf.constraintCaptchaHeight.constant = 33;
            [weakSelf  layoutIfNeeded];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

#pragma mark -- 配置UI
-(void)configurationUI{
    
    self.stackView.hidden = YES;
    self.captcha_label.hidden = YES;
    self.check_textField.hidden = YES;
    
    UIImage  * img = [UIImage imageWithWebPImageName:@"left_bgImage"];
    self.leftView.layer.contents = (__bridge id _Nullable)(img.CGImage);
   
    self.check_image.userInteractionEnabled = YES;
    UITapGestureRecognizer  * tap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(startGetVerifyCode)];
    [self.check_image addGestureRecognizer:tap];
    
    
    UIButton * sender = [self viewWithTag:103];
    NSUserDefaults  * dafault = [NSUserDefaults  standardUserDefaults];
    NSString * account = [dafault objectForKey:@"account"];
    self.account_textField.text = account;
    if (account.length==0) {
        [dafault setBool:YES forKey:@"isRememberPwd"];
        [dafault synchronize];
    }
    if ([dafault  boolForKey:@"isRememberPwd"]) {
        self.password_textField.text = [dafault objectForKey:@"password"];
        [sender setImage:[UIImage imageWithWebPImageName:@"select2"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageWithWebPImageName:@"unselect2"] forState:UIControlStateNormal];
    }
   
}

#pragma mark --  登录输错密码之后的验证码
-(void)startGetVerifyCode
{
    __weak  typeof(self) weakSelf = self;
    [SH_NetWorkService  fetchVerifyCode:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if ([response isKindOfClass:[NSData  class]]) {
            NSData * data =(NSData * ) response;
            weakSelf.check_image.image = [UIImage  imageWithData:data];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, err);
    }];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark --  button click method
- (IBAction)btnlick:(SH_WebPButton *)sender {
    NSInteger tag = sender.tag -100;
   
    switch (tag) {
        case 0:{ //登陆按钮的点击事件
            self.stackView.hidden = YES;
            [sender setWebpBGImage:@"login_button_click" forState:UIControlStateNormal];
            SH_WebPButton  * btn  = [self  viewWithTag:101];
            [btn setWebpBGImage:@"login_button" forState:UIControlStateNormal];
            if (self.changeChannelBlock) {
                self.changeChannelBlock(@"title01");
            }
            break;
        }
        case 1:{//注册按钮的点击事件
            self.stackView.hidden = false;
            [self.stackView addSubview:self.registView];
            [self.registView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            [sender setWebpBGImage:@"login_button_click" forState:UIControlStateNormal];
            SH_WebPButton  * btn  = [self  viewWithTag:100];
            [btn setWebpBGImage:@"login_button" forState:UIControlStateNormal];
            if (self.changeChannelBlock) {
                self.changeChannelBlock(@"title02");
            }
            break;
        }
        case 2:{
            [self whetherConformCondition] ;

            break;
        }
        case 3:{
            NSUserDefaults  * dafault = [NSUserDefaults  standardUserDefaults];
            BOOL isSelect  = [dafault  boolForKey:@"isRememberPwd"];
            [dafault setBool:!isSelect forKey:@"isRememberPwd"];
            [dafault  synchronize];
          
            if ([dafault boolForKey:@"isRememberPwd"]) {
                 [sender setImage:[UIImage imageWithWebPImageName:@"select2"] forState:UIControlStateNormal];
            }else{
                 [sender setImage:[UIImage imageWithWebPImageName:@"unselect2"] forState:UIControlStateNormal];
            }
            
            break;
        }
        case 4:{
            [SH_NetWorkService_FindPsw checkForgetPswStatusComplete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSDictionary *dict = (NSDictionary *)response;
                NSLog(@"dict===%@",dict);
                NSString *dataStr = dict[@"data"];
                if ([dataStr intValue] == 0) {
                    SH_FindPSWView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_FindPSWView" owner:self options:nil].firstObject;
                    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:200 titleImageName:@"title19" alertViewType:AlertViewTypeShort];
                    view.targetVC1 = acr;
                    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    [self.targetVC presentViewController:acr animated:YES completion:nil];
                } else{
                    [self popAlertView];
                }
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
            break;
        }
        default:
            break;
    }
    
}

-(void)popAlertView {
    SH_SafeCenterAlertView * alert = [SH_SafeCenterAlertView  instanceSafeCenterAlertView];
    AlertViewController * acr = [[AlertViewController  alloc] initAlertView:alert viewHeight:174 titleImageName:@"title03" alertViewType:AlertViewTypeShort];
    alert.vc = acr;
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.targetVC presentViewController:acr animated:YES completion:nil];
}

#pragma mark --  简单的非空判断
-(void)whetherConformCondition{
    
    if (self.account_textField.text.length<1){
        showAlertView(@"提示", @"用户名不能为空!") ;
        [self.account_textField becomeFirstResponder] ;
        return ;
    }
    
    if (self.password_textField.text.length<1){
        showAlertView(@"提示", @"密码不能为空!") ;
        [self.password_textField becomeFirstResponder] ;
        return ;
    }
    
    if (self.captcha_label.hidden==false){
        if (self.check_textField.text.length<1){
            showAlertView(@"提示", @"验证码不能为空!") ;
            [self.check_textField becomeFirstResponder] ;
            return ;
        }
    }
    [self  login];
}

#pragma mark --  登录
-(void)login{
     UIWindow  * window = [UIApplication  sharedApplication].keyWindow;
    MBProgressHUD *hud =showHUDWithMyActivityIndicatorView(self, nil, @"正在登录...");
     __weak  typeof(self) weakSelf = self;
    [SH_NetWorkService login:self.account_textField.text psw:self.password_textField.text verfyCode:self.check_textField.text complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        [hud hideAnimated:false];
        NSDictionary *result = ConvertToClassPointer(NSDictionary, response) ;
        if ([result boolValueForKey:@"success"]){
            [weakSelf  loginSucessHandleRsponse:result httpURLResponse:httpURLResponse];
        }else{
            weakSelf.isOpenCaptcha = [result boolValueForKey:@"isOpenCaptcha"];
            if (!weakSelf.isOpenCaptcha) {
                weakSelf.captcha_label.hidden = YES;
                weakSelf.check_textField.hidden = YES;
                weakSelf.constraintCaptchaHeight.constant = 0;
                [weakSelf  layoutIfNeeded];
            }else{
                [weakSelf  startGetVerifyCode];
                weakSelf.captcha_label.hidden = false;
                weakSelf.check_textField.hidden = false;
                weakSelf.constraintCaptchaHeight.constant = 33;
                [weakSelf  layoutIfNeeded];
            }
            [weakSelf  loginFailHandleRsponse:result];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        //
         [hud hideAnimated:false];
         showMessage(window, err, nil);
    }];
}


#pragma mark --  登录成功
-(void)loginSucessHandleRsponse:(NSDictionary*)dic httpURLResponse:(NSHTTPURLResponse *)httpURLResponse{
    UIWindow  * window = [UIApplication  sharedApplication].keyWindow;
    
    [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:self.account_textField.text
                                                             LoginTime:[[SH_TimeZoneManager sharedManager] timeStringFrom:[[NSDate date] timeIntervalSince1970] format:@"yyyy-MM-dd HH:mm:ss"]] ;
    
    [[NetWorkLineMangaer sharedManager] configCookieAndSid:httpURLResponse];

    [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        
        NSDictionary * dict = ConvertToClassPointer(NSDictionary, response);
        if ([dict  boolValueForKey:@"success"]) {
            NSError *err;
            NSArray *arr = [SH_BankListModel arrayOfModelsFromDictionaries:response[@"data"][@"bankList"] error:&err];
            [[RH_UserInfoManager shareUserManager] setBankList:arr];
            NSError *err2;
            RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[response[@"data"] objectForKey:@"user"] error:&err2];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];

            showMessage(window, @"登录成功", nil);
            
            [[RH_UserInfoManager  shareUserManager] updateIsLogin:YES];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.account_textField.text forKey:@"account"];
            [defaults setObject:self.password_textField.text forKey:@"password"];
            [defaults synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SH_LOGIN_SUCCESS" object:nil];
            if (self.dismissBlock) {
                self.dismissBlock();
            }
        }else{
             showMessage(window, [dict objectForKey:@"message"], nil);
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
        showMessage(window, err, nil);
    }];
    
}

#pragma mark --  登录失败
-(void)loginFailHandleRsponse:(NSDictionary*)result{

    UIWindow  * window = [UIApplication  sharedApplication].keyWindow;
    
    if (![[result objectForKey:@"message"] isEqual:[NSNull null]]) {
        if ([[result objectForKey:@"message"] isEqualToString:@"账号被冻结"]) {
            showMessage(window, @"您的账号已被冻结，请联系客服", nil);
        }else if([[result objectForKey:@"message"] isEqualToString:@"账号被停用"]){
            showMessage(window, @"您账户已被停用,暂不支持登录", nil) ;
        }else
        {
            showMessage(window, @"用户名或密码错误", nil);
        }
    }else if(![[result objectForKey:@"propMessages"] isEqual:[NSNull null]])
    {
        if ([[result objectForKey:@"propMessages"] objectForKey:@"captcha"]) {
            showMessage(window, [[result objectForKey:@"propMessages"] objectForKey:@"captcha"], nil);
        }
    }
}

#pragma mark -- getter  method

-(SH_RegistView *)registView{
    if (!_registView) {
        _registView = [[SH_RegistView  alloc]init];
        _registView.backgroundColor = [UIColor colorWithHexStr:@"0x4854A9"];
        __weak typeof(self) weakSelf = self;
        _registView.closeAlerViewBlock = ^{
            if (weakSelf.dismissBlock) {
                weakSelf.dismissBlock();
            }
        };
    }
    return  _registView;
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
    self.registView.targetVC = targetVC;
}
@end
