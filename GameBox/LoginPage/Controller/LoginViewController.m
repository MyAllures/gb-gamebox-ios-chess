//
//  LoginViewController.m
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//
#import "LoginViewController.h"
#import "PopTool.h"

#define WIDTH_PERCENT  [UIScreen mainScreen].bounds.size.width/375.0
#define HEIGHT_PERCENT [UIScreen mainScreen].bounds.size.height/667.0
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface LoginViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *leftContrainerView;
@property (weak, nonatomic) IBOutlet UITextField *account_textField;
@property (weak, nonatomic) IBOutlet UITextField *password_textField;
@property (weak, nonatomic) IBOutlet UITextField *check_textField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configurationUI];
}
-(void)configurationUI{
    UIImage  * img = [UIImage  imageNamed:@"left_bg"];
    self.leftContrainerView.layer.contents = (__bridge id _Nullable)(img.CGImage);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tap.delegate= self;
    [self.view addGestureRecognizer:tap];
}
-(void)closeKeyboard{
    [self.view endEditing:YES];
}
- (IBAction)btnClick:(UIButton *)sender {
    
}
-(void)show{
    self.view.frame = CGRectMake(0, 0, 411, 250);
    [[PopTool sharedInstance] showWithPresentView:self.view subTitle:@"登录" AnimatedType:AnimationTypeScale AnimationDirectionType:AnimationDirectionFromLeft];
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
