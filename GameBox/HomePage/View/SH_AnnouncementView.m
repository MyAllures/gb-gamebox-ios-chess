//
//  SH_AnnouncementView.h
//  GameBox
//
//  Created by shin on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_AnnouncementView.h"

@interface SH_AnnouncementView ()
{
    NSTimeInterval _dynamicTimeInterval ;
}

@property (nonatomic, strong) UIView *scrollView ;
@property (nonatomic, strong) UILabel *labScrollText;
@property (nonatomic, assign) CGSize textSize;
@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation SH_AnnouncementView

- (void)setString:(NSString *)string
{
    _string = string;
    _dynamicTimeInterval = 10.0f  ;// default ;
    [self.scrollView addSubview:self.labScrollText];
    [self addSubview:self.scrollView];
    
    NSString *strTmp = _string;
    strTmp = [strTmp stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
    strTmp = [strTmp stringByReplacingOccurrencesOfString:@"\r" withString:@""] ;
    if ([self.labScrollText.text isEqualToString:strTmp])
        return ;
    if (strTmp.length<10) {
        _dynamicTimeInterval = [strTmp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] * .38;
    }else if (strTmp.length>10 && strTmp.length < 100)
    {
        _dynamicTimeInterval = [strTmp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] * .105  ;
    }else if (strTmp.length>100&&strTmp.length<500)
    {
        _dynamicTimeInterval = [strTmp lengthOfBytesUsingEncoding:NSUTF8StringEncoding] * .085  ;
    }
    else if (strTmp.length>500){
        _dynamicTimeInterval = [strTmp lengthOfBytesUsingEncoding:NSUTF8StringEncoding]*.065;
    }
    self.labScrollText.text = strTmp;

    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f],};
    self.textSize = [self.labScrollText.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 14) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    self.labScrollText.frame = CGRectMake(self.scrollView.frameWidth,
                                          floorf((self.scrollView.frameHeigh-self.textSize.height)/2.0),
                                          self.textSize.width,
                                          self.textSize.height) ;

}

-(void)start{
    if (self.isAnimation)
        return ;
    [UIView animateWithDuration:_dynamicTimeInterval//动画持续时间
                          delay:0//动画延迟执行的时间
                        options:(UIViewAnimationOptionCurveLinear)//动画的过渡效果
                     animations:^{
                         self.isAnimation = YES ;
                         self.labScrollText.frame = CGRectMake(-self.textSize.width,
                                                               floorf((self.scrollView.frameHeigh-self.textSize.height)/2.0),
                                                               self.textSize.width,
                                                               self.textSize.height) ;
                     }completion:^(BOOL finished){
                         self.labScrollText.frame = CGRectMake(self.scrollView.frameWidth,
                                                               floorf((self.scrollView.frameHeigh-self.textSize.height)/2.0),
                                                               self.textSize.width,
                                                               self.textSize.height) ;
                         self.isAnimation = NO;
                         [self start];//动画执行完毕后的操作
                     }];
}

-(UILabel *)labScrollText
{
    if (!_labScrollText){
        _labScrollText = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        _labScrollText.textColor = [UIColor whiteColor];
        _labScrollText.font = [UIFont systemFontOfSize:12.0f] ;
    }
    
    return  _labScrollText ;
}

-(UIView *)scrollView
{
    if (!_scrollView){
        _scrollView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor] ;
        _scrollView.layer.masksToBounds = YES ;
    }
    
    return  _scrollView ;
}
@end
