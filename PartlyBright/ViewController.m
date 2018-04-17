//
//  ViewController.m
//  PartlyBright
//
//  Created by 孟庆洪 on 2018/4/12.
//  Copyright © 2018年 mqhong. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+HightLightText.h"
@interface ViewController ()
@property (nonatomic,strong) UILabel   *lbl;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.lbl = [UILabel new];
    self.lbl.frame = CGRectMake(100, 100, 200, 40);
    self.lbl.tag = 10000;
    [self.view addSubview:self.lbl];
    self.lbl.text = @"今天是个好日子，是个好日子呀";
    self.lbl.mm_HeightLightText = @"是";
    self.lbl.textColor = [UIColor greenColor];
    self.lbl.mm_HeightLightColor = [UIColor redColor];
    NSLog(@"加载完毕");
//    self.lbl.attributedText = [self SetTextPartOfHightLight:@"今天是个好日子" textColor:[UIColor orangeColor] hightText:@"是个" hightTextColor:[UIColor redColor]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"重新赋值");
    [super touchesBegan:touches withEvent:event];
    self.lbl.text = @"ddd";
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}



-(NSMutableAttributedString *)SetTextPartOfHightLight:(NSString *)text textColor:(UIColor *)textColor hightText:(NSString *)hightStr hightTextColor:(UIColor *)hightColor{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSUInteger len = [hightStr length];
    for(NSUInteger i=0; i<len; i++)
    {//把hightStr变成以每个字符串为一个单位的数组
        int asciiCode = [hightStr characterAtIndex:i];
        NSString *string = [NSString stringWithFormat:@"%C", (unichar)asciiCode]; // A
        
        [array addObject:string];
    }
    NSSet *set = [NSSet setWithArray:array];//用集合来把重复的删除掉
    
    NSMutableArray *data_arr = [[NSMutableArray alloc] init];
    NSMutableArray *arr;
    
    
    for (NSString *str in set) {
        arr = [self rangeOfString:str inString:text atOccurrence:text.length Location:data_arr];
    }
    
    return [self getAttrIbutedStrdistance:text textColor:textColor DataKeyWorld:arr hightTextColor:hightColor];
    
}

//获得可变字符串
- (NSMutableAttributedString *)getAttrIbutedStrdistance:(NSString *)text1 textColor:(UIColor *)textColor  DataKeyWorld:(NSMutableArray *)KeyWorld hightTextColor:(UIColor *)hightColor{
    NSInteger len1 = [text1 length];
    NSString *all_str = [NSString stringWithFormat:@"%@",text1];
    NSMutableAttributedString * attributed_str = [[NSMutableAttributedString alloc]initWithString:all_str];
    [attributed_str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:16] range:NSMakeRange(0, len1)];
    
    [attributed_str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, len1)];
    for (int i = 0; i < KeyWorld.count; i ++) {
        [attributed_str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange([KeyWorld[i] integerValue], 1)];
        
    }
    return attributed_str;
}

-(NSMutableArray *)rangeOfString:(NSString*)subString inString:(NSString*)string atOccurrence:(NSInteger)occurrence Location:(NSMutableArray *)data_arr;
{
    int currentOccurrence = 0;
    NSRange rangeToSearchWithin = NSMakeRange(0, [string length]);
    while (YES)
    {
        currentOccurrence++;
        NSRange searchResult = [string rangeOfString:subString options:NSCaseInsensitiveSearch range:rangeToSearchWithin];//调用系统方法从要添加的字符串总找要高亮的字符的下标
        
        if (searchResult.location == NSNotFound)
        {
            return data_arr;
        }
        if (currentOccurrence == occurrence)
        {
            return data_arr;
        }
        
        NSInteger newLocationToStartAt = searchResult.location + searchResult.length;
        rangeToSearchWithin = NSMakeRange(newLocationToStartAt, string.length - newLocationToStartAt);//记录下次从哪里开始，排除掉已经排查的
        [data_arr addObject:[NSString stringWithFormat:@"%ld",searchResult.location]];//记录需要更换颜色的字的位置
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
