//
//  ViewController.m
//  TheChineseCharacterSorting
//
//  Created by admin on 16/8/29.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import "TableHeaderView.h"
#import "User.h"

#define CELLID @"customCellID"
#define HEADERID @"customHeaderID"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSMutableArray *nickNameArr;
@property (nonatomic, strong) NSMutableArray *sectionTitleArr;
@property (nonatomic, strong) NSMutableArray *anArrayOfArrays;
@property (nonatomic, strong) NSMutableDictionary *dicForNickName;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = false;
    
    self.nickNameArr = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        NSArray *arr = @[@"hName",@"cName",@"bName",@"jName",@"dName",@"eName",@"fName",@"aName",@"iName",@"gName",@"最小明",@"小明",@"中明",@"大明",@"特大明",@"_知不鸟",@",花不园",@"987654321",@"Zoom"];
        for (int j = 0; j < arr.count; j++) {
            [self.nickNameArr addObject:arr[j]];
        }
    }
    
//    [self method1];   //不支持str前缀有空格，需要做过滤操作, 效率非常低下
    
    [self method2];   //效率还好 方法简单
    
    [self.view addSubview:self.tableView];
}

- (void)method2 {
    
    @autoreleasepool {
        
        //    self.anArrayOfArrays -- 包含每个section的数据
        self.anArrayOfArrays = [NSMutableArray array];
        for (int i = 0; i < self.sectionTitleArr.count; i++) {
            NSMutableArray *tmpMArray = [NSMutableArray array];
            [self.anArrayOfArrays addObject:tmpMArray];
        }
        
        //     user.name 必须有值
        NSMutableArray *userArr = [NSMutableArray arrayWithCapacity:self.nickNameArr.count];
        for (NSString *str in self.nickNameArr) {
            User *user = [[User alloc] init];
            user.name = str;
            [userArr addObject:user];
        }
        
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
        
        
        for (User *user in userArr) {
            if (user.name) {
                NSInteger section = [collation sectionForObject:user collationStringSelector:@selector(name)];
                [(NSMutableArray *)self.anArrayOfArrays[section] addObject:user];
            }
        }
        
        for (NSMutableArray *arr in self.anArrayOfArrays) {
            NSArray *sortArr = [collation sortedArrayFromArray:arr collationStringSelector:@selector(name)];
            [arr removeAllObjects];
            [arr addObjectsFromArray:sortArr];
        }
        
        //        for (int i = 0; i < self.anArrayOfArrays.count; i++) {
        //            NSArray *arr = self.anArrayOfArrays[i];
        //            for (int j = 0; j < arr.count; j++) {
        //                NSLog(@"%@",((User *)(arr[j])).name);
        //            }
        //        }
        
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
        
    }

}

- (void)method1 {
  
    @autoreleasepool {
        
        //    self.anArrayOfArrays
        for (int i = 0; i < self.sectionTitleArr.count; i++) {
            NSMutableArray *tmpMArray = [NSMutableArray array];
            [self.dic setObject:tmpMArray forKey:self.sectionTitleArr[i]];
            [self.anArrayOfArrays addObject:tmpMArray];
        }
        
        self.nickNameArr = [self sortWithArray:self.nickNameArr].mutableCopy;//排序之后
        
        for (int i = 0; i < self.nickNameArr.count; i++) {
            for (int j = 0; j < self.sectionTitleArr.count; j++) {
                
                if ([[[[self translateIntoSpellingWithChineseCharacters:(NSString *)self.nickNameArr[i]] uppercaseString] substringToIndex:1] isEqualToString:self.sectionTitleArr[j]]) {
                    NSMutableArray *tmpMArr = [self.dic objectForKey:self.sectionTitleArr[j]];
                    [tmpMArr addObject:self.nickNameArr[i]];
                    break;
                }
                
                if (self.sectionTitleArr[j] == self.sectionTitleArr.lastObject) {
                    NSMutableArray *tmpMArr = self.anArrayOfArrays.lastObject;
                    [tmpMArr addObject:self.nickNameArr[i]];
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

    }
   
    [self.tableView reloadData];
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
    
    if ([((NSArray *)self.anArrayOfArrays[indexPath.section])[indexPath.row] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = ((NSArray *)self.anArrayOfArrays[indexPath.section])[indexPath.row];//method1
    } else {
        cell.textLabel.text = ((User *)((NSArray *)self.anArrayOfArrays[indexPath.section])[indexPath.row]).name;
    }
    
    
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
        _sectionTitleArr = [NSMutableArray arrayWithArray:[UILocalizedIndexedCollation currentCollation].sectionTitles];
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

- (NSMutableDictionary *)dicForNickName {
    
    if (!_dicForNickName) {
        _dicForNickName = [NSMutableDictionary dictionary];
    }
    
    return _dicForNickName;
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString* latin = [dic objectForKey:str];// 采用字典做缓存
    
    if (latin) {
        return latin;
    } else {
        CFStringTransform((__bridge CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
        [self.dicForNickName setObject:str forKey:chinese];
        return [self.dicForNickName objectForKey:chinese];
    }
}



@end
