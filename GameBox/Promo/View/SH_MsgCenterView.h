//
//  SH_MsgCenterView.h
//  GameBox
//
//  Created by shin on 2018/7/25.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SH_MsgCenterViewShowDetail)(NSString *content);

@interface SH_MsgCenterView : UIView

- (void)reloadData;
- (void)showDetail:(SH_MsgCenterViewShowDetail)showDetailBlock;
-(void)fetchHttpData;
@end
