//
//  ZJCommDeatlCell.m
//  gjlvLender
//
//  Created by 刘冬 on 2016/12/26.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJCommDeatlCell.h"

@implementation ZJCommDeatlCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  //  [self loadMarkbtns:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadMarkbtns:(int)count{
    UIButton *oldMakr;
    for (int i = 1; i<=5; i++) {
        UIButton *markBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        if (i<=count) {
            [markBtn setImage:[[UIImage imageNamed:@"a_smark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }else{
            [markBtn setImage:[[UIImage imageNamed:@"a_kmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        }
        [markBtn setTag:i];
        [self.mContentView addSubview:markBtn];
        [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (oldMakr == nil) {
                make.left.equalTo(self.mContentView.mas_left).with.offset(0);
            }else{
                make.left.equalTo(oldMakr.mas_right).with.offset(5);
            }
            make.top.equalTo(self.mContentView.mas_top).with.offset(0);
            make.height.width.mas_equalTo(40);
        }];
        oldMakr = markBtn;
    }
}
@end
