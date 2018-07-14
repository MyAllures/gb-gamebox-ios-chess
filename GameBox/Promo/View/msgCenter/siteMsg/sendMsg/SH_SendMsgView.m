//
//  SH_SendMsgView.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SendMsgView.h"
#import "SH_SendMsgTabelViewCell.h"
#import "SH_NetWorkService+Promo.h"
#import "SH_AdvisoryTypeModel.h"

@interface SH_SendMsgView () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIPickerView *pickView;
@property (strong, nonatomic) NSMutableArray *arr;
@end

@implementation SH_SendMsgView
@synthesize pickView = _pickView;

-(UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self configUI];
}

-(void)configUI {
    
    self.arr = [NSMutableArray array];
    
    [SH_NetWorkService_Promo startAddApplyDiscountsVerify:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dic = (NSDictionary *)response;
        NSLog(@"dic===%@",dic);
        for (NSDictionary *dict in dic[@"data"][@"advisoryTypeList"]) {
            NSError *err;
            SH_AdvisoryTypeModel *model = [[SH_AdvisoryTypeModel alloc] initWithDictionary:dict error:&err];
            [self.arr addObject:model];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPickView) name:@"pickView" object:nil];
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_SendMsgTabelViewCell" bundle:nil] forCellReuseIdentifier:@"SH_SendMsgTabelViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)addPickView {
    self.pickView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.pickView];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.frame.size.height-150);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SH_SendMsgTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_SendMsgTabelViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_SendMsgTabelViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}


// returns the # of rows in each component..
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.arr.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    SH_AdvisoryTypeModel *model = self.arr[row];
    return model.advisoryName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
   SH_AdvisoryTypeModel *model = self.arr[row];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:model.advisoryName,@"key",model.advisoryType,@"advisoryType", nil];
    NSNotification *not = [NSNotification notificationWithName:@"sendMsg" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:not];
    [_pickView removeFromSuperview];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pickView" object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementationSH_SendMsgView adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
