//
//  SH_DespositeChooseMoneyCollectionViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_DespositeChooseMoneyCollectionViewCell.h"
@interface SH_DespositeChooseMoneyCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end
@implementation SH_DespositeChooseMoneyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateUIWithContex:(id)contex Selected:(NSString *)selected{
    NSString *num = [NSString stringWithFormat:@"%@",contex];
    [self.iconImage setImageWithType:0 ImageName:[NSString stringWithFormat:@"chip-%@",num]];
     [self setCellBoardWithSelected:selected];
    self.numLab.text = num;
    
}
@end
