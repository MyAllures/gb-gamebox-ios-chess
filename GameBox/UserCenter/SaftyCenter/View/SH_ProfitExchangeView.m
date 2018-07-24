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
@interface SH_ProfitExchangeView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,strong)NSArray *dataArray;

@end
@implementation SH_ProfitExchangeView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SH_ProfitExchangeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_ProfitExchangeTableViewCell"];
}

#pragma mark--
#pragma mark--UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_ProfitExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_ProfitExchangeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updateUIWithApiModel:self.dataArray[indexPath.row]];
    return cell;
}
- (IBAction)oneKeyRefresh:(id)sender {
}
- (IBAction)oneKeyRecovery:(id)sender {
}
//选中了额度转换的View
-(void)selectProfitExchangeView{
    [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        
        NSDictionary  * result = ConvertToClassPointer(NSDictionary, response);
          NSString *code = [NSString stringWithFormat:@"%@",result[@"code"]];
        if ([code isEqualToString:@"0"]) {
            self.dataArray = [SH_ApiModel arrayOfModelsFromDictionaries:result[@"data"][@"user"][@"apis"] error:nil];
        }
        [self.mainTableView reloadData];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

@end
