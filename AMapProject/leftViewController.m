//
//  leftViewController.m
//  AMapProject
//
//  Created by xie on 2017/8/9.
//  Copyright © 2017年 xie. All rights reserved.
//

#import "leftViewController.h"

@interface leftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation leftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView =  [[UITableView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height - 180-60-54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5+180+60)];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    // Do any additional setup after loading the view.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else{
    
        return 5;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section ==0) {
        return 80;
    }else{
    
        return 54;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIImageView * imageView= [[UIImageView alloc]init];
    
    imageView.backgroundColor =[UIColor clearColor];
    
    return imageView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else{
         cell.textLabel.text = @"18810125437";
        }
       
        
    } else if (indexPath.section ==1){
    
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"我的行程";
                break;
            case 1:
                cell.textLabel.text = @"我的钱包";
                break;
            case 2:
                cell.textLabel.text = @"邀请有奖";
                break;
            case 3:
                cell.textLabel.text = @"客服中心";
                break;
            case 4:
                cell.textLabel.text = @"设置";
                break;
            default:
                break;
        }
    
    }
     cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    return cell;

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
