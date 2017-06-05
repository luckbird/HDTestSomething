//
//  HDTestTextfieldViewController.m
//  HDTestSomething
//
//  Created by yscompany on 2017/6/5.
//  Copyright © 2017年 yscompany. All rights reserved.
//
#define kMaxLength   15
#import "HDTestTextfieldViewController.h"
#import "HDJudgeInputTextStyle.h"

@interface HDTestTextfieldViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *dutyTextField;
@end

@implementation HDTestTextfieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"测试字符检测";
    
    self.dutyTextField.frame = CGRectMake(20, 120, kScreenW - 40, 40);
    [self.view addSubview:self.dutyTextField];
    // Do any additional setup after loading the view.
}
#pragma mark - textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([HDJudgeInputTextStyle isDefaultInputNumber:string]){
        return YES;
    }else if ([HDJudgeInputTextStyle isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > kMaxLength) return NO;//限制长度
    } else {
        return NO;
    }
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField {
    
    NSString *toBeString = textField.text;
    if (![HDJudgeInputTextStyle isInputRuleAndBlank:toBeString]) {
        textField.text = [HDJudgeInputTextStyle disable_emoji:toBeString];
        textField.text = [HDJudgeInputTextStyle disable_special:textField.text];
    }
    if (textField.text.length > kMaxLength) {
        textField.text = [textField.text substringToIndex:kMaxLength];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - getter method
- (UITextField *)dutyTextField {
    if (!_dutyTextField) {
        _dutyTextField = [[UITextField alloc] init];
        _dutyTextField.font = [UIFont systemFontOfSize:15.0f];
        _dutyTextField.textColor = [UIColor blackColor];
        _dutyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"请输入责任经理(选填)" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f  blue:190.0f/255.0f alpha:1.0f],NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}];
        _dutyTextField.attributedPlaceholder = attribute;
        _dutyTextField.borderStyle = UITextBorderStyleNone;
        _dutyTextField.delegate = self;
        [_dutyTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _dutyTextField;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
