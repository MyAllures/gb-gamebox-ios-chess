//
//  SH_DespositeChooseMoneyCollectionViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_DespositeChooseMoneyCollectionViewCell.h"
@interface SH_DespositeChooseMoneyCollectionViewCell()
@property (weak, nonatomic) IBOutlet SH_WebPImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end
@implementation SH_DespositeChooseMoneyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateUIWithContex:(id)contex Selected:(NSString *)selected{
    NSDictionary *dic = (NSDictionary *)contex;
    NSString *num = [NSString stringWithFormat:@"%@",dic[@"num"]];
    NSString *imageName = dic[@"imageName"];
    self.iconImage.imageName = imageName;
     [self setCellBoardWithSelected:selected];
    self.numLab.text = num;
    
}
@end
