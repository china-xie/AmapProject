//
//  hotCityViewController.m
//  AMapProject
//
//  Created by xie on 2017/8/10.
//  Copyright © 2017年 xie. All rights reserved.
//

#import "hotCityViewController.h"
#import "selectEndViewController.h"
@interface hotCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * cityTableView;

@property(nonatomic,strong)NSArray * cityArr;
@end

@implementation hotCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cityTableView = [[UITableView alloc]init];
    
    [self.view addSubview:self.cityTableView];
    
    self.cityTableView.frame = self.view.bounds;
    
    self.cityTableView.delegate = self;
    
    self.cityTableView.dataSource = self;
      _cityArr = [NSArray arrayWithObjects:@"北京",@"上海",@"天津",nil];
    // Do any additional setup after loading the view.
}


-(NSArray *)cityArr{

    if (_cityArr == nil) {
        _cityArr = [NSArray arrayWithObjects:@"北京",@"上海",@"天津",nil];
    }

    return _cityArr;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _cityArr.count;


}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 50;

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cityCell"];
    
    cell.textLabel.text = _cityArr[indexPath.row];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    
    selectEndViewController *  destantionVc = [[selectEndViewController alloc]init];
    
    
    [self.navigationController pushViewController:destantionVc animated:YES];
    
    
    destantionVc.cityName = _cityArr[indexPath.row];

    

}
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

@end
