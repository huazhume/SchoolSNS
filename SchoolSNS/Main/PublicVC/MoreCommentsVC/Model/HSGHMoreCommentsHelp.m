//
//  HSGHMoreCommentsHelp.m
//  SchoolSNS
//
//  Created by Murloc on 14/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "HSGHMoreCommentsHelp.h"
#import "NSAttributedString+YYText.h"
#import "YYTextLayout.h"


@implementation HSGHMoreCommentsHelp
//带发送人的评论回复
+ (NSAttributedString *)generateAttrStringWithFrom:(HSGHHomeReplay *)model {
    NSString *text = @"";
    NSRange range;
    NSString *fromName = UN_NIL_STR(model.fromUser.displayName);
    
    if (model.toUser.displayName.length) {
        if (fromName.length > 0) {
            text = [text stringByAppendingString:[NSString stringWithFormat:@"%@", fromName]];
        }
        
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.toUser.displayName]];
        text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.content]];
    } else {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@", model.content]];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    attString.yy_color = HEXRGBCOLOR(0x272727);
    attString.yy_font = [UIFont systemFontOfSize:14];
    
    if (model.toUser.displayName) {
        if (fromName.length > 0) {
            range = NSMakeRange(0, fromName.length);
            [attString yy_setFont:[UIFont boldSystemFontOfSize:14] range:range];
        }
        
        range = NSMakeRange(fromName.length + 2, model.toUser.displayName.length);
        [attString yy_setFont:[UIFont boldSystemFontOfSize:14] range:range];
    }
    
    attString.yy_lineSpacing = 2;
    return attString.copy;
}




+ (NSAttributedString *)generateAttrString:(HSGHHomeReplay *)model {
    NSString *text = @"";
    NSRange range;
    if (model.toUser.displayName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.toUser.displayName]];
        text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.content]];
    } else {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@", model.content]];
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    attString.yy_color = HEXRGBCOLOR(0x272727);
    attString.yy_font = [UIFont systemFontOfSize:14];
    if (model.toUser.displayName) {
        range = NSMakeRange(2, model.toUser.displayName.length);
        [attString yy_setFont:[UIFont boldSystemFontOfSize:14] range:range];
    }
    
    attString.yy_lineSpacing = 2;
    return attString.copy;
}


+ (CGFloat)calcHeight:(NSAttributedString*)str width:(CGFloat)width limitLines:(NSUInteger)limitLines {
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.maximumNumberOfRows = limitLines;
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:str];
    return textLayout.textBoundingSize.height;
}

+ (HSGHMoreCommentsLayoutModel*)convertToLayoutModel:(HSGHHomeReplay *)model {
    HSGHMoreCommentsLayoutModel* layout = [HSGHMoreCommentsLayoutModel new];
    layout.cellReplay = model;
    layout.layout = [[layout class] calcLayout:true data:layout];
    return layout;
}


@end
