//
//  ZQWaterFallCell.h
//  瀑布流
//
//  Created by zzqiltw on 15-3-25.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQWaterFallCell : UIView
@property (nonatomic, copy) NSString *identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier;
@end
