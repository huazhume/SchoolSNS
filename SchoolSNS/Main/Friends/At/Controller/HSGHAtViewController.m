//
//  HSGHFriendSecondView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHAtViewController.h"
#import "HSGHFriendFirstTableViewCell.h"
#import "HSGHFriendDetailViewController.h"
#import "HSGHFriendViewModel.h"
#import "HSGHGroupHeaderView.h"
#import "UISearchBar+HSGHLeftMode.h"
#import "NSString+pinyin.h"
#import "UITableView+ZYXIndexTip.h"
#import "HSGHATFriendTableViewCell.h"

@interface HSGHAtViewController () <UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate,
                                    UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *cover;
@property (nonatomic, strong) NSArray *sectionIndexArray;// 拼音首字母列表
@property(nonatomic, copy) NSArray* friendArray;
@property(nonatomic, copy) NSArray* searchFriendArray;
@property (nonatomic, strong) NSArray *dataArray;// 格式化的好友列表数据
@property (nonatomic,assign) BOOL searched;

@end


@implementation HSGHAtViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择被@的人";
    [self addLeftNavigationBarBtnWithString:@"取消"];
    [self addRightNavigationBarBtnWithString:@"确定"];
    [self setRightButtonClickable:NO];
    
    [self setupTableView];
    [self setupSearchBar];
    [self setupCover];
    
    [self setFriendArray:[NSArray arrayWithArray: [HSGHFriendViewModel fetchDataWithType:FRIEND_CATE_SCHOLL]]];
}

#pragma mark - private method

- (void)setupTableView {
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.alwaysBounceHorizontal = NO;
    self.mainTableView.alwaysBounceVertical = YES;
    //self.mainTableView.bounces = NO;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"HSGHATFriendTableViewCell"
                                                   bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"secondCell"];
    self.mainTableView.tableFooterView = [[UIView alloc]init];
    self.mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, HSGH_SCREEN_WIDTH, 0.01f)];
    //self.mainTableView.sectionIndexBackgroundColor = [UIColor greenColor];
    self.mainTableView.sectionIndexColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1.0];
}

- (void)setupSearchBar {
    [_searchBar changeLeftPlaceholder:@"请输入好友的名字"];
    _searchBar.showsCancelButton = NO;
    _searchBar.delegate = self;
    
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0] andHeight:44.0f];
    [_searchBar setBackgroundImage:searchBarBg];
}

- (UIImage*)GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height {
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)setupCover {
    CGRect frame;
    frame.size.width = HSGH_SCREEN_WIDTH;
    frame.size.height = HSGH_SCREEN_HEIGHT-53-44-49;
    frame.origin.x = 0;
    frame.origin.y = 97;
    UIButton *cover = [[UIButton alloc] initWithFrame:frame];
    cover.backgroundColor = [UIColor grayColor];
    cover.alpha=0.01;
    _cover = cover;
    [_cover addTarget:self action:@selector(coverClick:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:_cover];
}


#pragma mark - tableView 数据源 + 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionIndexArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSGHATFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HSGHFriendSingleModel* model = _dataArray[indexPath.section][indexPath.row];
    cell.model = model;
    
//    HSGHFriendFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell"];
//    [cell setup:FRIEND_CATE_SCHOLL];
//    
//    HSGHFriendSingleModel* model = _dataArray[indexPath.section][indexPath.row];
//    if (model) {
//        [cell updateInfo:model];
//    }
//    cell.block = ^(NSInteger state) {
//        if(state == 1000){
//            _friendArray = [NSArray arrayWithArray:[self removeIndexItem:_friendArray WithIndexPath:indexPath]];
//            [self.mainTableView reloadData];
//            
//        }
//    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //HSGHFriendSingleModel * model = _friendArray[indexPath.section][indexPath.row];
//    HSGHFriendSingleModel* model = _dataArray[indexPath.section][indexPath.row];
//    if(_block){
//        self.block(YES,model);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    HSGHFriendSingleModel* model = _dataArray[indexPath.section][indexPath.row];
    model.selected = !model.selected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@" selected = 1 "];
    NSArray *preArr = [_friendArray filteredArrayUsingPredicate:pred];
    [self setRightButtonClickable:(preArr.count > 0) ? YES : NO];

    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HSGHGroupHeaderView * headErView = [[[NSBundle mainBundle]loadNibNamed:@"HSGHGroupHeaderView" owner:self options:nil]lastObject];
    headErView.textLab.text = _sectionIndexArray[section];
    return headErView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionIndexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_sectionIndexArray indexOfObject:title];
}


- (void)rightBarItemBtnClicked:(UIButton *)btn {
    HSLog(@"---AT---sure---");
    NSPredicate *pred = [NSPredicate predicateWithFormat:@" selected = 1 "];
    NSArray *preArr = [_friendArray filteredArrayUsingPredicate:pred];
    if (preArr.count > 0) {
        if (_blockArr) {
            _blockArr(YES,preArr);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFriendArray:(NSArray *)friendArray {
    _friendArray = friendArray;//HSGHFriendSingleModel
    
    _dataArray = [self getFriendListDataBy:_friendArray];
    
    [self.mainTableView reloadData];
    [self.mainTableView addIndexTip];
    
}

- (void)leftBarItemBtnClicked:(UIButton *)btn {
    if(_block){
        HSGHFriendSingleModel* model = [HSGHFriendSingleModel new];
        model.displayName = @"";
        self.block(YES,model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)getFriendListDataBy:(NSArray *)array {
    if (array.count > 0) {//生成fullName的拼音
        for (HSGHFriendSingleModel *user in array) {
            user.fullNamePY = [user.fullName pinyinForSort:YES];
        }
    }
    
    NSMutableArray *ans = [[NSMutableArray alloc] init];
    
    NSArray *serializeArray = [(NSArray *)array sortedArrayUsingComparator:^NSComparisonResult(HSGHFriendSingleModel *obj1, HSGHFriendSingleModel* obj2) {// 排序
        int i;
        NSString *strA = obj1.fullNamePY;
        NSString *strB = obj2.fullNamePY;
        
        for (i = 0; i < strA.length && i < strB.length; i ++) {
            char a = [strA characterAtIndex:i];
            char b = [strB characterAtIndex:i];
            if (a > b) {
                return (NSComparisonResult)NSOrderedDescending;          // 上升
            }
            else if (a < b) {
                return (NSComparisonResult)NSOrderedAscending;         // 下降
            }
        }
        
        if (strA.length > strB.length) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else if (strA.length < strB.length){
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    char lastC = '1';
    NSMutableArray *data;
    NSMutableArray *oth = [[NSMutableArray alloc] init];
    
    NSMutableSet *mSet = [NSMutableSet set];
    for (HSGHFriendSingleModel *user in serializeArray) {
        NSString *tmpStr = user.fullNamePY;
        char c = [tmpStr characterAtIndex:0];
        [mSet addObject:[[tmpStr substringToIndex:1] uppercaseString]];
        if (!isalpha(c)) {
            [oth addObject:user];
        }
        else if (c != lastC){
            lastC = c;
            if (data && data.count > 0) {
                [ans addObject:data];
            }
            
            data = [[NSMutableArray alloc] init];
            [data addObject:user];
        }
        else {
            [data addObject:user];
        }
    }
    
    NSArray *searray = [mSet allObjects];
    _sectionIndexArray = [searray sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];
    
    HSLog(@"-----_sectionIndexArray===%@",_sectionIndexArray);
    
    if (data && data.count > 0) {
        [ans addObject:data];
    }
    if (oth.count > 0) {
        [ans addObject:oth];
    }
    
    return ans;
}



- (NSArray *)removeIndexItem:(NSArray *)array WithIndexPath:(NSIndexPath *)indexPath {
    //    HSGHFriendSingleModel * model = _friendArray[indexPath.section][indexPath.row];
    NSMutableArray * modelArr =  [NSMutableArray arrayWithArray:_friendArray[indexPath.section]];
    [modelArr removeObjectAtIndex:indexPath.row];
    NSMutableArray * lastArr = [NSMutableArray arrayWithArray:_friendArray];
    [lastArr replaceObjectAtIndex:indexPath.section withObject:modelArr];
    return lastArr;
    
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    for (id cc in [searchBar.subviews[0] subviews]) {
        if ([cc isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0] forState:UIControlStateNormal];
        }
    }
    [self showCover];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *seeText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (seeText.length > 0) {
        _searched = YES;
        NSString *lowerSearchText = [seeText lowercaseString];
        //在好友和本院中模糊查询
        HSLog(@"模糊查询===lowerSearchText===%@",lowerSearchText);
        
        //HSGHFriendSingleModel  friendArray  searchFriendArray
        NSMutableArray *searchMarr = [NSMutableArray array];
        for (HSGHFriendSingleModel *tmpModel in _friendArray) {
            NSString *tmpFullName = [tmpModel.fullName lowercaseString];
            NSString *tmpFullNamePY = [tmpModel.fullNamePY lowercaseString];
            
            if (tmpModel.fullNameEn!=nil ) {
                if ([tmpFullName containsString:lowerSearchText] || [tmpFullNamePY containsString:lowerSearchText] || [[tmpModel.fullNameEn lowercaseString] containsString:lowerSearchText]) {
                    [searchMarr addObject:tmpModel];
                }
                
            } else {
                if ([tmpFullName containsString:lowerSearchText] || [tmpFullNamePY containsString:lowerSearchText] ) {
                    [searchMarr addObject:tmpModel];
                }
            }
        }
        
        _searchFriendArray = [searchMarr copy];
        
        _dataArray = [self getFriendListDataBy:_searchFriendArray];
        [self.mainTableView reloadData];
    } else {
        _searched = NO;
        _dataArray = [self getFriendListDataBy:_friendArray];
        [self.mainTableView reloadData];
    }
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (searchText.length > 0) {
        _searched = YES;
        NSString *lowerSearchText = [searchText lowercaseString];
        //在好友和本院中模糊查询
        HSLog(@"模糊查询===lowerSearchText===%@",lowerSearchText);
        
        //HSGHFriendSingleModel  friendArray  searchFriendArray
        NSMutableArray *searchMarr = [NSMutableArray array];
        for (HSGHFriendSingleModel *tmpModel in _friendArray) {
            NSString *tmpFullName = [tmpModel.fullName lowercaseString];
            NSString *tmpFullNamePY = [tmpModel.fullNamePY lowercaseString];
            
            if (tmpModel.fullNameEn!=nil ) {
                if ([tmpFullName containsString:lowerSearchText] || [tmpFullNamePY containsString:lowerSearchText] || [[tmpModel.fullNameEn lowercaseString] containsString:lowerSearchText]) {
                    [searchMarr addObject:tmpModel];
                }
                
            } else {
                if ([tmpFullName containsString:lowerSearchText] || [tmpFullNamePY containsString:lowerSearchText] ) {
                    [searchMarr addObject:tmpModel];
                }
            }
        }
        
        _searchFriendArray = [searchMarr copy];
        
        _dataArray = [self getFriendListDataBy:_searchFriendArray];
        [self.mainTableView reloadData];
        
        [self hideCover];
        [_searchBar resignFirstResponder];
        
    } else {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容"];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //NSLog(@"cancle clicked");
    _searched = NO;
    _searchBar.text = @"";
    
    [self setFriendArray:_friendArray];
    
    [_searchBar resignFirstResponder];
    [self hideCover];
    
}
//-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    if (searchText.length == 0) {
//        _searched = NO;
//        //取消搜索，再次查询数据库，获取好友，好友申请
//    }
//}

- (void)coverClick:(UIButton *) button {
    //_searchBar.text = @"";
    [_searchBar resignFirstResponder];
    if (_searchBar.text.length > 0) {
        
    }else{
        //取消搜索，再次查询数据库，获取好友，好友申请
        _searched = NO;
        [self setFriendArray:_friendArray];//
    }
    [self hideCover];
}

- (void)hideCover {
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        _cover.alpha = 0.01;
    }];
}

- (void)showCover {
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        _cover.alpha = 0.4;
    }];
    [self.view bringSubviewToFront:_cover];
}

@end

