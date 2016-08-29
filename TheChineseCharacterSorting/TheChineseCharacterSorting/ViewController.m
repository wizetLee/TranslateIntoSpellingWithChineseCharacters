//
//  ViewController.m
//  TheChineseCharacterSorting
//
//  Created by admin on 16/8/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import "TableHeaderView.h"

#define CELLID @"customCellID"
#define HEADERID @"customHeaderID"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSArray *nickName;
@property (nonatomic, strong) NSMutableArray *sectionTitleArr;
@property (nonatomic, strong) NSMutableArray *anArrayOfArrays;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.nickName = @[@"hName",@"cName",@"bName",@"jName",@"dName",@"eName",@"fName",@"aName",@"iName",@"gName",@"最小明",@"小明",@"中明",@"大明",@"特大明",@"_知不鸟",@",花不园",@"987654321",@"Zoom"];
    
//    self.anArrayOfArrays
    for (int i = 0; i < self.sectionTitleArr.count; i++) {
        NSMutableArray *tmpMArray = [NSMutableArray array];
        [self.dic setObject:tmpMArray forKey:self.sectionTitleArr[i]];
        [self.anArrayOfArrays addObject:tmpMArray];
    }
    
    self.nickName = [self sortWithArray:self.nickName];//排序之后
    
    for (int i = 0; i < self.nickName.count; i++) {
        for (int j = 0; j < self.sectionTitleArr.count; j++) {
            
            if ([[[[self translateIntoSpellingWithChineseCharacters:(NSString *)self.nickName[i]] uppercaseString] substringToIndex:1] isEqualToString:self.sectionTitleArr[j]]) {
                NSMutableArray *tmpMArr = [self.dic objectForKey:self.sectionTitleArr[j]];
                [tmpMArr addObject:self.nickName[i]];
                break;
            }
            
            if ([self.sectionTitleArr[j] isEqualToString:@"other"]) {
                NSMutableArray *tmpMArr = [self.dic objectForKey:@"other"];
                [tmpMArr addObject:self.nickName[i]];
            }
            
        }
    }
    
    //去掉无数据的数组
    //同步 sectionTitleArr
    NSMutableArray *tmpArrA = [NSMutableArray array];
    NSMutableArray *tmpArrB = [NSMutableArray array];
    for (int i = 0; i < self.anArrayOfArrays.count; i++) {
        
        if (((NSMutableArray *)self.anArrayOfArrays[i]).count == 0) {
            [tmpArrA addObject:self.sectionTitleArr[i]];
            [tmpArrB addObject:self.anArrayOfArrays[i]];
        }
        
    }
    
    for (int i = 0; i < tmpArrA.count; i++) {
        [self.sectionTitleArr removeObject:tmpArrA[i]];
        [self.anArrayOfArrays removeObject:tmpArrB[i]];
    }
    
    
    [self.view addSubview:self.tableView];
}



#pragma mark table delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.anArrayOfArrays[section]).count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.anArrayOfArrays.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HEADERID];
    
    if (!headerView) {
        headerView = [[TableHeaderView alloc] initWithReuseIdentifier:HEADERID];
    }
    
    headerView.titleLabel.text = self.sectionTitleArr[section];
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.textLabel.text = ((NSArray *)self.anArrayOfArrays[indexPath.section])[indexPath.row];
    
    return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED {
    return self.sectionTitleArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return self.sectionTitleArr.count;
}

#pragma mark setter & getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.showsHorizontalScrollIndicator = false;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
        [_tableView registerClass:[TableHeaderView class] forHeaderFooterViewReuseIdentifier:HEADERID];
    }

    return _tableView;
}


- (NSMutableArray *)sectionTitleArr {
    
    if (!_sectionTitleArr) {
        _sectionTitleArr = [NSMutableArray arrayWithArray:@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"other"]];
    }
    
    return _sectionTitleArr;
}


- (NSMutableArray *)anArrayOfArrays {
    
    if (!_anArrayOfArrays) {
        _anArrayOfArrays = [NSMutableArray array];
    }
    
    return _anArrayOfArrays;
}

- (NSMutableDictionary *)dic {
    
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    
    return _dic;
}

#pragma mark 排序
- (NSArray *)sortWithArray:(NSArray *)array {
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (int i = 0; i < array.count; i++) {
        [mArray addObject:array[i]];
    }
    
    for(NSUInteger i = 0; i < mArray.count - 1; i++) {
        for(NSUInteger j = 0; j < mArray.count - i - 1; j++) {
            
            NSString *spellingA = [self translateIntoSpellingWithChineseCharacters:mArray[j]];
            NSString *spellingB = [self translateIntoSpellingWithChineseCharacters:mArray[j + 1]];
            
            if(NSOrderedDescending == [spellingA compare:spellingB]) {
                NSString *tempString = mArray[j];
                mArray[j] = mArray[j + 1];
                mArray[j + 1] = tempString;
            }
            
        }
    }
    
    NSArray *tmpArr = [NSArray arrayWithArray:mArray];
    
    return tmpArr;
}


- (NSString *)translateIntoSpellingWithChineseCharacters:(NSString *)chinese {
    
    NSMutableString *str = [NSMutableString stringWithString:chinese];
    CFStringTransform((__bridge CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    [str lowercaseString];//小写  因为 a-97 和 A-65 a和A开头的字符串 通常都在一起 所以要转成小写或者大写
    
    return str;
}

@end
