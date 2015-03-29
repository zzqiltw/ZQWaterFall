//
//  ZQWaterFallCell.m
//  瀑布流
//
//  Created by zzqiltw on 15-3-25.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQWaterFallCell.h"

@implementation ZQWaterFallCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    if (self = [self init]) {
        self.identifier = identifier;
    }
    return self;
}
@end
