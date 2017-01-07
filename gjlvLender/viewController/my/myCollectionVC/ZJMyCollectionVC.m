//
//  ZJMyCollectionVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyCollectionVC.h"
#import "ZJMyCollectionCell.h"
@interface ZJMyCollectionVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectView;
@property(retain,nonatomic)NSMutableArray *mInfoDataSoure;
@end

@implementation ZJMyCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我收藏的目的地";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter
-(NSMutableArray *)mInfoDataSoure{
    if (_mInfoDataSoure == nil) {
        _mInfoDataSoure = [NSMutableArray arrayWithArray:@[]];
    }
    return _mInfoDataSoure;
}
#pragma mark  networking
-(void)getMyDestList{
    NSDictionary *mParaDic = @{@"leaderId":ZJ_UserID,@"pageIndex":@"1",@"pageSize":@"10"};
    [HttpApi getMyDestList:mParaDic SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *temp = [MTLJSONAdapter modelsOfClass:[ZJDestModel class] fromJSONArray:responseBody[@"dests"] error:&error];
        [self.mInfoDataSoure addObjectsFromArray:temp];
        [self.mInfoCollectView reloadData];
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mInfoDataSoure.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   return CGSizeMake(MainScreenFrame_Width/2, 150);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * SLCellIdentifier = @"ZJMyCollectionCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJMyCollectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJMyCollectionCell"];
    
    ZJMyCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    
    [cell loadDataWithModel:self.mInfoDataSoure[indexPath.row]];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
