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
@interface SH_LoginView()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UITextField *account_textField;
@property (weak, nonatomic) IBOutlet UITextField *password_textField;
@property (weak, nonatomic) IBOutlet UITextField *check_textField;
@property (weak, nonatomic) IBOutlet UIImageView *check_image;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCaptchaHeight;
@property (weak, nonatomic) IBOutlet UILabel *captcha_label;

@property (nonatomic,assign) BOOL isOpenCaptcha ;
@property (nonatomic,assign) BOOL isLogin;

@end
@implementation SH_LoginView
+(instancetype)InstanceLoginView{
    return  [[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil] lastObject];
}
-(void)awakeFromNib{
    [super  awakeFromNib];
//    [self  fetchHttpData];
//    [self  configurationUI];
    [self startGetVerifyCode];
}
-(void)fetchHttpData{
    [SH_NetWorkService  fetchCaptchaCodeInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSLog(@"----%@",response);
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        NSLog(@"----%@",err);
    }];
}
-(void)configurationUI{
    UIImage  * img = [UIImage  imageNamed:@"left_bg"];
    self.leftView.layer.contents = (__bridge id _Nullable)(img.CGImage);
    self.tableView.hidden = YES;
    self.account_textField.text = @"sm0089";
    self.password_textField.text = @"h123123";
    
    self.check_image.userInteractionEnabled = YES;
    
    UITapGestureRecognizer  * tap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(startGetVerifyCode)];
    [self.check_image addGestureRecognizer:tap];
}
-(void)startGetVerifyCode
{
    [SH_NetWorkService fetchVerifyCodexxx:^(NSHTTPURLResponse *httpURLResponse, id response) {

        NSLog(@"%@-------",response);
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, err);
    }];

//@"http://test01.ampinplayopt0matrix.com/captcha/code.html"
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnlick:(UIButton *)sender {
    NSInteger tag = sender.tag -100;
   
    switch (tag) {
        case 0:{
            self.tableView.hidden = YES;
            [sender setBackgroundImage:[UIImage imageNamed:@"login_button_click"] forState:UIControlStateNormal];
            UIButton  * btn  = [self  viewWithTag:101];
            [btn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
            break;
        }
        case 1:{
            self.tableView.hidden = false;
            [sender setBackgroundImage:[UIImage imageNamed:@"login_button_click"] forState:UIControlStateNormal];
            UIButton  * btn  = [self  viewWithTag:100];
            [btn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
            break;
        }
        case 2:{
            [self whetherConformCondition] ;

            break;
        }
        case 3:{
            
            break;
        }
        default:
            break;
    }
    
}
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

/**
 登录
 */
-(void)login{
     __weak  typeof(self) weakSelf = self;
    [SH_NetWorkService login:self.account_textField.text psw:self.password_textField.text verfyCode:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *result = ConvertToClassPointer(NSDictionary, response) ;
        weakSelf.isOpenCaptcha = [result boolValueForKey:@"isOpenCaptcha"];
        if (!weakSelf.isOpenCaptcha) {
            weakSelf.captcha_label.hidden = YES;
            weakSelf.constraintCaptchaHeight.constant = 0;
            [weakSelf  layoutIfNeeded];
        }else{
            [weakSelf  startGetVerifyCode];
            weakSelf.captcha_label.hidden = false;
            weakSelf.constraintCaptchaHeight.constant = 33;
            [weakSelf  layoutIfNeeded];
        }
        if ([result boolValueForKey:@"success"]){
            [weakSelf  loginSucessHandleRsponse:result httpURLResponse:httpURLResponse];
        }else{
            [weakSelf  loginFailHandleRsponse:result];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        //
    }];
}

/**
 登录成功

 @param dic <#dic description#>
 @param httpURLResponse <#httpURLResponse description#>
 */
-(void)loginSucessHandleRsponse:(NSDictionary*)dic httpURLResponse:(NSHTTPURLResponse *)httpURLResponse{
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication  sharedApplication].delegate;
    UIWindow  * window = [UIApplication  sharedApplication].keyWindow;
    
    [appDelegate updateLoginStatus:YES] ;
    
    [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:self.account_textField.text
                                                             LoginTime:dateStringWithFormatter([NSDate date], @"yyyy-MM-dd HH:mm:ss")] ;
    NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
    NSUInteger startLocation = [setCookie rangeOfString:@"GMT, "].location +4;
    NSUInteger endLocation = [setCookie rangeOfString:@" rememberMe=deleteMe"].location;
    NSUInteger lenth = endLocation - startLocation;
    NSString *cookie = [setCookie substringWithRange:NSMakeRange(startLocation, lenth)];
    [NetWorkLineMangaer sharedManager].currentCookie = cookie;
    
    [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        showMessage(window, @"登录成功", nil);
        
        //登录成功后测试websocket
        [[RH_WebsocketManagar instance] SRWebSocketOpenWithURLString:appDelegate.domain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketdidReceiveMessageNote object:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *account = [defaults stringForKey:@"account"] ;

        
        [defaults setObject:self.account_textField.text forKey:@"account"];
        [defaults setObject:self.password_textField.text forKey:@"password"];
//        [defaults setObject:@(self.loginViewCell.isRemberPassword) forKey:@"loginIsRemberPassword"] ;
        [defaults synchronize];
        if (self.dismissBlock) {
             self.dismissBlock();
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
    }];
    
}

/**
 登录失败

 @param result <#result description#>
 */
-(void)loginFailHandleRsponse:(NSDictionary*)result{
    AppDelegate * appDelegate =(AppDelegate*)[UIApplication  sharedApplication].delegate;
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
    [appDelegate updateLoginStatus:NO] ;
}
@end
