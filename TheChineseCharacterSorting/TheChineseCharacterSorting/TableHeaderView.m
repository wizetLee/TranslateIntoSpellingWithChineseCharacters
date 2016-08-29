//
//  TableHeaderView.m
//  TheChineseCharacterSorting
//
//  Created by admin on 16/8/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "TableHeaderView.h"
const float HeaderViewHeight = 24;

@implementation TableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLabel];
    }
    
    return self;
}


#pragma mark setter & getter

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(HeaderViewHeight, 0, [UIScreen mainScreen].bounds.size.width - 2 * HeaderViewHeight, HeaderViewHeight)];
        _titleLabel.font = [UIFont systemFontOfSize:HeaderViewHeight / 2.0];
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, HeaderViewHeight - 1, [UIScreen mainScreen].bounds.size.width, 1)];
        [_titleLabel addSubview:bottomLine];
        [self addSubview:_titleLabel];
        
    }
    
    return _titleLabel;
}


@end
