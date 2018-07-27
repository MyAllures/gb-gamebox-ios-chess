//
//  SH_MsgCenterDetailView.h
//  GameBox
//
//  Created by shin on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SH_MsgCenterDetailViewDismiss)(void);

@interface SH_MsgCenterDetailView : UIView

@property (nonatomic, strong) NSString *content;

- (void)dismiss:(SH_MsgCenterDetailViewDismiss)dismissBlock;

@end
