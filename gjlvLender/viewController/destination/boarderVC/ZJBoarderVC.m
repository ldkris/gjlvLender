//
//  ZJBoarderVC.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/4.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJBoarderVC.h"
#import "ZJBoarderListCell.h"
#import "ZJBoardMapCell.h"
#import "ZJBDetailVC.h"
#import "RouteAnnotation.h"
#import "RFLayout.h"
@interface ZJBoarderVC ()
@property (weak, nonatomic) IBOutlet UIView *mNavView;
@property (weak, nonatomic) IBOutlet UITableView *mInfoTableView;
@property (weak, nonatomic) IBOutlet BMKMapView *mMapView;
@property (weak, nonatomic) IBOutlet UICollectionView *mInfoCollectionView;
@property (weak, nonatomic) IBOutlet UIView *mMapFirendsView;

@property(nonatomic,retain)NSMutableArray *mDataSoure;
@property(nonatomic,retain)NSMutableArray *mComments;
@end

@implementation ZJBoarderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mInfoTableView.rowHeight = UITableViewAutomaticDimension;
    self.mInfoTableView.estimatedRowHeight = 100;
    self.mInfoTableView.tableFooterView = [UIView new];
    [self.mInfoTableView  setBackgroundColor:[UIColor whiteColor]];
    [self.mNavView setBackgroundColor:BG_Yellow];
    
    RFLayout * layout = [[RFLayout alloc]init];
    [self.mInfoCollectionView  setCollectionViewLayout:layout];
    
    self.mMapView.hidden = YES;
    self.mMapFirendsView.hidden = YES;
    
    self.title = @"住宿";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"t_ad"] style:UIBarButtonItemStylePlain target:self action:@selector(changMapOrListBtn:)];
    
    // 下拉刷新
    self.mInfoTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.mDataSoure removeAllObjects];
        self.pageIndex = 1;
        
        [self getHotels];
    }];
    // 马上进入刷新状态
    [self.mInfoTableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.mInfoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self getHotels];
    }];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mMapView viewWillAppear];
    self.mMapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mMapView viewWillDisappear];
    self.mMapView.delegate = nil; // 不用时，置nil
    [self.mMapView removeAnnotations:self.mMapView.annotations];
}
- (void)dealloc {
    if (self.mMapView) {
        self.mMapView = nil;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.mMapView setZoomLevel:15];
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
#pragma mark netWorking
-(void)getHotels{
    NSString *latStr = [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.latitude];
    NSString *lngStr = [NSString stringWithFormat:@"%f",[ZJSingleHelper shareNetWork].mUeserPt.longitude];
    [[ZJNetWorkingHelper shareNetWork]getHotelList:@{@"leaderId":ZJ_UserID,@"destId":self.mSelectModel.mdestId,@"lat":latStr,@"lng":lngStr,@"pageIndex":[NSString stringWithFormat:@"%ld",self.pageIndex],@"pageSize":[NSString stringWithFormat:@"%ld",self.pageSize]} SuccessBlock:^(id responseBody) {
        NSError *error;
        NSArray *tempArray = [MTLJSONAdapter modelsOfClass:[ZJHotelListModel class] fromJSONArray:responseBody[@"hotels"] error:&error];
        if (tempArray.count == 0 && self.pageIndex>1) {
            [self.mInfoTableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        if (!error) {
            [self.mDataSoure addObjectsFromArray:tempArray];
            
            if (self.pageIndex == 1) {
                [self.mInfoTableView.mj_header endRefreshing];
                if (self.mDataSoure.count>0) {
                    [self setMapAnnotation:self.mDataSoure[0]];
                }
            }else{
                [self.mInfoTableView.mj_footer endRefreshing];
            }
            self.pageIndex++;
            [self.mInfoCollectionView reloadData];
            [self.mInfoTableView reloadData];
        }else{
            [self.mInfoTableView.mj_footer endRefreshing];
             [self.mInfoTableView.mj_header endRefreshing];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}
#pragma mark private
-(void)setMapAnnotation:(ZJHotelListModel *)model{
    if (model == nil) {
        return;
    }
    self.mMapView.delegate = (id)self;
    
    [self.mMapView removeAnnotations:[self.mMapView annotations]];
    
    CLLocationCoordinate2D coor;
    coor.latitude = [model.mHlat floatValue];
    coor.longitude = [model.mHlng floatValue];
    
    [self.mMapView setCenterCoordinate:coor];
    
    RouteAnnotation* item = [[RouteAnnotation alloc]init];
    item.coordinate = coor;
    item.type = 1;
    [self.mMapView addAnnotation:item]; // 添加起点标注
}
#pragma mark event response
- (IBAction)onclickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changMapOrListBtn:(id)sender {
    self.mMapView.hidden = !self.mMapView.hidden;
    self.mInfoTableView.hidden =  !self.mMapView.hidden;
    self.mMapFirendsView.hidden =  self.mMapView.hidden;
    
    if (self.mMapView.hidden) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"t_ad"] style:UIBarButtonItemStylePlain target:self action:@selector(changMapOrListBtn:)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"t_list"] style:UIBarButtonItemStylePlain target:self action:@selector(changMapOrListBtn:)];
    }
    
}
#pragma mark BMKAnnotationViewSearchDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}
#pragma mark UITableViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView registerNib:[UINib nibWithNibName:@"ZJBoarderListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ZJBoarderListCell"];
    ZJBoarderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZJBoarderListCell"];
    [cell loadDataWithModel:self.mDataSoure[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZJBDetailVC *tempVC = [[ZJBDetailVC alloc]init];
    tempVC.mSelectHotelModel = self.mDataSoure[indexPath.row];
    [self.navigationController pushViewController:tempVC animated:YES];
}

#pragma mark UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mDataSoure.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 150);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * SLCellIdentifier = @"ZJBoardMapCell";
    
    [collectionView registerNib:[UINib nibWithNibName:@"ZJBoardMapCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"ZJBoardMapCell"];
    
    ZJBoardMapCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SLCellIdentifier forIndexPath:indexPath];
    
    [cell loadDataWithModel:self.mDataSoure[indexPath.row]];
    
    //    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = (int)(scrollView.contentOffset.x/scrollView.frame.size.width + 0.5)%5;
    LDLOG(@"%d",page);
    [self setMapAnnotation:self.mDataSoure[page]];
}
#pragma mark UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJBDetailVC *tempVC = [[ZJBDetailVC alloc]init];
    tempVC.mSelectHotelModel = self.mDataSoure[indexPath.row];
    [self.navigationController pushViewController:tempVC animated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
