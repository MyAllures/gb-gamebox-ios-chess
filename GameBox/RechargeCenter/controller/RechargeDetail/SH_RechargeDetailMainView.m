//
//  SH_RechargeDetailMainView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeDetailMainView.h"
#import "SH_RechargeDetailHeadView.h"
#import "SH_RechargeDetailMainSubmitView.h"
@interface SH_RechargeDetailMainView()
@property(nonatomic,strong)SH_RechargeDetailHeadView *headView;
@property(nonatomic,strong)SH_RechargeDetailMainSubmitView *submitView;
@property(nonatomic,strong)UILabel *messageLab;
@property(nonatomic,strong)UILabel *bottomLab;
@end
@implementation SH_RechargeDetailMainView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
#pragma mark--
#pragma mark--lazy
- (SH_RechargeDetailHeadView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"SH_RechargeDetailHeadView" owner:self options:nil].firstObject;
        [self addSubview:_headView];
    }
    return _headView;
}
- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab = [[UILabel alloc]init];
        _messageLab.numberOfLines = 0;
        _messageLab.font = [UIFont systemFontOfSize:12];
        _messageLab.textColor = colorWithRGB(85, 85, 85);
        [self addSubview:_messageLab];
    }
    return _messageLab;
}
-(UILabel *)bottomLab{
    if (!_bottomLab) {
        _bottomLab = [[UILabel alloc]init];
        _bottomLab.numberOfLines = 0;
        _bottomLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_bottomLab];
    }
    return _bottomLab;
}
- (SH_RechargeDetailMainSubmitView *)submitView{
    if (!_submitView) {
        _submitView = [[NSBundle mainBundle]loadNibNamed:@"SH_RechargeDetailMainSubmitView" owner:self options:nil].firstObject;
        [self addSubview:_submitView];
    }
    return _submitView;
}
-(void)configUI{
    self.messageLab.text = @"当男神给自己涂口红，王源自恋，权志龙害羞，李晨让人笑出腹肌 大家好，我是“不羡鸳鸯共枕床”的小编，今天为大家带来不一样的精彩内容，希望各位看官给小编动手评论点赞喔！您的每一次评论点赞都会带来好运气喔！当男神给自己涂口红会是什么样子呢？现在我们一起来看看吧除了长相温润，天然亲和，还有着年轻人需要的踏实努力、不骄不躁、低调谦逊。鹿晗小脸圆眼，外表俊美，这是很多粉丝第一眼沦陷的关键。虽荣升超人气偶像，却依旧和当初没什么两样，“你们看到的就是真实的他”。讲礼貌，瞥见小编，他都会微微鞠躬示意。会帮忙收拾东西，几次都鞠躬说辛苦了谢谢，会帮忙当翻译，十分邻家。他是北京人，个性也相当的北京大男孩儿，很会照顾人。";
    self.bottomLab.text = @"当男神给自己涂口红，王源自恋，权志龙害羞，李晨让人笑出腹肌 大家好，我是“不羡鸳鸯共枕床”的小编，今天为大家带来不一样的精彩内容，希望各位看官给小编动手评论点赞喔！您的每一次评论点赞都会带来好运气喔！当男神给自己涂口红会是什么样子呢？现在我们一起来看看吧除了长相温润，天然亲和，还有着年轻人需要的踏实努力、不骄不躁、低调谦逊。鹿晗小脸圆眼，外表俊美，这是很多粉丝第一眼沦陷的关键。虽荣升超人气偶像，却依旧和当初没什么两样，“你们看到的就是真实的他”。讲礼貌，瞥见小编，他都会微微鞠躬示意。会帮忙收拾东西，几次都鞠躬说辛苦了谢谢，会帮忙当翻译，十分邻家。他是北京人，个性也相当的北京大男孩儿，很会照顾人。";
      __weak typeof(self) weakSelf = self;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@350);
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom).offset(5);
        make.left.equalTo(weakSelf).offset(15);
        make.right.equalTo(weakSelf).offset(-15);
    }];
    
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.messageLab.mas_bottom).offset(25);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@160);
    }];
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.submitView.mas_bottom).offset(40);
        make.left.equalTo(weakSelf).offset(20);
        make.right.bottom.equalTo(weakSelf).offset(-20);
    }];
    
    [self.headView updateWithInteger:arc4random()%10];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
