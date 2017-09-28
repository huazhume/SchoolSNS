//
// Created by FlyingPuPu on 27/04/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "HSGHTools.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CoreText/CoreText.h>
#import <objc/runtime.h>
#import "NSAttributedString+YYText.h"
#import "YYText.h"
#import "HSGHMediaFileManager.h"

@implementation HSGHTools {
}

static unsigned char kPNGSignatureBytes[8] = { 0x89, 0x50, 0x4E, 0x47,
    0x0D, 0x0A, 0x1A, 0x0A };
static NSData* kPNGSignatureData = nil;

+ (BOOL)ImageDataHasPNGPrefix:(NSData*)data
{
    if (!kPNGSignatureData) {
        kPNGSignatureData = [NSData dataWithBytes:kPNGSignatureBytes length:8];
    }
    NSUInteger pngSignatureLength = [kPNGSignatureData length];
    if ([data length] >= pngSignatureLength) {
        if ([[data subdataWithRange:NSMakeRange(0, pngSignatureLength)]
                isEqualToData:kPNGSignatureData]) {
            return YES;
        }
    }
    return NO;
}

// check email by regex
+ (BOOL)isValidateEmail:(NSString*)email
{
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* emailTest =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 判断是否为正确的登录密码
// 0：正确 1：只有字母 2：只有数字 3长度不对
const static NSInteger kLKPwdMaxLength = 32;
const static NSInteger kLKPwdMinLength = 6;

+ (BOOL)isValidatePassword:(NSString*)password
{
    if (password.length < kLKPwdMinLength || password.length > kLKPwdMaxLength) {
        return 3;
    }
    //    NSPredicate *predicateN =[NSPredicate predicateWithFormat:@"SELF MATCHES
    //    %@",@"([0-9]*)"];
    //    if ([predicateN evaluateWithObject:password]) {
    //        return 2;
    //    }
    //    NSPredicate *predicateZM =[NSPredicate predicateWithFormat:@"SELF
    //    MATCHES %@",@"([a-zA-Z]*)"];
    //    if ([predicateZM evaluateWithObject:password]) {
    //        return 1;
    //    }

    NSPredicate* predicateN =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"([0-9a-zA-Z-/:;()$&@\".,?!]*)"];
    return [predicateN evaluateWithObject:password];
}

+ (BOOL)isValidateNickName:(NSString*)name {
    if ((name.length < 8) || (name.length) > 20) {
        return false;
    }
    
    NSPredicate* predicateN =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(.*[a-z])(.*[0-9])?$"];
    return [predicateN evaluateWithObject:name];
}


+ (BOOL)isValidatedPhone: (NSString*)phone phoneCode:(NSString*)phoneCode {
    if ([phoneCode isEqualToString:@"86"] || [phoneCode isEqualToString:@"+86"]) {
        return [[self class] isValidateCNPhoneNumber: phone];
    }
    else {
        return [[self class] isValidateAboradPhoneNumber: phone];
    }
}


+ (BOOL)isValidateAboradPhoneNumber:(NSString*)phoneNumber {
    if (phoneNumber.length < 6 && phoneNumber.length > 18) {
        return false;
    }
    
    NSString* MOBILE = @"^[+0-9]*$";
    NSPredicate* regextestmobile =
    [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestmobile evaluateWithObject:phoneNumber] == YES) {
        return YES;
    } else {
        return NO;
    }
}

// check phone number
+ (BOOL)isValidateCNPhoneNumber:(NSString*)phoneNumber
{
    /**
   * 手机号码
   * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
   * 联通：130,131,132,152,155,156,185,186
   * 电信：133,1349,153,180,189
   */
    NSString* MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|4[0-9])\\d{8}$";
    /**
   10         * 中国移动：China Mobile
   11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,187,188
   12         */
    NSString* CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
   15         * 中国联通：China Unicom
   16         * 130,131,132,152,155,156,185,186
   17         */
    NSString* CU = @"^1(3[0-2]|5[256]|8[56]|7[0-9])\\d{8}$";
    /**
   20         * 中国电信：China Telecom
   21         * 133,1349,153,180,189,181
   22         */
    NSString* CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
   25         * 大陆地区固话及小灵通
   26         * 区号：010,020,021,022,023,024,025,027,028,029
   27         * 号码：七位或八位
   28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate* regextestmobile =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate* regextestcm =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate* regextestcu =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate* regextestct =
        [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if (([regextestmobile evaluateWithObject:phoneNumber] == YES) || ([regextestcm evaluateWithObject:phoneNumber] == YES) || ([regextestct evaluateWithObject:phoneNumber] == YES) || ([regextestcu evaluateWithObject:phoneNumber] == YES)) {
        return YES;
    } else {
        return NO;
    }
}


+ (BOOL)isValidateVerityCode:(NSString*)code {
    return code.length == 6;
}


// 判断是否是url
+ (NSURL*)smartURLForString:(NSString*)str
{
    NSURL* result;
    NSString* trimmedStr;
    NSRange schemeMarkerRange;
    NSString* scheme;

    assert(str != nil);

    result = nil;

    trimmedStr = [str
        stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ((trimmedStr != nil) && (trimmedStr.length != 0)) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];

        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL
                URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr
                substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);

            if (([scheme compare:@"http" options:NSCaseInsensitiveSearch] == NSOrderedSame) || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame)) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }

    return result;
}

+ (NSString*)getmd5WithString:(NSString*)string
{
    const char* original_str = [string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; // CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outPutStr
            appendFormat:
                @"%02x",
            digist[i]]; //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}

+ (NSString*)getMD5WithData:(NSData*)data
{
    const char* original_str = (const char*)[data bytes];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; // CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [outPutStr
            appendFormat:
                @"%02x",
            digist[i]]; //小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }

    //也可以定义一个字节数组来接收计算得到的MD5值
    //    Byte byte[16];
    //    CC_MD5(original_str, strlen(original_str), byte);
    //    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    //    for(int  i = 0; i<CC_MD5_DIGEST_LENGTH;i++){
    //        [outPutStr appendFormat:@"%02x",byte[i]];
    //    }
    //    [temp release];

    return [outPutStr lowercaseString];
}

#define CC_MD5_DIGEST_LENGTH 16
#define FileHashDefaultChunkSizeForReadingData 1024 * 8

+ (NSString*)getFileMD5WithPath:(NSString*)path
{
    return (__bridge_transfer NSString*)FileMD5HashCreateWithPath(
        (__bridge CFStringRef)path, FileHashDefaultChunkSizeForReadingData);
}

CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
    size_t chunkSizeForReadingData)
{

    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;

    // Get the file URL
    CFURLRef fileURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath,
        kCFURLPOSIXPathStyle, (Boolean) false);

    CC_MD5_CTX hashObject;
    bool hasMoreData = true;
    bool didSucceed;

    if (!fileURL)
        goto done;

    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, (CFURLRef)fileURL);
    if (!readStream)
        goto done;
    didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed)
        goto done;

    // Initialize the hash object
    CC_MD5_Init(&hashObject);

    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }

    // Feed the data to the hash object
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream, (UInt8*)buffer, (CFIndex)sizeof(buffer));
        if (readBytesCount == -1)
            break;
        if (readBytesCount == 0) {
            hasMoreData = false;
            continue;
        }
        CC_MD5_Update(&hashObject, (const void*)buffer, (CC_LONG)readBytesCount);
    }

    // Check if the read operation succeeded
    didSucceed = !hasMoreData;

    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);

    // Abort if the read operation failed
    if (!didSucceed)
        goto done;

    // Compute the string result
    char hash[2 * sizeof(digest) + 1];
    for (size_t i = 0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault, (const char*)hash,
        kCFStringEncodingUTF8);

done:

    if (readStream) {
        CFReadStreamClose(readStream);
        CFRelease(readStream);
    }
    if (fileURL) {
        CFRelease(fileURL);
    }
    return result;
}

+ (NSString*)dictionaryToJson:(NSDictionary*)dic
{
    NSError* parseError = nil;
    NSData* jsonData =
        [NSJSONSerialization dataWithJSONObject:dic
                                        options:NSJSONWritingPrettyPrinted
                                          error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString*)converTimeStamp:(NSUInteger)timeInt
{
    NSTimeInterval time = timeInt / 1000; //+ 28800;//因为时差问题要加8小时 == 28800 sec
    NSDate* detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    HSLog(@"date:%@", [detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    return [dateFormatter stringFromDate:detaildate];
}

+ (UIImage*)OriginImage:(UIImage*)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size); // size 为CGSize类型，即你所需要的图片尺寸

    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];

    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return scaledImage;
}

+ (UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    NSURL* fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString* fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont* font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

+ (UIFont*)currentFont:(CGFloat)size
{
    NSString* path =
        [[NSBundle mainBundle] pathForResource:@"SourceHanSerifSC-Regular"
                                        ofType:@"otf"];
    return [self customFontWithPath:path size:size];
}

+ (BOOL)isBoldFont:(UIFont*)font
{
    UIFontDescriptor* fontDescriptor = font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    return !!(fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold);
}

+ (void)setLineSpaceWithString:(UILabel*)label space:(CGFloat)space
{
    NSMutableAttributedString* attributedString =
        [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle* paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    //调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [label.text length])];
    label.attributedText = attributedString;
}

//- (CGFloat)getSpaceLabelHeight:(NSString*)str
//                      withFont:(UIFont*)font
//                     withWidth:(CGFloat)width
//{
//    NSMutableParagraphStyle* paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paraStyle.alignment = NSTextAlignmentLeft;
//    paraStyle.lineSpacing = UILABEL_LINE_SPACE;
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
//    NSDictionary* dic =
//    @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : paraStyle };
//    CGSize size = [str boundingRectWithSize:CGSizeMake(width - 16, MAXFLOAT)
//                                    options:NSStringDrawingUsesLineFragmentOrigin
//                                 attributes:dic
//                                    context:nil]
//    .size;
//    return size.height + 16;
//}

// Not backup to iCloud
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:[URL path]]);

    NSError* error = nil;
    BOOL success = [URL setResourceValue:@(YES)
                                  forKey:NSURLIsExcludedFromBackupKey
                                   error:&error];
    if (!success) {
        HSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (CGFloat)screenScale
{
    static CGFloat _scale = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scale = [UIScreen mainScreen].scale;
    });

    return _scale;
}

+ (CALayer*)lineWithLength:(CGFloat)length atPoint:(CGPoint)point
{
    CALayer* line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithRed:221 / 255.f
                                           green:221 / 255.f
                                            blue:221 / 255.f
                                           alpha:1.f]
                               .CGColor;

    line.frame = CGRectMake(point.x, point.y, length, 1 / [self screenScale]);

    return line;
}

+ (UIImage*)blurWithOriginalImage:(UIImage*)image
                         blurName:(NSString*)name
                           radius:(NSInteger)radius
{
    CIContext* context = [CIContext contextWithOptions:nil];
    CIImage* inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter* filter;
    if (name.length != 0) {
        filter = [CIFilter filterWithName:name];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        if (![name isEqualToString:@"CIMedianFilter"]) {
            [filter setValue:@(radius) forKey:@"inputRadius"];
        }
        CIImage* result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage =
            [context createCGImage:result
                          fromRect:[result extent]];
        UIImage* resultImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return resultImage;
    } else {
        return nil;
    }
}

+ (NSDictionary*)convertObjectToDic:(id)obj
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    unsigned int propsCount;
    objc_property_t* props = class_copyPropertyList([obj class], &propsCount); //获得属性列表
    for (int i = 0; i < propsCount; i++) {
        objc_property_t prop = props[i];

        NSString* propName =
            [NSString stringWithUTF8String:property_getName(prop)]; //获得属性的名称
        id value = [obj valueForKey:propName]; // kvc读值
        if (value == nil) {
            value = [NSNull null];
        } else {
            value = [self getObjectInternal:value]; //自定义处理数组，字典，其他类
        }
        [dic setObject:value forKey:propName];
    }
    return dic;
}

+ (id)getObjectInternal:(id)obj
{
    if ([obj isKindOfClass:[NSString class]] ||
        [obj isKindOfClass:[NSNumber class]] ||
        [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }

    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray* objarr = obj;
        NSMutableArray* arr = [NSMutableArray arrayWithCapacity:objarr.count];
        for (int i = 0; i < objarr.count; i++) {
            [arr setObject:[self getObjectInternal:[objarr objectAtIndex:i]]
                atIndexedSubscript:i];
        }
        return arr;
    }

    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary* objdic = obj;
        NSMutableDictionary* dic =
            [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        for (NSString* key in objdic.allKeys) {
            [dic setObject:[self getObjectInternal:[objdic objectForKey:key]]
                    forKey:key];
        }
        return dic;
    }
    return [self convertObjectToDic:obj];
}

//计算label宽度
+ (CGFloat)widthOfString:(NSString*)string
                    font:(UIFont*)font
                  height:(CGFloat)height
{
    NSDictionary* dict =
        [NSDictionary dictionaryWithObject:font
                                    forKey:NSFontAttributeName];
    CGRect rect =
        [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                          attributes:dict
                             context:nil];
    return rect.size.width;
}

+ (CGFloat)widthOfLab:(UILabel *)lab
{
    NSDictionary* dict =
    [NSDictionary dictionaryWithObject:lab.font
                                forKey:NSFontAttributeName];
    CGRect rect =
    [lab.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, lab.frame.size.height)
                         options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                      attributes:dict
                         context:nil];
    return rect.size.width + 2;
}







+ (CGSize)getWidthWidthString:(NSString*)text font:(UIFont*)font width:(CGFloat)width
{
    CGSize contentSize = [text
             sizeWithFont:font
        constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
            lineBreakMode:NSLineBreakByWordWrapping];
    return contentSize;
}


+ (CGFloat)getTextViewHeightString:(NSString*)text font:(UIFont*)font width:(CGFloat)width
{
    CGSize contentSize = [text
                          sizeWithFont:font
                          constrainedToSize:CGSizeMake(width - 16, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    return contentSize.height + 16;
}




//+ (CGFloat)widthOfLabel:(UILabel *)string
//                    font:(UIFont *)font
//                  height:(CGFloat)height {
//  NSDictionary *dict =
//  [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
//  CGRect rect =
//  [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
//                       options:NSStringDrawingTruncatesLastVisibleLine |
//   NSStringDrawingUsesFontLeading |
//   NSStringDrawingUsesLineFragmentOrigin
//                    attributes:dict
//                       context:nil];
//  return rect.size.width;
//}

+ (UIImage*)fixOrientation:(UIImage*)aImage
{

    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;

    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (aImage.imageOrientation) {
    case UIImageOrientationDown:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
        break;

    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
        transform = CGAffineTransformRotate(transform, M_PI_2);
        break;

    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
        break;
    default:
        break;
    }

    switch (aImage.imageOrientation) {
    case UIImageOrientationUpMirrored:
    case UIImageOrientationDownMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;

    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRightMirrored:
        transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
        transform = CGAffineTransformScale(transform, -1, 1);
        break;
    default:
        break;
    }

    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
        CGImageGetBitsPerComponent(aImage.CGImage), 0,
        CGImageGetColorSpace(aImage.CGImage),
        CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
    case UIImageOrientationLeft:
    case UIImageOrientationLeftMirrored:
    case UIImageOrientationRight:
    case UIImageOrientationRightMirrored:
        // Grr...
        CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
        break;

    default:
        CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
        break;
    }

    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage* img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (NSString*)dateFormatter:(NSString*)dateString timeZong:(NSString*)utc
{
    NSDateFormatter* fommatter = [[NSDateFormatter alloc] init];
    [fommatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate* anyDate = [fommatter dateFromString:dateString];
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"]; //或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];

    NSDateFormatter* fommatterUtc = [[NSDateFormatter alloc] init];
    [fommatterUtc setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [fommatterUtc stringFromDate:destinationDateNow];
}

//将本地日期字符串转为UTC日期字符串
//本地日期格式:2013-08-03 12:53:51
//可自行指定输入输出格式
+ (NSString*)getUTCFormateLocalDate:(NSString*)localDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString* dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

+ (NSString*)getUTCFormateLocalDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* dateFormatted = [NSDate date];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString* dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
+ (NSString*)getLocalDateFormateUTCDate:(NSString*)utcDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate* dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    return [self nowTimeStringWithDate:dateFormatted];
}
+ (NSString*)getUTCDateString:(NSString*)utcDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate* dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter2 stringFromDate:dateFormatted];
}
+ (NSString*)getDateString:(NSString*)utcDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate* dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [self nowTimeWithDate:dateFormatted];
}



+ (NSUInteger)calcLabelRows:(UILabel*)label text:(NSString*)text
{
    if (!text) {
        return 0;
    }
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:text];
    attString.yy_font = label.font;

    YYTextContainer* container = [YYTextContainer new];
    container.size = CGSizeMake(label.width, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    YYTextLayout* textLayout = [YYTextLayout layoutWithContainer:container text:attString];
    return textLayout.rowCount;
}

+ (CGFloat)calcLabelHeight:(UILabel*)label text:(NSString*)text
{
    if (!text) {
        return 0;
    }
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:text];
    attString.yy_font = label.font;

    YYTextContainer* container = [YYTextContainer new];
    container.size = CGSizeMake(label.width, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    YYTextLayout* textLayout = [YYTextLayout layoutWithContainer:container text:attString];
    return textLayout.textBoundingSize.height;
}

// 时间转化
+ (NSString*)nowTimeStringWithDate:(NSDate*)timeDate
{
    //    NSString *createdTimeStr = @"2017-01-01 21:05:10";
    //    //把字符串转为NSdate
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSDate *timeDate = [dateFormatter dateFromString:createdTimeStr];
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = - timeInterval - 8 * 3600;
    long temp = 0;
    NSString* result;
    if (timeInterval < 10) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"%d秒前", (int)timeInterval];
    } else if ((temp = timeInterval / 60) < 30) {
        result = [NSString stringWithFormat:@"%ld分钟前", temp];
    } else if ((temp = timeInterval / 60 / 30) >= 1 && ((temp = timeInterval / 60 / 30) < 2)) {
        result = [NSString stringWithFormat:@"半小时前"];
    } else if ((temp = timeInterval / 3600) >= 1 && (temp = timeInterval / 3600) < 24) {
        result = [NSString stringWithFormat:@"%ld小时前", temp];
    } else if ((temp = timeInterval / 3600) >= 24 && (temp = timeInterval / 3600) < 48) {
        result = [NSString stringWithFormat:@"1天前"];
    }else if ((temp = timeInterval/3600) >= 48 && (temp = timeInterval/3600) < 72){
        result = [NSString stringWithFormat:@"2天前"];
    }
    else if ((temp = timeInterval/3600/24) >= 3 && (temp = timeInterval/3600/24) < 30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if ((temp = timeInterval/3600/24/30) >= 1 && (temp = timeInterval/3600/24/30) < 12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else if ((temp = timeInterval/3600/24/30/12) >= 1 && (temp = timeInterval/3600/24/30/12) < 2){
        result = [NSString stringWithFormat:@"一年前"];
    }
    else{
        result = [dateFormatter stringFromDate:timeDate];
    }
    return result;
}
+ (NSString*)nowTimeWithDate:(NSDate*)timeDate
{
    //    NSString *createdTimeStr = @"2017-01-01 21:05:10";
    //    //把字符串转为NSdate
    NSTimeInterval timeInterval = [timeDate timeIntervalSince1970];
    timeInterval = timeInterval + 8 * 3600;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSDate *timeDate = [dateFormatter dateFromString:createdTimeStr];
 
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}


+ (void)writeNSDataToFile:(NSData*)data name:(NSString*)name {
    HSGHMediaFileManager * manager = [HSGHMediaFileManager sharedManager];
    NSString* path =  [[manager getMediaFilePathWithAndSanBoxType:SANBOX_DOCUMNET_TYPE
                                   AndMediaType:FILE_IMAGE_TYPE] stringByAppendingPathComponent:name];
    [data writeToFile:path atomically:YES];
}

@end
