//
//  SH_LeftTableViewCell.m
//  GameBox
//
//  Created by jun on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_LeftTableViewCell.h"

@interface SH_LeftTableViewCell()
@property (weak, nonatomic) IBOutlet SH_WebPImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation SH_LeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.font = [UIFont systemFontOfSize:14*screenSize().width/375];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateUIWithPromoSubModel:(SH_PromoSubModel *)model
                  SelectedStatus:(NSString *)status{
    self.titleLab.text = model.name;
    if ([status isEqualToString:@"0"]) {
        self.bgImageView.imageName = @"button-long";
    }else{
        self.bgImageView.imageName = @"button-long-click";
    }
}
@end
