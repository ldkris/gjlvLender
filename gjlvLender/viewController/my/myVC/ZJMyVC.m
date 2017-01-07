//
//  ZJMyVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyVC.h"
#import "ZJMyCell.h"
#import "ZJDMyCell1.h"
#import "ZJDMyCell2.h"

#import "ZJMyInfoVC.h"
#import "ZJMyRouteVC.h"
#import "ZJMyCollectionVC.h"
#import "ZJMyFootMarkVC.h"
#import "ZJMyLeaderVC.h"
#import "ZJSettingVC.h"
#import "ZJOpinionVC.h"
#import "ZJMyLeaderCountVC.h"
@interface ZJMyVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@end

@implementation ZJMyVC{
    ZJUserInfoModel*_userModel;
    NSString *_DCXCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self unHideZJTbar];
    
    [self getInfo];//获取个人信息
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark networking
-(void)getInfo{
    [[ZJNetWorkingHelper shareNetWork]mGetMyInfo:@{@"leaderId":ZJ_UserID} SuccessBlock:^(id responseBody) {
        NSError *error;
        _userModel = [MTLJSONAdapter modelOfClass:[ZJUserInfoModel class] fromJSONDictionary:responseBody error:&error];
        [ZJSingleHelper shareNetWork].mUserInfo = _userModel;
        [self.mInfoTableView reloadData];
        [self getWaitTravelCount];
    } FailureBlock:^(NSError *error) {
        
    }];
}
-(void)getWaitTravelCount{
    NSDictionary *mParaDic = @{@"leaderId":ZJ_UserID};
    [HttpApi getWaitTravelCount:mParaDic SuccessBlock:^(id responseBody) {
        _DCXCount = [NSString stringWithFormat:@"%@",responseBody[@"count"]];
        [self.mInfoTableView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark UITableViewDelegate && UITableViewDatasoure
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2.0f;
    }
    return 3.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJMyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJMyCell"];
            ZJMyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJMyCell"];
            [cell.img_head sd_setImageWithURL:[NSURL URLWithString:[ZJSingleHelper shareNetWork].mUserInfo.mHeadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"] options:EMSDWebImageRefreshCached];
            
            cell.mlab_Name.text =  [ZJSingleHelper shareNetWork].mUserInfo.mName;
            cell.mlab_phoneNum.text =  [ZJSingleHelper shareNetWork].mUserInfo.mMobile;
            [cell oncickLDBlock:^(UIButton *sender) {
                //申请领队
            }];
            [cell oncickHeadImgBlock:^(UIButton *sender) {
                ZJMyInfoVC *mTempVC = [[ZJMyInfoVC alloc]init];
                [self.navigationController pushViewController:mTempVC animated:YES];
            }];
            return cell;
        }
        if (indexPath.row == 1) {
            [tableView registerNib:[UINib nibWithNibName:@"ZJDMyCell1" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJDMyCell1"];
            ZJDMyCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJDMyCell1"];
            [cell loadDCXCount:_DCXCount];
            [cell onclickAllRouteBlock:^(UIButton *sender) {
                ZJMyRouteVC *mTempVC = [[ZJMyRouteVC alloc]init];
                mTempVC.mSelectIndex = 10;
                [self.navigationController pushViewController:mTempVC animated:YES];
            }];
            [cell onclickDDPBBlock:^(UIButton *sender) {
                ZJMyRouteVC *mTempVC = [[ZJMyRouteVC alloc]init];
                mTempVC.mSelectIndex = 11;
                [self.navigationController pushViewController:mTempVC animated:YES];
            }];
            [cell onclickDCXBlock:^(UIButton *sender) {
                ZJMyRouteVC *mTempVC = [[ZJMyRouteVC alloc]init];
                mTempVC.mSelectIndex = 12;
                [self.navigationController pushViewController:mTempVC animated:YES];
            }];
            return cell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = @[@"我的车友",@"我的评价",@"设置"][indexPath.row];
    [cell.textLabel setFont:DEFAULT_FONT(15)];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIView *lineView = [[UIView alloc]init];
    [lineView setBackgroundColor:SL_GRAY];
    [cell addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    return cell;
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //我的车友
            ZJMyLeaderVC *tempVC =[[ZJMyLeaderVC alloc]init];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
        if (indexPath.row == 1) {
            //我的评价
            ZJMyLeaderCountVC *tempVC = [[ZJMyLeaderCountVC alloc]init];
            [self.navigationController pushViewController:tempVC animated:YES];
        }
        if (indexPath.row ==2) {
            //设置
            ZJSettingVC *tempVC =[[ZJSettingVC alloc]init];
            [self.navigationController pushViewController:tempVC animated:YES];
            
        }
    }
}
@end
