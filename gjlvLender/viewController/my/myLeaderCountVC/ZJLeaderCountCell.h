//
//  ZJLeaderCountCell.h
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJLeaderCountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mlab_count;
@property (weak, nonatomic) IBOutlet UIImageView *mimg_Head;

-(void)loadDataWithModel:(ZJUserInfoModel *)model;
@end
