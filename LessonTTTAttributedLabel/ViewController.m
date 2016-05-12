//
//  ViewController.m
//  LessonTTTAttributedLabel
//
//  Created by rocky on 16/5/12.
//  Copyright © 2016年 RockyFung. All rights reserved.
//

#import "ViewController.h"
#import "TTTAttributedLabel.h"

@interface ViewController ()<TTTAttributedLabelDelegate, UIActionSheetDelegate>

@end

@implementation ViewController


static inline NSRegularExpression * NameRegularExpression() {
    
    static NSRegularExpression *_nameRegularExpression = nil;
    
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
        
    });
    
    return _nameRegularExpression;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(100, 120, 120, 60)];
    label.backgroundColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    
    //设置高亮颜色
    label.highlightedTextColor = [UIColor greenColor];
    //检测url
    label.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    //对齐方式
    label.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
    //行间距
    label.lineSpacing = 8;
    //设置阴影
    label.shadowColor = [UIColor grayColor];
    label.delegate = self; // Delegate
    
    //NO 不显示下划线
    
    label.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    
    NSString *text = @"冷清风 赞了 王战 的说的说的说的说的说的说的说的说的说的说";
    
    [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString)
     
     {
         
         //设置可点击文字的范围
         
         NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"冷清风" options:NSCaseInsensitiveSearch];
         
         
         
         //设定可点击文字的的大小
         
         UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:16];
         
         CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
         
         if (font) {
             
             //设置可点击文本的大小
             
             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
             
             
             
             //设置可点击文本的颜色
             
             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor blueColor] CGColor] range:boldRange];
             
             
             CFRelease(font);
             
         }
         
         return mutableAttributedString;
         
     }];
    
    //正则
    
    NSRegularExpression *regexp = NameRegularExpression();
    
    
    NSRange linkRange = [regexp rangeOfFirstMatchInString:text options:0 range:NSMakeRange(0, 3)];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.exiucai.com/"]];
    
    
    //设置链接的url
    
    [label addLinkToURL:url withRange:linkRange];
    
    [self.view addSubview:label];
    
}


- (void)attributedLabel:(__unused TTTAttributedLabel *)label

   didSelectLinkWithURL:(NSURL *)url

{
    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet

clickedButtonAtIndex:(NSInteger)buttonIndex

{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        
        return;
        
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
    
}













- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
