//
//  SH_NodataView.m
//  GameBox
//
//  Created by jun on 2018/8/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NodataView.h"

@interface SH_NodataView()
@property (weak, nonatomic) IBOutlet UILabel *massageLab;
@end
@implementation SH_NodataView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}
+(instancetype)showAddTo:(UIView *)view
                 Message:(NSString *)message{
    UIView *view1 = [view viewWithTag:123456];
    if (view1) {
        [view1 removeFromSuperview];
    }
    SH_NodataView *noDataView = [[NSBundle mainBundle]loadNibNamed:@"SH_NodataView" owner:self options:nil].firstObject ;
    noDataView.frame = view.bounds;
    noDataView.tag = 123456;
    [view addSubview:noDataView];
    noDataView.massageLab.text = message;
    return noDataView;
}
@end
