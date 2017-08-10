//
//  selectEndViewController.m
//  AMapProject
//
//  Created by xie on 2017/8/10.
//  Copyright © 2017年 xie. All rights reserved.
//

#import "selectEndViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>

@interface selectEndViewController ()<AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar * searchBar;
@property(nonatomic,strong)UITableView * locationTableView;
@property (nonatomic, strong) AMapSearchAPI *search;

@property(nonatomic,strong)NSArray * locationArr;
@end

@implementation selectEndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.s
    
    self.title =@"选择目的地";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _locationTableView =[[UITableView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:_locationTableView];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];// 初始化，不解释
    [self.searchBar setPlaceholder:@"Search"];// 搜索框的占位符
//    [self.searchBar setPrompt:@"Prompt"];// 顶部提示文本,相当于控件的Title
    [self.searchBar setBarStyle:UIBarMetricsDefault];// 搜索框样式
    [self.searchBar setTintColor:[UIColor blackColor]];// 搜索框的颜色，当设置此属性时，barStyle将失效
    [self.searchBar setTranslucent:YES];// 设置是否透明
    [self.searchBar setSearchResultsButtonSelected:NO];// 设置搜索结果按钮是否选中
    [self.searchBar setShowsSearchResultsButton:YES];// 是否显示搜索结果按钮
    
    [self.searchBar setSearchTextPositionAdjustment:UIOffsetMake(30, 0)];// 设置搜索框中文本框的文本偏移量
    
    
    

    [self.searchBar setKeyboardType:UIKeyboardTypeEmailAddress];// 设置键盘样式
    
    // 设置搜索框下边的分栏条
    [self.searchBar setShowsScopeBar:YES];// 是否显示分栏条

    
    
    [self.searchBar setShowsBookmarkButton:YES];// 是否显示右侧的“书图标”
    
    [self.searchBar setShowsCancelButton:YES];// 是否显示取消按钮
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    // 是否提供自动修正功能（这个方法一般都不用的）
    [self.searchBar setSpellCheckingType:UITextSpellCheckingTypeYes];// 设置自动检查的类型
    [self.searchBar setAutocorrectionType:UITextAutocorrectionTypeDefault];// 是否提供自动修正功能，一般设置为UITextAutocorrectionTypeDefault
    
    self.searchBar.delegate = self;// 设置代理
    [self.searchBar sizeToFit];
//    _locationTableView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.searchBar.bounds), 0, 0, 0);
    
    
    
    
    [_locationTableView addSubview:self.searchBar];
    
    _locationTableView.delegate = self;
    
    _locationTableView.dataSource = self;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;{

return YES;

}                     // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{

    

}               // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
   
    return YES;
}                       // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{




}                     // called when text ends editing
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    
    


}  // called when text changes (including clear)
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0){
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.keywords            = searchBar.text;
    request.city                = self.cityName;
    //    request.types               = @"nil";
    //    request.requireExtension    = YES;
    
    /*  搜索SDK 3.2.0 中新增加的功能，只搜索本城市的POI。*/
    request.cityLimit           = YES;
    request.requireSubPOIs      = YES;
    [self.search AMapPOIKeywordsSearch:request];


    return YES;
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    self.locationArr = [NSArray array];
    
    self.locationArr = response.pois;
    
    [self.locationTableView reloadData];
    
    //解析response获取POI信息，具体解析见 Demo
}


// called before text changes   点击确定

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [self.searchBar resignFirstResponder];

}                     // called when keyboard search button pressed
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED{




} // called when bookmark button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED{





}   // called when cancel button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2) __TVOS_PROHIBITED{





} // called when search results button pressed

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope NS_AVAILABLE_IOS(3_0){





}




/* POI 搜索回调. */
//- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
//{
//    [self.mapView removeAnnotations:self.mapView.annotations];
//    
//    if (response.pois.count == 0)
//    {
//        return;
//    }
//    
//    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
//    
//    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
//        
//        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
//        
//    }];
//    
//    /* 将结果以annotation的形式加载到地图上. */
//    [self.mapView addAnnotations:poiAnnotations];
//    
//    /* 如果只有一个结果，设置其为中心点. */
//    if (poiAnnotations.count == 1)
//    {
//        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
//    }
//    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
//    else
//    {
//        [self.mapView showAnnotations:poiAnnotations animated:NO];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.locationArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 40;

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{



    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    AMapPOI * poi =self.locationArr[indexPath.row];
    cell.textLabel.text = poi.name;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 NSDictionary *userInfo = @{@"poi" : self.locationArr[indexPath.row]};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"destantionNotify" object:nil userInfo:userInfo];

    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
