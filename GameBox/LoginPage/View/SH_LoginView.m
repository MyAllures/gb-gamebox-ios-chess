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
    [self  fetchHttpData];
    [self  configurationUI];
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
    self.account_textField.text = @"shin";
    self.password_textField.text = @"h123123";
    
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
    __weak  typeof(self) weakSelf = self;
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
            AppDelegate * appDelegate =(AppDelegate*)[UIApplication  sharedApplication].delegate;
            UIWindow  * window = [UIApplication  sharedApplication].keyWindow;
            [SH_NetWorkService login:self.account_textField.text psw:self.password_textField.text verfyCode:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSDictionary *result = ConvertToClassPointer(NSDictionary, response) ;
                weakSelf.isOpenCaptcha = [result boolValueForKey:@"isOpenCaptcha"];
                if (!weakSelf.isOpenCaptcha) {
                    weakSelf.captcha_label.hidden = YES;
                    weakSelf.constraintCaptchaHeight.constant = 0;
                    [self  layoutIfNeeded];
                }else{
                    weakSelf.captcha_label.hidden = false;
                    weakSelf.constraintCaptchaHeight.constant = 33;
                    [self  layoutIfNeeded];
                }
                if ([result boolValueForKey:@"success"]){
                    NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
                    NSUInteger startLocation = [setCookie rangeOfString:@"GMT, "].location +4;
                    NSUInteger endLocation = [setCookie rangeOfString:@" rememberMe=deleteMe"].location;
                    NSUInteger lenth = endLocation - startLocation;
                    NSString *cookie = [setCookie substringWithRange:NSMakeRange(startLocation, lenth)];
                    [NetWorkLineMangaer sharedManager].currentCookie = cookie;
                    
                    [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
                        showMessage(window, @"登录成功", nil);
                        if (self.dismissBlock) {
                            //                        self.dismissBlock();
                        }
                        
                    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                        //
                    }];
                }else{
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
                
            } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
                //
            }];
            break;
        }
        case 3:{
            
            break;
        }
        default:
            break;
    }
    
}

@end
