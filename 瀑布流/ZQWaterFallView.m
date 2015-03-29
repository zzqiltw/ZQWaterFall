//
//  ZQWaterFallView.m
//  瀑布流
//
//  Created by zzqiltw on 15-3-25.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQWaterFallView.h"
#import "ZQWaterFallCell.h"

#define ZQWaterFallViewDefaultHeight 80
#define ZQWaterFallViewDefaultColumns 3
#define ZQWaterFallViewDefaultMargin 8

@interface ZQWaterFallView ()

@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 *  key:index value:cell
 */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;
@property (nonatomic, strong) NSMutableSet *reusedCells;

@end

@implementation ZQWaterFallView

- (void)didMoveToSuperview
{
    [self reloadData];
}

- (NSMutableDictionary *)displayingCells
{
    if (!_displayingCells) {
        self.displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}

- (NSMutableSet *)reusedCells
{
    if (!_reusedCells) {
        self.reusedCells = [NSMutableSet set];
    }
    return _reusedCells;
}

- (NSMutableArray *)cellFrames
{
    if (!_cellFrames) {
        self.cellFrames = [[NSMutableArray alloc] init];
    }
    return _cellFrames;
}

- (void)reloadData
{
    // 先清空所有
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusedCells removeAllObjects];
    
    NSInteger numberOfCells = [self.dataSource numbersOfCellInView:self];
    NSInteger numberOfColumns = [self numberOfColumns];
    
    CGFloat leftMargin = [self marginForType:ZQWaterFallMarginTypeLeft];
    CGFloat rightMargin = [self marginForType:ZQWaterFallMarginTypeRight];
    CGFloat colMargin = [self marginForType:ZQWaterFallMarginTypeCol];
    CGFloat topMargin = [self marginForType:ZQWaterFallMarginTypeTop];
    CGFloat rowMargin = [self marginForType:ZQWaterFallMarginTypeRow];
    CGFloat cellWidth = (self.frame.size.width - leftMargin - rightMargin -  colMargin * (numberOfColumns - 1)) / numberOfColumns;
    
    NSMutableArray *maxYArray = [NSMutableArray array];
    for (NSInteger i = 0; i < numberOfColumns; ++i) {
        [maxYArray addObject:@(0.0)];
    }
    
    for (NSInteger i = 0; i < numberOfCells; ++i) {
        NSInteger currentCol = 0;
        CGFloat currentY = [maxYArray[currentCol] floatValue];
        // 找最大Y值最小的一列插入
        for (NSInteger j = 1; j < maxYArray.count; ++j) {
            if ([maxYArray[j] floatValue] < currentY) {
                currentY = [maxYArray[j] floatValue];
                currentCol = j;
            }
        }
        
        CGFloat cellHeight = [self heightAtIndex:i];
        CGFloat cellX = currentCol * (cellWidth + colMargin) + leftMargin;
        CGFloat cellY = 0.0;
        if (currentY == 0.0) {
            cellY = topMargin + rowMargin;
        } else {
            cellY = rowMargin + currentY;
        }
        // 计算frame
        CGRect cellFrame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        // 更新最大Y值
        maxYArray[currentCol] = @(CGRectGetMaxY(cellFrame));
//        不要在这里加cell，应该在滚动的时候加cell，layoutSubview方法里
//        ZQWaterFallCell *cell = [self.dataSource waterFallView:self cellAtIndex:i];
//        cell.frame = cellFrame;
//        [self addSubview:cell];
    }
    CGFloat maxY = [maxYArray[0] floatValue];
    for (NSInteger i = 1; i < maxYArray.count; ++i) {
        if (maxY < [maxYArray[i] floatValue]) {
            maxY = [maxYArray[i] floatValue];
        }
    }
    self.contentSize = CGSizeMake(0, maxY);
}

// 滚动的时候也会调用这个方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger cellFrameCount = self.cellFrames.count;
    for (NSInteger i = 0; i < cellFrameCount; ++i) {
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        // 先从字典里去，做一层缓存，要不然每次滚动都要添加新的cell在原来的位置
        ZQWaterFallCell *cell = self.displayingCells[@(i)];
        if ([self isOnScreen:cellFrame]) { // 当前cell需要在屏幕上
            if (cell == nil) { //如果没有在"正在展示的cell"字典中，则创建并加入字典
                cell = [self.dataSource waterFallView:self cellAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                // 添加到字典
                self.displayingCells[@(i)] = cell;
            }
        } else { // 如果不在屏幕上
            if (cell != nil) { // 将cell放到缓存池中，并把displayingCell中的cell清楚，还要从父控件移除
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                [self.reusedCells addObject:cell];
            }
        }
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block ZQWaterFallCell *reusedCell = nil;
    [self.reusedCells enumerateObjectsUsingBlock:^(ZQWaterFallCell *cell, BOOL *stop) {
        if ([cell.identifier isEqualToString:identifier]) {
            reusedCell = cell;
            // 找到了就从缓存池中移除
            [self.reusedCells removeObject:cell];
            *stop = YES;
        }
    }];
    return reusedCell;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    // 这里要以self的原点为（0，0）
    CGPoint point = [touch locationInView:self];
    
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id key, ZQWaterFallCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            if ([self.delegate respondsToSelector:@selector(waterFallView:didSelectedCellAtIndex:)]) {
                [self.delegate waterFallView:self didSelectedCellAtIndex:[key integerValue]];
            }
            *stop = YES;
        }
    }];
}

- (BOOL)isOnScreen:(CGRect)cellFrame
{
    return (CGRectGetMaxY(cellFrame) > self.contentOffset.y) && (CGRectGetMinY(cellFrame) < (self.contentOffset.y + self.frame.size.height));
}

- (NSInteger)numberOfColumns
{
    if ([self.dataSource respondsToSelector:@selector(numbersOfColsInView:)]) {
        return [self.dataSource numbersOfColsInView:self];
    }
    return ZQWaterFallViewDefaultColumns;
}

- (CGFloat)heightAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterFallView:heightAtIndex:)]) {
        return [self.delegate waterFallView:self heightAtIndex:index];
    }
    return ZQWaterFallViewDefaultHeight;
}

- (CGFloat)marginForType:(ZQWaterFallMarginType)marginType
{
    if ([self.delegate respondsToSelector:@selector(waterFallView:marginForType:)]) {
        return [self.delegate waterFallView:self marginForType:marginType];
    }
    return ZQWaterFallViewDefaultMargin;
}

@end
