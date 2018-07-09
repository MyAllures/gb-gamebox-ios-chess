//
//  SH_DepositeWayCollectionViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_DepositeWayCollectionViewCell.h"
#import "SH_RechargeCenterChannelModel.h"
@interface SH_DepositeWayCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation SH_DepositeWayCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateUIWithContex:(id)contex Selected:(NSString *)selected{
    SH_RechargeCenterChannelModel *platformModel = (SH_RechargeCenterChannelModel *)contex;
    [self.iconImageView setImageWithType:1 ImageName:platformModel.imgUrl];
    if ([platformModel.aliasName isEqualToString:@""] ||platformModel.aliasName == nil ) {
        self.titleLab.text = platformModel.payName;
    }
    else{
        self.titleLab.text = platformModel.aliasName;
    }
    NSLog(@"status ==%@" ,selected);
    [self setCellBoardWithSelected:selected];
}
@end
