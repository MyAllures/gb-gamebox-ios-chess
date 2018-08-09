//
//  SH_LeftTableViewCell.h
//  GameBox
//
//  Created by jun on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_PromoSubModel.h"
@interface SH_LeftTableViewCell : UITableViewCell
-(void)updateUIWithPromoSubModel:(SH_PromoSubModel *)model
                  SelectedStatus:(NSString *)status;
@end
