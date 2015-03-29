//
//  ZQViewController.m
//  瀑布流
//
//  Created by zzqiltw on 15-3-25.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ZQViewController.h"
#import "ZQWaterFallView.h"
#import "ZQWaterFallCell.h"

@interface ZQViewController () <ZQWaterFallViewDataSource, ZQWaterFallViewDelegate>

@end

@implementation ZQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ZQWaterFallView *waterFallView = [[ZQWaterFallView alloc] init];
    waterFallView.frame = self.view.bounds;
    waterFallView.delegate = self;
    waterFallView.dataSource = self;
    [self.view addSubview:waterFallView];
//    [waterFallView reloadData];
}

- (CGFloat)waterFallView:(ZQWaterFallView *)waterFallView heightAtIndex:(NSInteger)index
{
    switch (index % 3) {
        case 0:
            return 70;
            break;
        case 1:
            return 110;
            break;
        case 2:
            return 90;
            break;
        default:
            return 100;
            break;
    }
}

- (void)waterFallView:(ZQWaterFallView *)waterFallView didSelectedCellAtIndex:(NSInteger)index
{
    NSLog(@"selecIndex:%d", index);
}

- (CGFloat)waterFallView:(ZQWaterFallView *)waterFallView marginForType:(ZQWaterFallMarginType)marginType
{
    switch (marginType) {
        case ZQWaterFallMarginTypeTop:
            return 20;
            break;
        case ZQWaterFallMarginTypeLeft:
            return 8;
            break;
        case ZQWaterFallMarginTypeRight:
            return 8;
            break;
        case ZQWaterFallMarginTypeBottom:
            return 10;
            break;
        case ZQWaterFallMarginTypeRow:
            return 5;
            break;
        case ZQWaterFallMarginTypeCol:
            break;
            return 5;
        default:
            return 5;
            break;
    }
    return 5;
}

- (ZQWaterFallCell *)waterFallView:(ZQWaterFallView *)waterFallView cellAtIndex:(NSInteger)index
{
    static NSString *CellID = @"cell";
    ZQWaterFallCell *cell = [waterFallView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[ZQWaterFallCell alloc] initWithIdentifier:CellID];
    }
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    NSLog(@"%d %p", index, cell);
    return cell;
}

- (NSInteger)numbersOfCellInView:(ZQWaterFallView *)waterFallView
{
    return 200;
}

- (NSInteger)numbersOfColsInView:(ZQWaterFallView *)waterFallView
{
    return 3;
}

@end
