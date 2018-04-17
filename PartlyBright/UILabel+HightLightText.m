//
//  UILabel+HightLightText.m
//  PartlyBright
//
//  Created by 孟庆洪 on 2018/4/12.
//  Copyright © 2018年 mqhong. All rights reserved.
//

#import "UILabel+HightLightText.h"
#import <objc/runtime.h>


static const void *setMm_HeightLightTextKey = &setMm_HeightLightTextKey;
static const void *setMm_HeightLightColorKey = &setMm_HeightLightColorKey;
static const void *setMm_NotHeightLightColorKey = &setMm_NotHeightLightColorKey;
@implementation UILabel (HightLightText)


-(instancetype)init{
    self = [super init];
//    Method sysMeth = class_getInstanceMethod([self class], @selector(setText:));
//    Method myMeth = class_getInstanceMethod([self class],@selector(setTextHooked:));
//    //然后用我们自己的函数的实现，替换目标函数对应的实现
//    sysImp = method_getImplementation(sysMeth);
//    myImp = method_getImplementation(myMeth);
//
//    // 获取到UILabel中setText对应的method
//    Method setText =class_getInstanceMethod([UILabel class], @selector(setText:));
//    Method setTextMySelf =class_getInstanceMethod([self class],@selector(setTextHooked:));
//
//    // 将目标函数的原实现绑定到setTextOriginalImplemention方法上
//    IMP setTextImp =method_getImplementation(setText);
//    class_addMethod([UILabel class], @selector(setTextOriginal:), setTextImp,method_getTypeEncoding(setText));
//
//    //然后用我们自己的函数的实现，替换目标函数对应的实现
//    IMP setTextMySelfImp =method_getImplementation(setTextMySelf);
//    class_replaceMethod([UILabel class], @selector(setText:), setTextMySelfImp,method_getTypeEncoding(setText));

    
    [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"textColor" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"layoutSubviews" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"text"]) {
        //如果当前是否已经把要设置的高亮数据设置了，如果设置了 就调用高亮
        if (self.mm_HeightLightText != nil) {
            self.mm_HeightLightText = self.mm_HeightLightText;
        }
    }
    else if ([keyPath isEqualToString:@"textColor"]){
        if ([change[@"new"] isKindOfClass:[UIColor class]]) {
            self.mm_NotHeightLightColor = change[@"new"];
        }
    }
    else if ([keyPath isEqualToString:@"layoutSubviews"]){
        NSLog(@"加载完成了哇");
    }
}

-(NSString *)mm_HeightLightText{
    return objc_getAssociatedObject(self, setMm_HeightLightTextKey);
}

-(void)setMm_HeightLightText:(NSString *)str{
    objc_setAssociatedObject(self, setMm_HeightLightTextKey, str, OBJC_ASSOCIATION_COPY);
    //判断当前是否是已经赋值了
    if ([self.text length] != 0) {
        //调用修改颜色
        [self setTextPartOfHightLight:self.text  hightText:str];
    }
}

-(UIColor *)mm_HeightLightColor{
    return objc_getAssociatedObject(self, setMm_HeightLightColorKey);
}

-(void)setMm_HeightLightColor:(UIColor *)color{
    objc_setAssociatedObject(self, setMm_HeightLightColorKey, color, OBJC_ASSOCIATION_COPY);
    //判断当前是否是已经赋值了
    if ([self.text length] != 0) {
        //调用修改颜色
        [self setTextPartOfHightLight:self.text  hightText:self.mm_HeightLightText];
    }
}

-(UIColor *)mm_NotHeightLightColor{
    return objc_getAssociatedObject(self, setMm_NotHeightLightColorKey);
}

-(void)setMm_NotHeightLightColor:(UIColor *)color{
    objc_setAssociatedObject(self, setMm_NotHeightLightColorKey, color, OBJC_ASSOCIATION_COPY);
    //判断当前是否是已经赋值了
    if ([self.text length] != 0) {
        //调用修改颜色
        [self setTextPartOfHightLight:self.text  hightText:self.mm_HeightLightText];
    }
}

-(void)dealloc{
    //释放掉存的值
    objc_setAssociatedObject(self, setMm_HeightLightTextKey, nil, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, setMm_HeightLightColorKey, nil, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, setMm_NotHeightLightColorKey, nil, OBJC_ASSOCIATION_COPY);
    //取消掉kvo
    [self removeObserver:self forKeyPath:@"text"];
    [self removeObserver:self forKeyPath:@"textColor"];
    NSLog(@"注销了");
}

#pragma mark 此处为设置高亮

-(void)setTextPartOfHightLight:(NSString *)text  hightText:(NSString *)hightStr{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSUInteger len = [hightStr length];
    for(NSUInteger i=0; i<len; i++){//把hightStr变成以每个字符串为一个单位的数组
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
    
    UIColor *textColor = [UIColor blackColor];
    UIColor *hightTextColor = [UIColor blackColor];
    
    if (self.mm_HeightLightColor != nil) {
        hightTextColor = self.mm_HeightLightColor;
    }
    
    if (self.mm_NotHeightLightColor != nil) {
        textColor= self.mm_NotHeightLightColor;
    }
    self.attributedText = [self getAttrIbutedStrdistance:text textColor:textColor DataKeyWorld:arr keyWorldColor:hightTextColor];
    
}

///获得可变字符串
- (NSMutableAttributedString *)getAttrIbutedStrdistance:(NSString *)text1 textColor:(UIColor *)textColor DataKeyWorld:(NSMutableArray *)KeyWorld keyWorldColor:(UIColor *)keyWorldColor{
    NSInteger len1 = [text1 length];
    NSString *all_str = [NSString stringWithFormat:@"%@",text1];
    NSMutableAttributedString * attributed_str = [[NSMutableAttributedString alloc]initWithString:all_str];
    [attributed_str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:16] range:NSMakeRange(0, len1)];
    
    [attributed_str addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, len1)];
    for (int i = 0; i < KeyWorld.count; i ++) {
        [attributed_str addAttribute:NSForegroundColorAttributeName value:keyWorldColor range:NSMakeRange([KeyWorld[i] integerValue], 1)];
        
    }
    return attributed_str;
}

-(NSMutableArray *)rangeOfString:(NSString*)subString inString:(NSString*)string atOccurrence:(NSInteger)occurrence Location:(NSMutableArray *)data_arr;
{
    int currentOccurrence = 0;
    NSRange rangeToSearchWithin = NSMakeRange(0, [string length]);
    while (YES){
        currentOccurrence++;
        NSRange searchResult = [string rangeOfString:subString options:NSCaseInsensitiveSearch range:rangeToSearchWithin];//调用系统方法从要添加的字符串总找要高亮的字符的下标
        if (searchResult.location == NSNotFound){
            return data_arr;
        }
        if (currentOccurrence == occurrence){
            return data_arr;
        }
        
        NSInteger newLocationToStartAt = searchResult.location + searchResult.length;
        rangeToSearchWithin = NSMakeRange(newLocationToStartAt, string.length - newLocationToStartAt);//记录下次从哪里开始，排除掉已经排查的
        [data_arr addObject:[NSString stringWithFormat:@"%ld",searchResult.location]];//记录需要更换颜色的字的位置
    }
}

@end
