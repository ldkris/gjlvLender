//
//  ZJTabBarVC.h
//  gjlv
//
//  Created by 刘冬 on 2016/10/31.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJTabBarVC : UITabBarController
@property(nonatomic,retain)UIView *mBarView;
-(void)selectVCWithIndex:(NSInteger)index;
@end
