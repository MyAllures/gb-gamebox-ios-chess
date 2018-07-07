//
//  AlertViewController.m
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title_label;

@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self  configurationUI];
}
-(void)configurationUI{
    self.view.backgroundColor = [[UIColor  blackColor] colorWithAlphaComponent:0.7];
    UIImage * img = [UIImage imageNamed:self.imageName.length >0?self.imageName:@""];
    self.view.layer.contents = (__bridge id _Nullable)(img.CGImage);
    self.title_label.text = self.subTitle?self.subTitle:@"充值中心";
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(closeClick:)];
    tap.delegate= self;
    [self.view addGestureRecognizer:tap];
}
- (IBAction)closeClick:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint  point = [touch locationInView:self.view];
    CGPoint chatP = [self.view convertPoint:point toView:self.animationView ];
    if (CGRectContainsPoint(self.animationView.frame, chatP)) {
        return  false;
    }
    return  YES;
    
}

-(void)dealloc{
    
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
