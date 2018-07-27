//
//  SH_HandRecordHeaderView.m
//  GameBox
//
//  Created by sam on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_HandRecordHeaderView.h"
#import "HLPopTableView.h"
@interface SH_HandRecordHeaderView()
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@end

@implementation SH_HandRecordHeaderView

- (IBAction)seleteTimeAction:(UIButton *)sender {
    NSArray *searchTypeArr = @[@"今天",@"昨天",@"本周",@"近七天"];
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width, 125) dependView:sender textArr:searchTypeArr textFont:14.0 block:^(NSString *region_name, NSInteger index) {
        [self.timeBtn setTitle:region_name forState:UIControlStateNormal];
        if (self.seleteTimeActionBlock) { self.seleteTimeActionBlock(@{@"index":[NSString stringWithFormat:@"%ld",(long)index]});
        }
    }];
    [self addSubview:popTV];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
