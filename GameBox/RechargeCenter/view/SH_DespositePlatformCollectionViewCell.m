//
//  SH_DespositePlatformCollectionViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_DespositePlatformCollectionViewCell.h"
#import "SH_RechargeCenterPlatformModel.h"
@interface SH_DespositePlatformCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation SH_DespositePlatformCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateUIWithContex:(id)contex Selected:(NSString *)selected{
    SH_RechargeCenterPlatformModel *platformModel = (SH_RechargeCenterPlatformModel *)contex;
    [self.iconImage setImageWithType:1 ImageName:platformModel.iconUrl Placeholder:nil];
    self.titleLab.text = platformModel.name;
     [self setCellBoardWithSelected:selected];
}
@end
