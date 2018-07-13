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
@property (weak, nonatomic) IBOutlet UILabel *title_label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property(nonatomic,strong)UIView  * presentView;

@property(nonatomic,assign)CGFloat viewHeight;
@property(nonatomic,assign)CGFloat viewWidth;

@property(nonatomic, strong) NSString *startAndEndDateStr;
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(seleteDate) name:@"seleteDate" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seleteEndTime:) name:@"seleteEndTime" object:nil];
}
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
-(void)setImageName:(NSString *)imageName{
//    UIImage * img = [UIImage imageNamed:self.imageName.length >0?self.imageName:@""];
//    self.headImage.layer.contents = (__bridge id _Nullable)(img.CGImage);
    self.headImage.image = [UIImage imageNamed:imageName];
    [self.view layoutIfNeeded];
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
