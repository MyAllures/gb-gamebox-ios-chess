//
//  SH_TopCollectionViewCell.h
//  GameBox
//
//  Created by jun on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_PromoModel.h"
@interface SH_TopCollectionViewCell : UICollectionViewCell
-(void)updateUIWithPromoModel:(SH_PromoModel *)model
               SelectedStatus:(NSString *)status;
@end
