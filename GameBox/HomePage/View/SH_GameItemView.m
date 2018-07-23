//
//  SH_GameItemView.m
//  GameBox
//
//  Created by shin on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GameItemView.h"
#import "SH_GameItemModel.h"
#import "UIImage+SH_WebPImage.h"

@interface SH_GameItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@end

@implementation SH_GameItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setGameItemModel:(SH_GameItemModel *)gameItemModel
{
    _gameItemModel = gameItemModel;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_gameItemModel.cover] placeholderImage:[UIImage imageWithWebPImageName:@"game_chess_34_870"] options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ifRespondsSelector(self.delegate, @selector(gameItemView:didSelect:))
    {
        [self.delegate gameItemView:self didSelect:self.gameItemModel];
    }
}

@end
