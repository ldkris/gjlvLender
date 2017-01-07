//
//  ZJRouteCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/1.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJRouteCell.h"
#import "RouteAnnotation.h"
@implementation ZJRouteCell{
    IBOutlet BMKMapView* _mapView;
     BMKRouteSearch* _routesearch;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.mBtn_status.layer setMasksToBounds:YES];
    [self.mBtn_status.layer setCornerRadius:5.0f];
    
    _routesearch = [[BMKRouteSearch alloc]init];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = @"重庆";
    start.cityName =  @"北京市";
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = @"丽江";
    end.cityName =  @"北京市";
    
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    
    BMKPlanNode *temp = [[BMKPlanNode alloc]init];
    //    temp.pt = CLLocationCoordinate2DMake(30.5762790000,104.0712160000) ;
    temp.name = @"泸州";
    temp.cityName =  @"北京市";
    
    BMKPlanNode *temp1 = [[BMKPlanNode alloc]init];
    temp1.name = @"六盘水";
    //    temp1.pt = CLLocationCoordinate2DMake(26.5990860000,104.0712160000) ;
    temp1.cityName =  @"北京市";
    
    BMKPlanNode *temp2 = [[BMKPlanNode alloc]init];
    temp2.name = @"昆明";
    temp2.cityName =  @"北京市";
    
    BMKPlanNode *temp3 = [[BMKPlanNode alloc]init];
    temp3.name = @"大理";
    temp3.cityName =  @"北京市";
    
    drivingRouteSearchOption.wayPointsArray = @[temp,temp1,temp2,temp3];//array;
    
    BOOL flag = [_routesearch drivingSearch:drivingRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"search success.");
    }
    else
    {
        NSLog(@"search failed!");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.8;
}


- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [(RouteAnnotation*)annotation getRouteAnnotationView:view];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.strokeColor = [RGBACOLOR(195, 84, 91, 1) colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}
- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"起点";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }
            //添加annotation节点
            //            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            //            item.coordinate = transitStep.entrace.location;
            //            item.title = transitStep.entraceInstruction;
            //            item.degree = transitStep.direction * 30;
            //            item.type = 4;
            //            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints =
        new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

-(void)cellSetMapDelagete{
    _routesearch = [[BMKRouteSearch alloc]init];
    _mapView.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = (id)self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    
}
-(void)unCellSetMapDelagete{
    _routesearch = [[BMKRouteSearch alloc]init];
    _mapView.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _routesearch.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)mapViewDelloc{
    if (_routesearch) {
        _routesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
-(void)dealloc{
    if (_routesearch) {
        _routesearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
@end
