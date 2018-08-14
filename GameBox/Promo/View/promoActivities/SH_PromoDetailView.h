//
//  SH_PromoDetailView.h
//  GameBox
//
//  Created by jun on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_PromoDetailModel.h"
@interface SH_PromoDetailView : UIView
-(void)updateWithModel:(SH_PromoDetailModel *)model
                  Name:(NSString *)name
              ImageUrl:(NSString *)imageUrl
                  Date:(NSString *)date;
@end
