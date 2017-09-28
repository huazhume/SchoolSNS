//
//  HSGHHomeMainCellContentView.m
//  SchoolSNS
//
//  Created by Huaral on 2017/5/8.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "HSGHFirstContentView.h"
#import "HSGHCommentsCallFriendViewModel.h"
#import "HSGHImageAvatarBrowser.h"
#import "HSGHNetworkSession.h"
#import "HSGHTools.h"
#import "HSGHTopLeftLabel.h"
#import "HZImagesGroupView.h"
#import "HZPhotoBrowser.h"
#import "HZPhotoItemModel.h"
#import "NSAttributedString+YYText.h"
#import <CoreText/CoreText.h>

#define UILABEL_LINE_SPACE 2
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface HSGHFirstContentView () <HZPhotoBrowserDelegate,
                                    UITextViewDelegate> {
  UILabel *_label;
}
@property(nonatomic, strong) NSArray *photoItemArray;
@property(nonatomic, strong) HSGHHomeQQianModel *qqianVo;

@end

@implementation HSGHFirstContentView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  [[NSBundle mainBundle] loadNibNamed:@"HSGHFirstContentView"
                                owner:self
                              options:nil];
  self.view.frame =
      CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
  [self addSubview:self.view];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.textLabel.contentInset = UIEdgeInsetsMake(-10, -5, -15, -5);

  _yylabel = [YYLabel new];
//  _yylabel.userInteractionEnabled = YES;
  _yylabel.textColor = HEXRGBCOLOR(0x272727);
  _yylabel.numberOfLines = 0;
  _yylabel.textAlignment = NSTextAlignmentLeft;
  _yylabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
  [self.yylabelBg addSubview:_yylabel];
    self.yylabelBg.userInteractionEnabled = YES;

  //    [self addSubview:_yylabel];
  [_yylabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(_yylabelBg);
    make.top.mas_equalTo(_yylabelBg);
    make.bottom.mas_equalTo(_yylabelBg);
    make.right.mas_equalTo(_yylabelBg);
  }];
  [self addSeeMoreButton];
  _yylabel.textParser = [YYTextMatchBindingParser new];
  [self.indicatorView hidesWhenStopped];
    
}

- (void)addSeeMoreButton {
    NSMutableAttributedString *text =
    [[NSMutableAttributedString alloc] initWithString:@"...查看更多"];
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:HEXRGBCOLOR(0xa5a5a5)];
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text,
                     NSRange range, CGRect rect) {
        HSLog(@"-------查看更多-------");
        if (_block) {
            self.block();
        }
        //        [_textLab sizeToFit];
    };
    [text yy_setFont:[UIFont systemFontOfSize:12]
               range:[text.string rangeOfString:@"查看更多"]];
    [text yy_setColor:HEXRGBCOLOR(0xa5a5a5)
                range:[text.string rangeOfString:@"查看更多"]];
    [text yy_setTextHighlight:hi range:[text.string rangeOfString:@"查看更多"]];
  
    YYLabel *seeMore = [YYLabel new];
  seeMore.attributedText = text;
  [seeMore sizeToFit];
  NSAttributedString *truncationToken = [NSAttributedString
      yy_attachmentStringWithContent:seeMore
                         contentMode:UIViewContentModeBottomRight
                      attachmentSize:seeMore.size
                         alignToFont:[UIFont systemFontOfSize:11]
                           alignment:YYTextVerticalAlignmentBottom];
  _yylabel.truncationToken = truncationToken;
}

//给UILabel设置行间距和字间距
- (void)setLabelSpace:(UITextView *)label
            withValue:(NSString *)str
             withFont:(UIFont *)font {
  NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
  paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
  paraStyle.alignment = NSTextAlignmentLeft;
  paraStyle.lineSpacing = UILABEL_LINE_SPACE; //设置行间距
  paraStyle.hyphenationFactor = 1.0;
  paraStyle.firstLineHeadIndent = 0.0;
  paraStyle.paragraphSpacingBefore = 0.0;
  paraStyle.headIndent = 0;
  paraStyle.tailIndent = 0;
  NSDictionary *dic =
      @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paraStyle};
  NSAttributedString *attributeStr =
      [[NSAttributedString alloc] initWithString:str attributes:dic];
  label.attributedText = attributeStr;
}

- (void)setModelFrame:(HSGHHomeQQianModelFrame *)modelF {
  _Cframe = modelF;
  _qqianVo = modelF.model;
  if ([modelF.model.contentIsMore integerValue] == 1) {
    self.textHeight.constant = modelF.contentTextMaxH;
    [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
    self.textLabel.scrollEnabled = YES;
  } else {
    [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    self.textHeight.constant = modelF.contentTextH;
    self.textLabel.scrollEnabled = NO;
  }

  if (modelF.contentTextMaxH == modelF.contentTextH) {
    self.textLabel.scrollEnabled = NO;
  }
  self.moreHeight.constant = modelF.contentMoreH;
  self.imageHeight.constant = modelF.contentImageH;
    if (modelF.contentImageH) {
        self.imageWidth.constant = modelF.contentImageH * _qqianVo.image.srcWidth.floatValue / _qqianVo.image.srcHeight.floatValue;
    }
    
  self.textTopToImage.constant = modelF.contentTextToImage;
  //设置值
  if (modelF.model.content != nil) {
    self.yylabel.attributedText =
        [self generateAttributedStringWithString:modelF.model.content];
  }

  if ([modelF.model.image.srcUrl isEqualToString:@""] ||
      modelF.model.image.srcUrl == nil) {
    self.indicatorView.hidden = YES;
  } else {
    self.indicatorView.hidden = NO;
  }
  self.image.userInteractionEnabled = NO;
  
    if (modelF.model.mediaType != 2) {
      if (modelF.model.image.srcUrl &&
          [modelF.model.image.srcUrl hasPrefix:@"http"]) {
        [self.indicatorView startAnimating];
        __weak typeof(self) weakSelf = self;
        [self.image
            sd_setImageWithURL:[NSURL URLWithString:modelF.model.image.srcUrl]
              placeholderImage:nil
                       options:SDWebImageAllowInvalidSSLCertificates
                     completed:^(UIImage *image, NSError *error,
                                 SDImageCacheType cacheType, NSURL *imageURL) {

                       if (image) {
                         [self.indicatorView stopAnimating];
                         self.indicatorView.hidden = YES;
                         [weakSelf.image setImage:image];
                         self.image.userInteractionEnabled = YES;
                       }
                     }];
      } else {
        [self.indicatorView stopAnimating];
         self.indicatorView.hidden = YES;
        [self.image setImage:[UIImage imageNamed:modelF.model.image.srcUrl]];
      }
    }

  if (modelF.contentMoreH == 0) {
    self.moreBtn.hidden = YES;
  } else {
    self.moreBtn.hidden = NO;
  }

  [self.image setContentScaleFactor:[[UIScreen mainScreen] scale]];
  self.image.contentMode = UIViewContentModeScaleAspectFill;
  self.image.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  self.image.clipsToBounds = YES;
  if(modelF.contentTextMaxH > modelF.contentTextH){
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(moreBtnClicked:)];
        [self.yylabel addGestureRecognizer:gesture];
  }
  self.yylabel.userInteractionEnabled = YES;
    
    //文字双击点赞
    if(modelF.contentTextH > 0){
        UITapGestureRecognizer *doubleTapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(doubleTap:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [self.yylabel addGestureRecognizer:doubleTapGestureRecognizer];
    }

  UITapGestureRecognizer *doubleTapGestureRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(doubleTap:)];
  [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
  [self.image addGestureRecognizer:doubleTapGestureRecognizer];//图片双击点赞

    
    //Add video
#ifdef OPEN_VIDEO
    if (modelF.model.mediaType == 2 && UN_NIL_STR(modelF.model.image.srcUrl).length > 0) {
        //self.image.videoPlayURL = [NSURL URLWithString:modelF.model.image.srcUrl];
        self.indicatorView.hidden = YES;
        self.image.userInteractionEnabled = YES;
        if (modelF.model.image.thumbUrl &&
            [modelF.model.image.thumbUrl hasPrefix:@"http"]) {
            __weak typeof(self) weakSelf = self;
            [self.image
             sd_setImageWithURL:[NSURL URLWithString:modelF.model.image.thumbUrl]
             placeholderImage:nil
             options:SDWebImageAllowInvalidSSLCertificates
             completed:^(UIImage *image, NSError *error,
                         SDImageCacheType cacheType, NSURL *imageURL) {
                 
                 if (image) {
                     [weakSelf.image setImage:image];
                     self.image.userInteractionEnabled = YES;
                 }
             }];
        } else {
            [self.image setImage:[UIImage imageNamed:modelF.model.image.thumbUrl]];
        }
    }
    else {
        //self.image.videoPlayURL = nil;
    }
#endif
}

- (void)doubleTap:(UIGestureRecognizer *)gestureRecognizer {
    //双击图片 点赞或取消点赞 逻辑 同toolView点赞按钮
    if (_dcimgBlock) {
        self.dcimgBlock();
    }
    
//  if ([_qqianVo.up integerValue] == 0) {
//      NSLog(@"点赞效果");
//    //点赞
//    [HSGHNetworkSession postReq:HSGHHomeQQiansUPURL
//        appendParams:@{
//          @"qqianId" : _qqianVo.qqianId,
//        }
//        returnClass:[self class]
//        block:^(id obj, NetResStatus status, NSString *errorDes) {
//          if (status == 0) {
//            //点赞成功
//          } else {
//            NSLog(@"点赞失败啦");
//          }
//        }];
//    [self praiseAnimationWith:gestureRecognizer.view];
//  } else {
//
//   [HSGHNetworkSession postReq:HSGHUpCancel
//        appendParams:@{
//          @"qqianId" : _qqianVo.qqianId,
//        }
//        returnClass:[self class]
//        block:^(id obj, NetResStatus status, NSString *errorDes) {
//
//          if (status == 0) {
//
//          } else {
//            NSLog(@"取消点赞失败啦");
//          }
//        }];
//    self.upBlock(2000);
//  }
}

- (void)praiseAnimationWith:(UIView *)view {
  UIImageView *imageView = [[UIImageView alloc] init];
  imageView.image = [UIImage imageNamed:@"dianzan"];
  imageView.alpha = 0;
  imageView.frame = CGRectMake(self.image.frame.size.width / 2.0,
                               self.image.frame.size.height / 2.0, 0, 0);
  [self.image addSubview:imageView];
  [UIView animateWithDuration:0.2
      animations:^{
        imageView.alpha = 1;
        imageView.frame =
            CGRectMake(self.image.frame.size.width / 2.0 - 50,
                       self.image.frame.size.height / 2 - 50, 100, 100);
        [self layoutIfNeeded];
      }
      completion:^(BOOL finished) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
              [UIView animateWithDuration:0.3
                  animations:^{
                    imageView.alpha = 0;
                    imageView.frame =
                        CGRectMake(self.image.frame.size.width / 2.0,
                                   self.image.frame.size.height / 2.0, 0, 0);
                  }
                  completion:^(BOOL finished) {
                    [imageView removeFromSuperview];
                    if (_upBlock) {
                      self.upBlock(1000);
                    }
                  }];
            });
      }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
}

- (IBAction)moreBtnClicked:(id)sender {
  if ([_qqianVo.contentIsMore integerValue] == 0) {
    [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
  } else {
    [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
  }
  if (_block) {
    self.block();
  }
}

// YYlabel String
- (NSMutableAttributedString *)generateAttributedStringWithString:
    (NSString *)content {
  NSMutableAttributedString *attString =
      [[NSMutableAttributedString alloc] initWithString:content];
  attString.yy_color = HEXRGBCOLOR(0x272727);
  attString.yy_font = [UIFont systemFontOfSize:14];
  attString.yy_lineSpacing = UILABEL_LINE_SPACE;
  return attString;
}

#pragma mark - photobrowser代理方法

- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser
    placeholderImageForIndex:(NSInteger)index {
  return self.image.image;
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser
    highQualityImageURLForIndex:(NSInteger)index {
  NSString *urlStr = _Cframe.model.image.srcUrl;
  return [NSURL URLWithString:urlStr];
}

- (void)imageBrower {
  //启动图片浏览器
  HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
  browserVc.sourceImagesContainerView = self; // 原图的父控件
  browserVc.imageCount = 1;                   // 图片总数
  browserVc.currentImageIndex = 0;
  browserVc.delegate = self;
  [browserVc show];
}

- (NSArray *)getLinesArrayOfStringInLabel:(UITextView *)label {
  NSString *text = [label text];
  UIFont *font = [label font];
  CGRect rect = [label frame];

  CTFontRef myFont = CTFontCreateWithName((CFStringRef)([font fontName]),
                                          [font pointSize], NULL);
  NSMutableAttributedString *attStr =
      [[NSMutableAttributedString alloc] initWithString:text];
  [attStr addAttribute:(NSString *)kCTFontAttributeName
                 value:(__bridge id)myFont
                 range:NSMakeRange(0, attStr.length)];
  CFRelease(myFont);
  CTFramesetterRef frameSetter =
      CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attStr);
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, 100000));
  CTFrameRef frame =
      CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
  NSArray *lines = (NSArray *)CTFrameGetLines(frame);
  NSMutableArray *linesArray = [[NSMutableArray alloc] init];
  for (id line in lines) {
    CTLineRef lineRef = (__bridge CTLineRef)line;
    CFRange lineRange = CTLineGetStringRange(lineRef);
    NSRange range = NSMakeRange(lineRange.location, lineRange.length);
    NSString *lineString = [text substringWithRange:range];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr,
                                   lineRange, kCTKernAttributeName,
                                   (CFTypeRef)([NSNumber numberWithFloat:0.0]));
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr,
                                   lineRange, kCTKernAttributeName,
                                   (CFTypeRef)([NSNumber numberWithInt:0.0]));
    // NSLog(@"''''''''''''''''''%@",lineString);
    [linesArray addObject:lineString];
  }

  CGPathRelease(path);
  CFRelease(frame);
  CFRelease(frameSetter);
  return (NSArray *)linesArray;
}

@end
