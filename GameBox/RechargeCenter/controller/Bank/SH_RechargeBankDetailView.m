//
//  SH_RechargeBankDetailVIew.m
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeBankDetailView.h"
#import "SH_RechargeDetailBankView.h"

@interface SH_RechargeBankDetailView()
@property(nonatomic,strong)SH_RechargeDetailBankView *headView;
@property(nonatomic,strong)UILabel *bottomLab;
@end
@implementation SH_RechargeBankDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
#pragma mark--
#pragma mark--lazy
- (SH_RechargeDetailBankView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"SH_RechargeDetailBankView" owner:self options:nil].firstObject;
        [self addSubview:_headView];
    }
    return _headView;
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
-(void)configUI{
     self.bottomLab.text = @"当男神给自己涂口红，王源自恋，权志龙害羞，李晨让人笑出腹肌 大家好，我是“不羡鸳鸯共枕床”的小编，今天为大家带来不一样的精彩内容，希望各位看官给小编动手评论点赞喔！您的每一次评论点赞都会带来好运气喔！当男神给自己涂口红会是什么样子呢？现在我们一起来看看吧除了长相温润，天然亲和，还有着年轻人需要的踏实努力、不骄不躁、低调谦逊。鹿晗小脸圆眼，外表俊美，这是很多粉丝第一眼沦陷的关键。虽荣升超人气偶像，却依旧和当初没什么两样，“你们看到的就是真实的他”。讲礼貌，瞥见小编，他都会微微鞠躬示意。会帮忙收拾东西，几次都鞠躬说辛苦了谢谢，会帮忙当翻译，十分邻家。他是北京人，个性也相当的北京大男孩儿，很会照顾人。";
      __weak typeof(self) weakSelf = self;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@470);
    }];
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom).offset(40);
        make.left.equalTo(weakSelf).offset(20);
        make.right.bottom.equalTo(weakSelf).offset(-20);
    }];
}
@end
