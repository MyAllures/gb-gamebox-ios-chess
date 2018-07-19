//
//  SH_HorizontalscreenPicker.m
//  GameBox
//
//  Created by jun on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_HorizontalscreenPicker.h"
@interface SH_HorizontalscreenPicker()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (assign, nonatomic) NSInteger selectedValue;
@property (strong, nonatomic) NSArray *datas;
@end
@implementation SH_HorizontalscreenPicker

- (void)awakeFromNib{
    [super awakeFromNib];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
     [self.pickerView selectRow:0 inComponent:0 animated:YES];
    self.selectedValue = 0;
}
-(void)updateWithDatas:(NSArray *)datas{
    self.datas = datas;
    [self showView];
}
- (IBAction)sureBtnClick:(id)sender {
    self.confirmBlock(self.selectedValue);
    
    [self dismissView];
}
- (IBAction)cancleBtnClick:(id)sender {
     [self dismissView];
}

- (void)showView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}


#pragma mark - pickerView 代理方法

// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// 行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.datas.count;
}

-(CGFloat)pickerView:(UIPickerView*)pickerView rowHeightForComponent:(NSInteger)component {
    return 35;
}

// 显示什么
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return self.datas[row];
}

// 选中时
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.selectedValue = row;
}
@end
