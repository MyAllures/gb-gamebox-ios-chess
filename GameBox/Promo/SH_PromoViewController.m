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
    [[PopTool sharedInstance] showWithPresentView:self.view withLeading:80 withTop:20 subTitle:@"优惠活动" AnimatedType:AnimationTypeScale AnimationDirectionType:AnimationDirectionFromLeft];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}

-(void)createUI{
    [self getPromoList:1 pageSize:50 activityClassifyKey:@"全部"  complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict====%@",dict);
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-200, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor greenColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_PromoViewCell" bundle:nil] forCellReuseIdentifier:@"SH_PromoViewCell"];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectZero];
    self.leftView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.leftView];
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(160);
    }];
    
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(200, 0, self.view.frame.size.width-200, self.view.frame.size.height)];
    self.rightView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.rightView];
    [self.rightView addSubview:self.tableView];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.leftView addSubview:btn1];
    [btn1 setTitle:@"优惠活动" forState:UIControlStateNormal];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftView);
        make.top.equalTo(self.leftView).with.offset(40);
        make.width.equalTo(@185);
        make.height.equalTo(@58);
    }];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.leftView addSubview:btn2];
    [btn2 setTitle:@"消息中心" forState:UIControlStateNormal];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftView);
        make.top.equalTo(self.leftView).with.offset(108);
        make.width.equalTo(@185);
        make.height.equalTo(@58);
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
    SH_PromoViewCell *promoViewCell = [tableView dequeueReusableCellWithIdentifier:@"SH_PromoViewCell" forIndexPath:indexPath];
    if (promoViewCell == nil) {
        promoViewCell = [[SH_PromoViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SH_PromoViewCell"];
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
