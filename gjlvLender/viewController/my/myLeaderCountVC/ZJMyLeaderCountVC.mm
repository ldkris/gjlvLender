//
//  ZJMyLeaderCountVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyLeaderCountVC.h"
#import "ZJLeaderCountCell.h"
#import "ZJRouteCell.h"
#import "ZJMyCommDeatilVC.h"
@interface ZJMyLeaderCountVC ()
@property(nonatomic,retain)NSMutableArray *mDataSoure;
@end

@implementation ZJMyLeaderCountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"服务列表";
    
    [self getLeaderSrvList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray array];
    }
    return _mDataSoure;
}
#pragma mark networking
-(void)getLeaderSrvList{
    [self.mDataSoure removeAllObjects];
    NSDictionary *mParamDic = @{@"leaderId":ZJ_UserID,@"status":@"",@"pageIndex":@"1",@"pageSize":@"10"};
    [HttpApi getRouteList:mParamDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temps = [MTLJSONAdapter modelsOfClass:[ZJMyRoteModel class] fromJSONArray:responseBody[@"routes"] error:&error];
        //        LDLOG(@"%@",temps);
        if(!error){
            [self.mDataSoure addObjectsFromArray:temps];
            [self.mInfoTableView reloadData];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [tableView registerNib:[UINib nibWithNibName:@"ZJLeaderCountCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJLeaderCountCell"];
        ZJLeaderCountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJLeaderCountCell"];
        [cell loadDataWithModel:[ZJSingleHelper shareNetWork].mUserInfo];
        return cell;
    }
    [tableView registerNib:[UINib nibWithNibName:@"ZJRouteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRouteCell"];
    ZJRouteCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRouteCell"];
    if (self.mDataSoure.count>0) {
            [cell loadDataSoreWithModel:self.mDataSoure[indexPath.row - 1]];
    }
    cell.mBtn_status.hidden = YES;
    cell.mbtn_check.hidden =  YES;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        
        ZJMyRoteModel *model = self.mDataSoure[indexPath.row - 1];
        if ([model.mstatus intValue] == 4) {
            ZJMyCommDeatilVC *tempVC = [[ZJMyCommDeatilVC alloc]init];
            tempVC.mRoteModel = model;
            [self.navigationController pushViewController:tempVC animated:YES];
        }else{
            ShowMSG(@"用户还没评价");
        }
       
    }
}

@end
