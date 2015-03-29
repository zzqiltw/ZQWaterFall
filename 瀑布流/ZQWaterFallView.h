//
//  ZQWaterFallView.h
//  瀑布流
//
//  Created by zzqiltw on 15-3-25.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ZQWaterFallMarginTypeTop,
    ZQWaterFallMarginTypeLeft,
    ZQWaterFallMarginTypeRight,
    ZQWaterFallMarginTypeBottom,
    ZQWaterFallMarginTypeRow,
    ZQWaterFallMarginTypeCol
} ZQWaterFallMarginType;

@class ZQWaterFallView;
@class ZQWaterFallCell;

@protocol ZQWaterFallViewDataSource <NSObject>

@required
- (NSInteger)numbersOfCellInView:(ZQWaterFallView *)waterFallView;
- (ZQWaterFallCell *)waterFallView:(ZQWaterFallView *)waterFallView cellAtIndex:(NSInteger)index;

@optional
- (NSInteger)numbersOfColsInView:(ZQWaterFallView *)waterFallView;

@end

@protocol ZQWaterFallViewDelegate <UIScrollViewDelegate>

@optional
- (CGFloat)waterFallView:(ZQWaterFallView *)waterFallView heightAtIndex:(NSInteger)index;
- (CGFloat)waterFallView:(ZQWaterFallView *)waterFallView marginForType:(ZQWaterFallMarginType)marginType;

- (void)waterFallView:(ZQWaterFallView *)waterFallView didSelectedCellAtIndex:(NSInteger)index;

@end
@interface ZQWaterFallView : UIScrollView

@property (nonatomic, weak) id<ZQWaterFallViewDelegate> delegate;
@property (nonatomic, weak) id<ZQWaterFallViewDataSource> dataSource;

- (void)reloadData;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier; 

@end
