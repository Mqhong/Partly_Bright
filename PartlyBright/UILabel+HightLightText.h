//
//  UILabel+HightLightText.h
//  PartlyBright
//
//  Created by 孟庆洪 on 2018/4/12.
//  Copyright © 2018年 mqhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (HightLightText)

///mm_HeightLightText 要高亮的字
-(NSString *)mm_HeightLightText;
-(void)setMm_HeightLightText:(NSString *)str;

///mm_HeightLightColor 高亮字的颜色
-(UIColor *)mm_HeightLightColor;
-(void)setMm_HeightLightColor:(UIColor *)color;


@end

