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

@end
@implementation SH_NavigationView
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)backBtnClick:(id)sender {
    [self.delegate SH_NavigationViewBackBtnClick];
}
-(void)updateUIWithTitle:(NSString *)title{
    self.titleLab.text = title;
}
@end
