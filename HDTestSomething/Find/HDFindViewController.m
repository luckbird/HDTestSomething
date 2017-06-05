//
//  HDFindViewController.m
//  HDTestSomething
//
//  Created by yscompany on 2017/5/22.
//  Copyright © 2017年 yscompany. All rights reserved.
//
#define kMaxLength 15
#import "HDFindViewController.h"
#import "HDTestTextfieldViewController.h"
@interface HDFindViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *dutyTextField;
@end

@implementation HDFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(enterTextfiledVC)];
    
    self.dutyTextField.frame = CGRectMake(20, 120, kScreenW - 40, 40);
    [self.view addSubview:self.dutyTextField];
    
    // Do any additional setup after loading the view.
}
- (void)enterTextfiledVC {
    HDTestTextfieldViewController *vc = [HDTestTextfieldViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([self isDefaultInputNumber:string]){
        return YES;
    }else if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > kMaxLength) return NO;//限制长度
    } else {
        return NO;
    }
    return YES;
}

- (void)textFieldChanged:(UITextField *)textField {
    
    NSString *toBeString = textField.text;
    if (![self isInputRuleAndBlank:toBeString]) {
        textField.text = [self disable_emoji:toBeString];
        textField.text = [self disable_special:textField.text];
    }
    if (textField.text.length > kMaxLength) {
        textField.text = [textField.text substringToIndex:kMaxLength];
    }
}

- (BOOL)isDefaultInputNumber:(NSString *)str {
    NSArray *arr = @[@"➋",@"➌",@"➍",@"➎",@"➎",@"➏",@"➐",@"➑",@"➒"];
    for (NSString *string in arr) {
        if ([string isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}
/**
 * 字母、数字、中文正则判断（不包括空格）
 */
- (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 * 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}
- (NSString *)disable_special:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9\u4E00-\u9FA5]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
