//
//  ZJMyCommDeatilVC.m
//  gjlvLender
//
//  Created by 刘冬 on 2016/12/26.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyCommDeatilVC.h"
#import "ZJRouteCell.h"
#import "ZJCommDeatlCell.h"
@interface ZJMyCommDeatilVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(strong,nonatomic)NSDictionary *infoDic;
@end

@implementation ZJMyCommDeatilVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的评价";
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
    
    [self getMyComm];
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
-(NSDictionary *)infoDic{
    if (_infoDic == nil) {
        _infoDic = [NSDictionary dictionary];
    }
    
    return _infoDic;
}
#pragma mark networking
-(void)getMyComm{
    if (self.mRoteModel) {
        NSDictionary *mparaDic = @{@"leaderId":ZJ_UserID,@"urId":[self.mRoteModel.mrid stringValue]};
        [HttpApi getCommentToMe:mparaDic SuccessBlock:^(id responseBody) {
            self.infoDic = responseBody;
            [self.mInfoTableView reloadData];
        } FailureBlock:^(NSError *error) {
            
        }];
    }

}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [tableView registerNib:[UINib nibWithNibName:@"ZJRouteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRouteCell"];
        ZJRouteCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRouteCell"];
        cell.mBtn_status.hidden = YES;
        cell.mbtn_check.hidden =  YES;
        [cell loadDataSoreWithModel:self.mRoteModel];
        return cell;
    }
    [tableView registerNib:[UINib nibWithNibName:@"ZJCommDeatlCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJCommDeatlCell"];
    ZJCommDeatlCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJCommDeatlCell"];
    if ([self.infoDic allKeys].count >0) {
         [cell loadMarkbtns:[self.infoDic[@"score"] intValue]];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
@end
