# Partly_Bright
### UILable设置字体部分高亮

## How To Get Started
- 1 Add UILabel+HightLightText.h and UILabel+HightLightText.m to your project.
- 2 #import "UILabel+HightLightText.h" 
- 3 
```

    self.lbl.text = @"今天是个好日子，是个好日子呀";
    self.lbl.textColor = [UIColor greenColor];
    self.lbl.mm_HeightLightText = @"是";//default is black
    self.lbl.mm_HeightLightColor = [UIColor redColor];//default is black


```
