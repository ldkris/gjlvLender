//
//  ZJMyRouteView.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRouteVC.h"
#import "ZJRouteCell.h"
@interface ZJRouteVC ()
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property(nonatomic,retain)NSMutableArray *mDataSoure;

@property (weak, nonatomic) IBOutlet UIView *mBtnView;
@end

@implementation ZJRouteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = nil;
    [self.mInfoTableView setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"路线";
    NSArray *mArray = @[@"全部路线",@"待出行",@"待评价",@"已结束"];
    UIButton *mOldBtn;
//    for (NSString *str in mArray) {
    for (int i = 0; i<mArray.count; i++) {
        NSString *str = mArray[i];
        UIButton *mTempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mTempBtn setTitle:str forState:UIControlStateNormal];
        [mTempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mTempBtn setFont:DEFAULT_FONT(13)];
        mTempBtn.tag = i;
        [mTempBtn setBackgroundColor:SL_GRAY];
        [self.mBtnView addSubview:mTempBtn];
        [mTempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (mOldBtn == nil) {
                make.left.mas_equalTo(0);
            }else{
             make.left.equalTo(mOldBtn.mas_right).with.offset(0);
            }
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(MainScreenFrame_Width/mArray.count);
        }];
        
        UIView *mMarkView = [[UIView alloc]init];
        [mMarkView setBackgroundColor:SL_GRAY_Hard];
        [self.mBtnView addSubview:mMarkView];
        [mMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (mOldBtn == nil) {
                make.left.mas_equalTo(MainScreenFrame_Width/mArray.count);
            }else{
                make.left.equalTo(mOldBtn.mas_right).with.offset(0);
            }
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(1);
        }];

        
        mOldBtn = mTempBtn;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self unHideZJTbar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)mDataSoure{
    if (_mDataSoure == nil) {
        _mDataSoure = [NSMutableArray arrayWithArray:@[@"",@""]];
    }
    return _mDataSoure;
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"ZJRouteCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJRouteCell"];
    ZJRouteCell*cell = [tableView dequeueReusableCellWithIdentifier:@"ZJRouteCell"];
    return cell;
}

@end
