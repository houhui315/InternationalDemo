//
//  ViewController.m
//  InternationalDemo
//
//  Created by 蓝泰致铭        on 2017/3/31.
//  Copyright © 2017年 知学云. All rights reserved.
//

#import "ViewController.h"
#import "ZXYLanguageManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.label1.text = ZXYLocalizedString(@"你好，世界！");
    
    self.label2.text = ZXYLocalizedDicString(@"%A秒后重新获取", @{@"%A":@"10"});
    
    NSDictionary *baseAttribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor grayColor]};
    
    NSDictionary *numAttribute = @{NSForegroundColorAttributeName:[UIColor redColor]};
    NSMutableAttributedString *attributeString = [kLanguageManager localizedStringForKey:@"%A秒后重新获取" table:LocalizableName_Normal valueDic:@{@"%A":@"10"} attributeDic:@{@"%A":numAttribute} baseAttribute:baseAttribute];
    self.label3.attributedText = attributeString;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
