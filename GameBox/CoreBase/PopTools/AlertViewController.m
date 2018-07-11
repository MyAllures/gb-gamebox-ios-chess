//
//  AlertViewController.m
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "AlertViewController.h"
#import <Masonry.h>
@interface AlertViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property(nonatomic,strong)UIView  * presentView;

@property(nonatomic,assign)CGFloat viewHeight;
@property(nonatomic,assign)CGFloat viewWidth;
@end

@implementation AlertViewController

-(instancetype)initAlertView:(UIView*)view viewHeight:(CGFloat)height viewWidth:(CGFloat)width{
    if (self = [super  init]) {
        self.viewHeight = height +50;
        self.viewWidth = width+40;
        self.presentView = view;
        
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self  configurationUI];
}
-(void)configurationUI{
    
    self.view.backgroundColor = [[UIColor  blackColor] colorWithAlphaComponent:0.7];
    UIImage * img = [UIImage imageNamed:self.imageName.length >0?self.imageName:@""];
    self.view.layer.contents = (__bridge id _Nullable)(img.CGImage);
    self.title_label.text = self.subTitle?self.subTitle:self.title;
    
    self.constraintHeight.constant = self.viewHeight;
    self.constraintWidth.constant = self.viewWidth;
    [self.view  layoutIfNeeded];
   

    [self.containerView addSubview:self.presentView];
    [self.presentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containerView);
    }];

}
- (IBAction)closeClick:(id)sender {

    [self  dismissViewControllerAnimated:YES completion:nil];
}
-(void)close{
    [self closeClick:nil];
}
-(void)setImageName:(NSString *)imageName{
//    UIImage * img = [UIImage imageNamed:self.imageName.length >0?self.imageName:@""];
//    self.headImage.layer.contents = (__bridge id _Nullable)(img.CGImage);
    self.headImage.image = [UIImage imageNamed:imageName];
    [self.view layoutIfNeeded];
}
-(void)dealloc{
    NSLog(@"clean .......");
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
