//
//  SH_RechargeCenterBasicCollectionViewCell.h
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_RechargeCenterBasicCollectionViewCell : UICollectionViewCell
-(void)updateUIWithContex:(id)contex Selected:(NSString *)selected;
-(void)setCellBoardWithSelected:(NSString *)selected;
@end
