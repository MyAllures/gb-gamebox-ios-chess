//
//  SH_TopCollectionViewCell.m
//  GameBox
//
//  Created by jun on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_TopCollectionViewCell.h"

@interface SH_TopCollectionViewCell()
@property (weak, nonatomic) IBOutlet SH_WebPImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation SH_TopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateUIWithPromoModel:(SH_PromoModel *)model
               SelectedStatus:(NSString *)status{
    self.titleLab.text = model.activityTypeName;
    if ([status isEqualToString:@"0"]) {
        self.bgImageView.imageName = @"btn_blue";
    }else{
         self.bgImageView.imageName = @"btn_green_action";
    }
}
@end
