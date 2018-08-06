 //
//  AlertViewController.m
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "AlertViewController.h"
#import <Masonry.h>
#import "AppDelegate.h"
#import "UIImage+SH_WebPImage.h"

@interface AlertViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet SH_WebPImageView *title_imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property(nonatomic,strong)UIView  * presentView;
@property(nonatomic,assign)CGFloat viewHeight;
@property(nonatomic,assign)CGFloat viewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnContrainsHeight;


@property(nonatomic, strong) NSString *startAndEndDateStr;
@end

@implementation AlertViewController

-(instancetype)initAlertView:(UIView*)view
                  viewHeight:(CGFloat)height
              titleImageName:(NSString*)imageName
               alertViewType:(AlertViewType)type{
    if (self = [super  init]) {
        
        self.view.backgroundColor = [[UIColor  blackColor] colorWithAlphaComponent:0.5];
        _imageName = imageName;
        self.viewHeight = height +50;
        NSString  * img_name;
        if (type ==AlertViewTypeLong) {
            img_name = @"title_bg";
            self.btnContrainsHeight.constant = 40;
            self.constraintHeight.constant = height +50;
            self.constraintWidth.constant = 526;
            [self.view  layoutIfNeeded];
        }else{
            img_name = @"title_bg";
            self.btnContrainsHeight.constant = 32;
            self.constraintHeight.constant = height +50;
            self.constraintWidth.constant = 357;
            [self.view  layoutIfNeeded];
        }
        [self.view  layoutIfNeeded];
        self.presentView = view;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.headImage.image = [UIImage  imageNamed:imageName];
            self.title_imageView.imageName = img_name;
        });
        [self.containerView addSubview:self.presentView];
        [self.presentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds byRoundingCorners: UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.containerView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.containerView.layer.mask = maskLayer;
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)closeClick:(id)sender {

    [self  dismissViewControllerAnimated:YES completion:nil];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
-(void)close{
    [self closeClick:nil];
}


-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.headImage.image = [UIImage imageNamed:_imageName];
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
