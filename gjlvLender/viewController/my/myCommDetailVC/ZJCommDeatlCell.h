//
//  ZJCommDeatlCell.h
//  gjlvLender
//
//  Created by 刘冬 on 2016/12/26.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJCommDeatlCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mContentView;
-(void)loadMarkbtns:(int)count;
@end
