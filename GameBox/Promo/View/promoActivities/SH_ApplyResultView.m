//
//  SH_ApplyResultView.m
//  GameBox
//
//  Created by jun on 2018/8/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ApplyResultView.h"
#import "SH_ApplyFailTableViewCell.h"
#import "SH_NetWorkService+PromoActivities.h"
#import "SH_BigWindowViewController.h"
#import "SH_CustomerServiceManager.h"
@interface SH_ApplyResultView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet SH_WebPImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,copy)NSString *searchId;//传进cell，因为有的有第二次申请
@end
@implementation SH_ApplyResultView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_ApplyFailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_ApplyFailTableViewCell"];
    
}
-(void)loadDataWithPromoId:(NSString *)promoId{
    SH_BigWindowViewController *vc = ConvertToClassPointer(SH_BigWindowViewController, [self getCurrentViewController]) ;
    [SH_NetWorkService applyPromoActivitiesPromoId:promoId TransactionNo:nil  Sucess:^(SH__PromoApplyModel *model) {
        self.titleLab.text = model.actibityTitle;
        self.messageLab.text = model.applyResult;
        self.searchId = model.searchId;
        NSString *imageName;
        NSString *titleImageName;
        if ([model.status isEqualToString:@"1"]) {
            //成功
            imageName = @"success";
            titleImageName = @"title21";
        }else if ([model.status isEqualToString:@"2"]){
            //失败
            imageName = @"error";
            titleImageName = @"title22";
        }else if ([model.status isEqualToString:@"3"]){
            //部分可领取奖励
            imageName = @"warn";
            titleImageName = @"title03";
        }
        vc.titleImageName = titleImageName;
        self.iconImageView.imageName = imageName;
        self.dataArray = model.applyDetails;
        [self.tableView reloadData];
    } Failure:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

#pragma mark--
#pragma mark--tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_ApplyDetailsModel *model = self.dataArray[indexPath.row];
    if ([model.showSchedule isEqualToString:@"1"]) {
        //显示进度条
        return 50;
    }else{
        return 30;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_ApplyFailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_ApplyFailTableViewCell"];
    [cell updateUIWithModel:self.dataArray[indexPath.row] SearchId:self.searchId];
    return cell;
}
- (IBAction)contactService:(id)sender {
    //联系客服
     [[SH_CustomerServiceManager sharedManager] open];
}
@end
