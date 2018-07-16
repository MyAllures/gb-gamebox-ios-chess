//
//  AlertViewController.m
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "AlertViewController.h"
#import <Masonry.h>
#import "PGDatePicker.h"
#import "PGDatePickManager.h"
#import "AppDelegate.h"

@interface AlertViewController ()<UIGestureRecognizerDelegate, PGDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *title_imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property(nonatomic,strong)UIView  * presentView;
@property(nonatomic,copy)NSString * imageName;
@property(nonatomic,assign)CGFloat viewHeight;
@property(nonatomic,assign)CGFloat viewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnContrainsHeight;

@property (weak, nonatomic) IBOutlet UIButton *shutBtn;
@property(nonatomic, strong) NSString *startAndEndDateStr;
@end

@implementation AlertViewController

-(instancetype)initAlertView:(UIView*)view
                  viewHeight:(CGFloat)height
              titleImageName:(NSString*)imageName
               alertViewType:(AlertViewType)type{
    if (self = [super  init]) {
        
        self.view.backgroundColor = [[UIColor  blackColor] colorWithAlphaComponent:0.7];

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
            self.title_imageView.image = [UIImage  imageNamed:img_name];
        });
        
        
        [self.containerView addSubview:self.presentView];
        [self.presentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(seleteDate) name:@"seleteDate" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seleteEndTime:) name:@"seleteEndTime" object:nil];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds byRoundingCorners: UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.containerView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.self.containerView.layer.mask = maskLayer;
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
/*
-(void)configurationUI{
    
    self.view.backgroundColor = [[UIColor  blackColor] colorWithAlphaComponent:0.7];

    self.constraintHeight.constant = self.viewHeight;
    self.constraintWidth.constant = self.viewWidth;
    [self.view  layoutIfNeeded];
   

    [self.containerView addSubview:self.presentView];
    [self.presentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containerView);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(seleteDate) name:@"seleteDate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seleteEndTime:) name:@"seleteEndTime" object:nil];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds byRoundingCorners: UIRectCornerBottomRight|UIRectCornerBottomLeft cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.containerView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.self.containerView.layer.mask = maskLayer;
    
}
 */
-(void)seleteDate{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyle1;
    datePickManager.isShadeBackgroud = true;
    
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    [self presentViewController:datePickManager animated:false completion:nil];
}
-(void)seleteEndTime:(NSNotification *)nt {
    self.startAndEndDateStr = nt.userInfo[@"isEnd"];
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyle1;
    datePickManager.isShadeBackgroud = true;
    
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    
    [self presentViewController:datePickManager animated:false completion:nil];
}

- (IBAction)closeClick:(id)sender {

    [self  dismissViewControllerAnimated:YES completion:nil];
}
-(void)close{
    [self closeClick:nil];
}

#pragma mark - PGDatePickerDelegate M
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSString *month ;
    NSString *day;
    if (dateComponents.month < 10) {
        month = [NSString stringWithFormat:@"0%@",@(dateComponents.month)];
    }else{
        month = [NSString stringWithFormat:@"%@",@(dateComponents.month)];
    }
    
    if (dateComponents.day < 10) {
        day = [NSString stringWithFormat:@"0%@",@(dateComponents.day)];
    }else{
        day = [NSString stringWithFormat:@"%@",@(dateComponents.day)];
    }
    if ([self.startAndEndDateStr isEqualToString:@"end"]) {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year),month,day];
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:dateStr,@"date",nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"seletedEndDate" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        self.startAndEndDateStr = @"";
    } else {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year),month,day];
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:dateStr,@"date",nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"seletedDate" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

-(void)setImageName:(NSString *)imageName{
    self.headImage.image = [UIImage imageNamed:imageName];

}
-(void)dealloc{
    NSLog(@"clean .......");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"seleteDate" object:nil];
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
