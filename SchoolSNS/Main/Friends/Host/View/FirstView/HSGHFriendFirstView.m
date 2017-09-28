//
//  HSGHFriendFirstView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/15.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFriendFirstView.h"
#import "HSGHFriendFirstTableViewCell.h"
#import "HSGHFriendDetailViewController.h"
#import "HSGHFriendViewModel.h"
#import "UIButton+HSGHFriendModeBtn.h"
#import "HSGHTools.h"
#import "HSGHZoneVC.h"
#import "UISearchBar+HSGHLeftMode.h"
#import "SchoolSNS-Swift.h"

@interface HSGHFriendFirstView () <UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate,
                                    UISearchBarDelegate> {
  NSInteger number;
  CGFloat oldY;
                                       
                                      
                                      
}

@property(nonatomic, copy) NSArray* recommentArray;//推荐数组
@property(nonatomic, copy) NSArray* searchArray;//搜索数组
@property(nonatomic, assign) BOOL isSearchMode;
@property(nonatomic, strong)  UIView * failView;
@property(nonatomic, copy)  NSString * keyWord;

@property(nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *cover;

@end

@implementation HSGHFriendFirstView

- (void)awakeFromNib {
  [super awakeFromNib];
  number = 20;
//  [self addSubview:self.mainTableView];
  self.mainTableView.delegate = self;
  self.mainTableView.dataSource = self;
    self.mainTableView.alwaysBounceHorizontal = NO;
    self.mainTableView.alwaysBounceVertical = YES;
  [self.mainTableView registerNib:[UINib nibWithNibName:@"HSGHFriendFirstTableViewCell"
                           bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"firstCell"];
    self.mainTableView.tableFooterView = [[UIView alloc]init];
    self.mainTableView.frame = CGRectMake(0, 44, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT-53-44-49);
    //CGRectMake(0, 53, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT-53-39-60);
    
    [self setupSearchBar];
    [self setupCover];
    
    
    _failView = [[[NSBundle mainBundle]loadNibNamed:@"HSGHFriendSearchFailView" owner:self options:nil]lastObject];
    _failView.frame = CGRectMake(0, 44, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT-53-44-49);
    //CGRectMake(0,50, HSGH_SCREEN_WIDTH, HSGH_SCREEN_HEIGHT - 64 - 50);
    [self addSubview:_failView];
    _failView.hidden = YES;
}

- (void)setupCover {
    CGRect frame;
    frame.size.width = HSGH_SCREEN_WIDTH;
    frame.size.height = HSGH_SCREEN_HEIGHT-53-44-49;
    frame.origin.x = 0;
    frame.origin.y = 44;
    UIButton *cover = [[UIButton alloc] initWithFrame:frame];
    cover.backgroundColor = [UIColor grayColor];
    cover.alpha=0.01;
    _cover = cover;
    [_cover addTarget:self action:@selector(coverClick:) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview:_cover];
}

- (void)setupSearchBar {
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, HSGH_SCREEN_WIDTH, 44)];
    [_searchBar changeLeftPlaceholder:@"请输入TA的中文全名"];
    _searchBar.showsCancelButton = NO;
    _searchBar.delegate = self;
    [self addSubview:_searchBar];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isSearchMode ? _searchArray.count : _recommentArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HSGHFriendFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
  [cell setup:FRIEND_CATE_SEARCH];
    
    cell.systemInstLabel.hidden = _isSearchMode;
  
    HSGHFriendSingleModel* model = _isSearchMode ? _searchArray[indexPath.row] : _recommentArray[indexPath.row];
    if (model) {
        [cell updateInfo:model];
    }
    cell.block = ^(NSInteger state) {
        if(state == 1000){
            _recommentArray = [NSArray arrayWithArray:[self removeIndexItem:_recommentArray WithIndexPath:indexPath]];
            [self.mainTableView reloadData];
            
        }
    };
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HSGHFriendDetailViewController * detailVC = [HSGHFriendDetailViewController new] ;
    detailVC.model =  _isSearchMode ? _searchArray[indexPath.row] : _recommentArray[indexPath.row];
    HSLog(@"---detailVC.model.userId=%@",detailVC.model.userId);
    
    [HSGHZoneVC enterOtherZone:detailVC.model.userId];
    
}

- (void)setRecommentArray:(NSArray *)recommentArray {
    _isSearchMode = NO;
    _recommentArray = recommentArray;
    _failView.hidden = YES;
    [self.mainTableView reloadData];
}

- (void)setSearchArray:(NSArray *)searchArray isSuccess:(BOOL)isSuccess {
    _isSearchMode = YES;
    if(searchArray.count > 0){
        _failView.hidden = YES;
    }else{
        _failView.hidden = NO;
    }
    
    
    _searchArray = searchArray;
    [self.mainTableView reloadData];
}

- (void)frndFirstViewEndEdit {
    [_searchBar resignFirstResponder];
    [self hideCover];
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
    HSLog(@"-----textDidChange-----searchText====%@",searchText);
    if (searchText.length==0) {
        _isSearchMode = NO;
        [self setRecommentArray:_recommentArray];
        [self frndFirstViewEndEdit];
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
        _isSearchMode = YES;
        NSString *lowerSearchText = [searchText lowercaseString];
        //在好友和本院中模糊查询
        HSLog(@"模糊查询===lowerSearchText===%@",lowerSearchText);
        
//        NSString *regex = @"[\u4e00-\u9fa5]{2,}";
//        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//        if (![pred evaluateWithObject:lowerSearchText]) {
//            _searchBar.text = @"";
//            [self hideCover];
//            [_searchBar resignFirstResponder];
//            
//            Toast* toast = [[Toast alloc]initWithText:@"请输入正确的中文名字" delay:0 duration:1.f];
//            [toast show];
//            
//            return ;
//        }
        
        //搜索
        [self.delegate searchDetailWithText:lowerSearchText];
        
        [self hideCover];
        [_searchBar resignFirstResponder];
        
    } else {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索内容"];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //NSLog(@"cancle clicked");
    _isSearchMode = NO;
    _searchBar.text = @"";
    
    //[self setFriendArray:_friendArray];
    
    [self setRecommentArray:_recommentArray];
    
    [self frndFirstViewEndEdit];
    
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
        _isSearchMode = NO;
       // [self setFriendArray:_friendArray];
    }
    [self hideCover];
}

- (void)hideCover {
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        _cover.alpha = 0.01;
    }];
}

- (void)showCover {
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        _cover.alpha = 0.4;
    }];
    [self bringSubviewToFront:_cover];
}

@end
