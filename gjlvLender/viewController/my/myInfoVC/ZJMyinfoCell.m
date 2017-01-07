//
//  ZJMyinfoCell.m
//  gjlv
//
//  Created by 刘冬 on 2016/11/7.
//  Copyright © 2016年 刘冬. All rights reserved.
//

#import "ZJMyinfoCell.h"

@implementation ZJMyinfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataIndexpath:(NSIndexPath *)indexPath model:(ZJUserInfoModel *)model{
    if (model == nil) {
        return;
    }
    switch (indexPath.row) {
        case 1:
            self.mLab_subTitle.text = model.mName;
            break;
        case 2:
            self.mLab_subTitle.text = model.mNickName;
            break;
        case 3:
            self.mLab_subTitle.text = model.mMobile;
            break;
        case 4:
            if ([model.mSex integerValue] == 1) {
                self.mLab_subTitle.text = @"男";
            }else{
                self.mLab_subTitle.text = @"女";
            }
            break;
        case 5:
            self.mLab_subTitle.text = model.mCardId;
            break;
        case 6:
            self.mLab_subTitle.text = [[model.mWokring stringValue] stringByAppendingString:@"年"];
            break;
        case 7:
            self.mLab_subTitle.text = [[model.mMile stringValue]stringByAppendingString:@"公里"];;
            break;
        case 8:
            self.mLab_subTitle.text = model.mGoodArea;
            break;
        case 9:
            if (model.mRemarks) {
                
                NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.mRemarks dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                
                self.mLab_subTitle.attributedText = attrStr;
            }
            break;

        default:
              self.mLab_subTitle.text = @"";
            break;
    }
}
@end
