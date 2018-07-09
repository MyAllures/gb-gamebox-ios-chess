//
//  LoginViewController.m
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//
#import "LoginViewController.h"
#import "PopTool.h"
#import "SH_NetWorkService+Login.h"

#define RH_API_NAME_REGISESTCAPTCHACODE        @"captcha/pmregister.html"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *leftContrainerView;
@property (weak, nonatomic) IBOutlet UITextField *account_textField;
@property (weak, nonatomic) IBOutlet UITextField *password_textField;
@property (weak, nonatomic) IBOutlet UITextField *check_textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self fetchHttpData];
    [self configurationUI];
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
    self.leftContrainerView.layer.contents = (__bridge id _Nullable)(img.CGImage);
    self.tableView.hidden = YES;
    self.account_textField.text = @"shin";
    self.password_textField.text = @"h123123";
}

- (IBAction)btnClick:(UIButton *)sender {
    
   NSInteger tag = sender.tag -100;

    switch (tag) {
        case 0:{
            self.tableView.hidden = YES;
             [sender setBackgroundImage:[UIImage imageNamed:@"login_button_click"] forState:UIControlStateNormal];
            UIButton  * btn  = [self.view  viewWithTag:101];
            [btn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
            break;
        }
        case 1:{
            self.tableView.hidden = false;
            [sender setBackgroundImage:[UIImage imageNamed:@"login_button_click"] forState:UIControlStateNormal];
            UIButton  * btn  = [self.view  viewWithTag:100];
            [btn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
            break;
        }
        case 2:{
            [SH_NetWorkService login:self.account_textField.text psw:self.password_textField.text verfyCode:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
                NSUInteger startLocation = [setCookie rangeOfString:@"GMT, "].location +4;
                NSUInteger endLocation = [setCookie rangeOfString:@" rememberMe=deleteMe"].location;
                NSUInteger lenth = endLocation - startLocation;
                NSString *cookie = [setCookie substringWithRange:NSMakeRange(startLocation, lenth)];
                [NetWorkLineMangaer sharedManager].currentCookie = cookie;
                
                [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
                    if (self.dismissBlock) {
                        self.dismissBlock();
                    }
                    
                } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                    //
                }];
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
