//
//  SH_PromoView.m
//  GameBox
//
//  Created by sam on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoView.h"
#import "View+MASAdditions.h"
#import "SH_PromoViewCell.h"

#import "SH_NetWorkService.h"
#import "NetWorkLineMangaer.h"

@interface SH_PromoView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SH_PromoView
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)getPromoList:(NSInteger )pageNumber pageSize:(NSInteger )pageSize complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getMyPromo.html"];
    NSDictionary *parameter =  @{@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize)};
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
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

- (void)drawRect:(CGRect)rect {
    
    [self getPromoList:1 pageSize:50 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-200, self.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor greenColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_PromoViewCell" bundle:nil] forCellReuseIdentifier:@"SH_PromoViewCell"];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, self.frame.size.height)];
    self.leftView.backgroundColor = [UIColor redColor];
    [self addSubview:self.leftView];
    
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(200, 0, self.frame.size.width-200, self.frame.size.height)];
    self.rightView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.rightView];
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



@end
