//
//  SH_ProfitExchangeView.m
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ProfitExchangeView.h"
#import "SH_ProfitExchangeTableViewCell.h"
#import "SH_NetWorkService+RegistAPI.h"
#import "SH_ApiModel.h"
#import "SH_NetWorkService+SaftyCenter.h"
@interface SH_ProfitExchangeView()<UITableViewDelegate,UITableViewDataSource,SH_ProfitExchangeTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,strong)NSArray *dataArray;

@property (weak, nonatomic) IBOutlet SH_WebPButton *refreshBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *recoveryBtn;
@end
@implementation SH_ProfitExchangeView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.refreshBtn ButtonPositionStyle:ButtonPositionStyleRight spacing:5];
    [self.recoveryBtn ButtonPositionStyle:ButtonPositionStyleRight spacing:5];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SH_ProfitExchangeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_ProfitExchangeTableViewCell"];
}

#pragma mark--
#pragma mark--UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_ProfitExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_ProfitExchangeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate  =self;
    [cell updateUIWithApiModel:self.dataArray[indexPath.row]];
    return cell;
}
- (IBAction)oneKeyRefresh:(id)sender {
    [SH_NetWorkService oneKeyRefreshSuccess:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary  * result = ConvertToClassPointer(NSDictionary, response);
        NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSError *err;
            self.dataArray = [SH_ApiModel arrayOfModelsFromDictionaries:result[@"data"][@"apis"] error:&err];
            
        }
        [self.mainTableView reloadData];
        
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
- (IBAction)oneKeyRecovery:(id)sender {
    [self recoveryActionWithId:nil];//一键刷新
}
//选中了额度转换的View
-(void)selectProfitExchangeView{
    [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        
        NSDictionary  * result = ConvertToClassPointer(NSDictionary, response);
          NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
        if ([code isEqualToString:@"0"]) {
            NSError *err;
            NSArray *arr = [SH_BankListModel arrayOfModelsFromDictionaries:response[@"data"][@"bankList"] error:&err];
            [[RH_UserInfoManager shareUserManager] setBankList:arr];
            NSError *err2;
            RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[response[@"data"] objectForKey:@"user"] error:&err2];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];

            NSError *err3;
            self.dataArray = [SH_ApiModel arrayOfModelsFromDictionaries:result[@"data"][@"user"][@"apis"] error:&err3];
            
        }
        [self.mainTableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

#pragma mark--
#pragma mark--一键回收接口
-(void)recoveryActionWithId:(NSString *)apiId{
    [SH_NetWorkService oneKeyRecoverySearchId:apiId Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary  * result = ConvertToClassPointer(NSDictionary, response);
        NSString *message = result[@"message"];
        showMessage(self, message ,nil );
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

#pragma mark--
#pragma mark--cell delegate
- (void)recoveryBtnWithApiId:(NSString *)apiId{
    [self recoveryActionWithId:apiId];
}
@end
