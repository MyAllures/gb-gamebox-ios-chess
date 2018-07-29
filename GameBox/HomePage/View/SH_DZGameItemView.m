//
//  SH_DZGameItemView.m
//  GameBox
//
//  Created by shin on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_DZGameItemView.h"
#import "SH_GameItemModel.h"
#import "UIImage+SH_WebPImage.h"

@interface SH_DZGameItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLB;

@end

@implementation SH_DZGameItemView

- (void)setGameItemModel:(SH_GameItemModel *)gameItemModel
{
    _gameItemModel = gameItemModel;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_gameItemModel.cover] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageAllowInvalidSSLCertificates];
    self.gameNameLB.text = _gameItemModel.name;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ifRespondsSelector(self.delegate, @selector(dzGameItemView:didSelect:))
    {
        [self.delegate dzGameItemView:self didSelect:self.gameItemModel];
    }
}

@end
