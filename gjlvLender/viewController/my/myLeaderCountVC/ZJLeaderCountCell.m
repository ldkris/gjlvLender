//
//  ZJLeaderCountCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/9.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJLeaderCountCell.h"

@implementation ZJLeaderCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self loadMarkbtns:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataWithModel:(ZJUserInfoModel *)model{
    if (model == nil) {
        return;
    }
    self.mlab_count.text = [[model.mSrvCount stringValue] stringByAppendingString:@"次"];
    
    [self.mimg_Head sd_setImageWithURL:[NSURL URLWithString:model.mHeadImgUrl] placeholderImage:[UIImage imageNamed:@"my_head_def.png"]];

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
        [self.contentView addSubview:markBtn];
        [markBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (oldMakr == nil) {
                make.left.equalTo(self.mimg_Head.mas_right).with.offset(8);
            }else{
                make.left.equalTo(oldMakr.mas_right).with.offset(5);
            }
            make.top.equalTo(self.mlab_count.mas_bottom).with.offset(8);
            make.height.width.mas_equalTo(15);
        }];
        oldMakr = markBtn;
    }
}
@end
