//
//  SH_NavigationView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NavigationView.h"
@interface SH_NavigationView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
@implementation SH_NavigationView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.backBtn ButtonPositionStyle:ButtonPositionStyleDefault spacing:35];
}
- (IBAction)backBtnClick:(SH_WebPButton *)sender {
    [sender setScale];
    [self.delegate SH_NavigationViewBackBtnClick];
}
-(void)updateUIWithTitle:(NSString *)title{
    self.titleLab.text = title;
}
@end
