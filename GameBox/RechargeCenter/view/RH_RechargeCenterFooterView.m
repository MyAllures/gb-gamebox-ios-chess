//
//  RH_RechargeCenterFooterView.m
//  testDemo
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 jun. All rights reserved.
//

#import "RH_RechargeCenterFooterView.h"
@interface RH_RechargeCenterFooterView()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;

@end
@implementation RH_RechargeCenterFooterView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSureBtnInTextfield];
    
}
-(void)addSureBtnInTextfield{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    toolBar.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [toolBar setItems:@[btnSpace,btnItem]];
    self.textField.inputAccessoryView = toolBar;
    
}
-(void)btnClick{
    [self.textField endEditing:YES];
}
@end
