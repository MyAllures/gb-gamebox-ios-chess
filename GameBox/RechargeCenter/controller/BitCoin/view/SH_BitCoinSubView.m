//
//  SH_BitCoinSubView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinSubView.h"
@interface SH_BitCoinSubView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *personLab;

@end
@implementation SH_BitCoinSubView

- (void)awakeFromNib{
    [super awakeFromNib];
}
-(void)updateUIWithChannelModel:(SH_RechargeCenterChannelModel *)model{
    [self.iconImageView setImageWithType:1 ImageName:model.imgUrl];
    self.personLab.text = [NSString stringWithFormat:@"氏名  %@",model.fullName];
}
@end
