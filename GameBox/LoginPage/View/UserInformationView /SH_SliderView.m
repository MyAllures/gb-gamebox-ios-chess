//
//  SH_SliderView.m
//  GameBox
//
//  Created by shin on 2018/7/30.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SliderView.h"
#import "UIImage+SH_WebPImage.h"

@interface SH_SliderView ()
@property (strong, nonatomic) UIImageView *progressBGImg;
@property (strong, nonatomic) SH_WebPImageView *thumbImg;
@property (strong, nonatomic) UIImageView *progressImg;
@property (copy, nonatomic) SH_SliderViewProgressChanging progressChanging;

@end

@implementation SH_SliderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.progressBGImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_empty_music"]];
        [self addSubview:self.progressBGImg];
        [self.progressBGImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(16);
            make.centerY.equalTo(self);
        }];
        
        self.thumbImg = [[SH_WebPImageView alloc] init];
        self.thumbImg.image = [UIImage imageWithWebPImageName:@"circular"];
        [self addSubview:self.thumbImg];
        [self.thumbImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(30);
            make.centerY.equalTo(self.mas_centerY);
            make.left.mas_equalTo(0);
        }];
        self.thumbImg.userInteractionEnabled = YES;
        [self.thumbImg addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];

        self.progressImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_music"]];
        [self addSubview:self.progressImg];
        [self.progressImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(16);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        [self bringSubviewToFront:self.thumbImg];
        
        [self layoutIfNeeded];
    }
    return self;
}

- (void)progressChanging:(SH_SliderViewProgressChanging)changingBlcok
{
    self.progressChanging = changingBlcok;
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    //获取偏移量
    CGFloat moveX = [sender translationInView:self].x;
    
    //重置偏移量，避免下次获取到的是原基础的增量
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    
    //计算当前中心值
    CGFloat centerX = self.thumbImg.center.x + moveX;
    
    //防止瞬间大偏移量滑动影响显示效果
    if (centerX < 0) centerX = 0;
    if (centerX > self.bounds.size.width) centerX = self.bounds.size.width;
    
    //刷新视图
    [self reloadViewWithThumbCeneterX:centerX];
}

- (void)reloadViewWithThumbCeneterX:(CGFloat)thumbCeneterX
{
    //更新滑块位置
    self.thumbImg.center = CGPointMake(thumbCeneterX, self.thumbImg.center.y);
    if (self.thumbImg.center.x < 0) {
        self.thumbImg.center = CGPointMake(0, self.thumbImg.center.y);
    }else if (self.thumbImg.center.x > self.bounds.size.width) {
        self.thumbImg.center = CGPointMake(self.bounds.size.width, self.thumbImg.center.y);
    }
    
    self.progressImg.frame = CGRectMake(self.progressImg.frame.origin.x, self.progressImg.frame.origin.y, thumbCeneterX, self.progressImg.frame.size.height);

    //分数，四舍五入取整
    _progress = (self.progressImg.frame.size.width)/(self.progressBGImg.frame.size.width);
    if (self.progressChanging) {
        self.progressChanging(_progress);
    }
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self.progressImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.equalTo(self.progressBGImg.mas_width).multipliedBy(progress);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.thumbImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.progressImg.mas_right).mas_offset(15);
    }];
}

@end
