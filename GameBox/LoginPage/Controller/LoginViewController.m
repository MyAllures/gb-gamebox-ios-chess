//
//  LoginViewController.m
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//
#import "LoginViewController.h"
#import "PopTool.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *leftContrainerView;

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
}
- (IBAction)btnClick:(UIButton *)sender {
    
}
-(void)show{
    self.view.frame = CGRectMake(0, 0, 411, 268);
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
