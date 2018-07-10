//
//  SH_PromoViewController.m
//  GameBox
//
//  Created by sam on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoViewController.h"
#import "View+MASAdditions.h"
#import "SH_PromoViewCell.h"

#import "SH_NetWorkService.h"
#import "NetWorkLineMangaer.h"
#import "PopTool.h"

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface SH_PromoViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SH_PromoViewController


- (void)getPromoList:(NSInteger )pageNumber pageSize:(NSInteger )pageSize activityClassifyKey:(NSString *)activityClassifyKey complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/discountsOrigin/getActivityTypeList.html"];
    NSDictionary *parameter =  @{@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize),@"search.activityClassifyKey":activityClassifyKey};
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentSID};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

-(void)show{
//    [[PopTool sharedInstance] showWithPresentView:self.view withLeading:80 withTop:20 subTitle:@"优惠活动" AnimatedType:AnimationTypeScale AnimationDirectionType:AnimationDirectionFromLeft];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}

-(void)createUI{
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self getPromoList:1 pageSize:50 activityClassifyKey:@"全部"  complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict====%@",dict);
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectZero];
    self.leftView.backgroundColor = [UIColor colorWithRed:0.27 green:0.32 blue:0.63 alpha:1];
    [self.view addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(160);
    }];
    
    self.rightView = [[UIView alloc]initWithFrame:CGRectZero];
    self.rightView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    [self.view addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(160);
        make.width.mas_equalTo(screenW-160);
    }];
    [self.rightView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.rightView).mas_equalTo(0);
        make.left.equalTo(self.rightView).mas_equalTo(5);
        make.width.mas_equalTo(400);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    // 设置tableView所有的cell的真实高度是自动计算的(根据设置的约束)
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    // 设置tableView的估算高度
//    self.tableView.estimatedRowHeight = 100;

    [self.tableView registerNib:[UINib nibWithNibName:@"SH_PromoViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectZero];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"login_button_click"] forState:UIControlStateNormal];
    [self.leftView addSubview:btn1];
    [btn1 setTitle:@"优惠活动" forState:UIControlStateNormal];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftView);
        make.top.equalTo(self.leftView).with.offset(20);
        make.left.mas_equalTo(5);
    }];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.leftView addSubview:btn2];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
    [btn2 setTitle:@"消息中心" forState:UIControlStateNormal];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftView);
        make.top.equalTo(self.leftView).with.offset(88);
        make.left.mas_equalTo(5);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";

    // 1.缓存中取
    SH_PromoViewCell *promoViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    // 2.创建
    if (promoViewCell == nil) {
        promoViewCell = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    return promoViewCell;
}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
