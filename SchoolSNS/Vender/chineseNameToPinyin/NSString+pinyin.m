//
//  NSString+pinyin.m
//  iOSProject
//
//

#import "NSString+pinyin.h"
#import "pinyin.h"

@implementation NSString (pinyin)

//****************************************************************************************************
//*  某些字作为姓氏时，读音比较特别，系统默认转换时有时不能转成正确的读音，以下列出的姓氏常见的多音字姓氏
//*  【如果有其他未列出且系统默认翻译不能匹配正确读音的多音字姓氏时，请补全。以下多音字在iOS7、iOS8、iOS9设备上均已测试】
//*
//*  繁：pó 姓氏时不读fán。汉末诗人繁钦。系统默认将该字翻译成fán
//*  区：ōu 姓氏时不读qū。前国足门将区楚良。系统翻译默认将该字翻译成qū
//*  仇：qiú 姓氏时不读chóu。明代画家仇英。系统翻译默认将该字翻译成chóu
//*  种：chóng 姓氏时不读zhǒng。原中国驻阿拉伯也门大使种汉九。系统翻译默认将该字翻译成zhǒng
//*  单：shàn 姓氏时不读dān。隋唐单雄信。系统翻译默认将该字翻译成dān
//*  解：xiè 姓氏时不读jiě。梁山好汉解珍、解宝。系统翻译默认将该字翻译成jiě
//*  查：zhā 姓氏时不读chá。著名武侠小说作家金庸本名查良镛。系统翻译默认将该字翻译成chá
//*  曾：zēng 姓氏时不读céng。宋代作家曾巩、清代名臣曾国藩，香港特首曾荫权。系统翻译默认将该字翻译成céng
//*  秘：bì 姓氏时不读mì。系统默认将该字翻译成mì
//*  乐：yuè 姓氏时不读lè。系统默认将该字翻译成lè
//*  重：chóng 姓氏时不读zhòng。系统默认将该字翻译成zhòng
//*  朴：piáo 韩国三大姓，李、金、朴，姓氏时不读pǔ。系统翻译默认将该字翻译成pǔ
//*  缪: miào 姓氏时不读móu。系统翻译默认将该字翻译成móu
//【系统翻译就是姓氏发音】冼: xiǎn 姓氏时不读shěng。系统翻译默认将该字翻译成xiǎn
//*  翟：zhái 姓氏时不读dí。系统翻译默认将该字翻译成dí
//*  折：shé  姓氏时不读zhē折腾或者zhé折叠。系统翻译默认将该字翻译成zhé
//*  黑：hè  姓氏时不读hēi。系统翻译默认将该字翻译成hēi
//*  盖：gě 姓氏时不读gài。系统翻译默认将该字翻译成gài
//*  沈：shěn 姓氏时不读chén。系统翻译默认将该字翻译成chén
//*  尉迟：yù chí 复姓。系统翻译默认将该字翻译成wèi chí
//*  万俟：mò qí  复姓。系统翻译默认将该字翻译成wàn qí
//*【谌，读音作chén。因南北方文化差异不同，用作姓氏时即读chén也可读shèn。考虑效率问题所以未录入，以系统翻译为准】
//****************************************************************************************************


#pragma mark - 明确列出转换平台翻译错误的多音字姓氏，并列出正确匹配项
/**
 *  所有的多音字匹配的拼音键值对，每个姓氏多音字对应一个数组，数组中第一个字为正确发音，第二个为错误发音，错误发音用来做字符串替换使用
 *  多音字姓氏使用系统默认转换时，如果转换错误，将使用该键值对匹配替换
 */
+ (NSDictionary*)getDicForAllPolyphoneSurnamePinYin;
{
    static NSDictionary* g_pAllPolyphoneSurnamePinYin = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^
                  {
                      g_pAllPolyphoneSurnamePinYin = [NSMutableDictionary dictionaryWithObjectsAndKeys
                                                      :@[@"po",@"fan"],@"繁"
                                                      ,@[@"he",@"hei"],@"黑"
                                                      ,@[@"chong",@"zhong"],@"重"
                                                      ,@[@"bi",@"mi"],@"秘"
                                                      ,@[@"chong",@"zhong"],@"种"
                                                      ,@[@"qin",@"tan"],@"覃"
                                                      ,@[@"feng",@"ping"],@"冯"
                                                      ,@[@"miao",@"mou"],@"缪"
                                                      ,@[@"xia",@"jia"],@"夏"
                                                      ,@[@"qu",@"ju"],@"瞿"
                                                      ,@[@"zeng",@"ceng"],@"曾"
                                                      ,@[@"shi",@"dan"],@"石"
                                                      ,@[@"xie",@"jie"],@"解"
                                                      ,@[@"she",@"zhe"],@"折"
                                                      ,@[@"na",@"nei"],@"那"
                                                      ,@[@"zang",@"cang"],@"藏"
                                                      ,@[@"chu",@"zhu"],@"褚"
                                                      ,@[@"zha",@"za"],@"扎"
                                                      ,@[@"jing",@"ying"],@"景"
                                                      ,@[@"zhai",@"di"],@"翟"
                                                      ,@[@"du",@"dou"],@"都"
                                                      ,@[@"lu",@"liu"],@"六"
                                                      ,@[@"bo",@"bao"],@"薄"
                                                      ,@[@"xun",@"huan"],@"郇"
                                                      ,@[@"chao",@"zhao"],@"晁"
                                                      ,@[@"ben",@"bi"],@"贲"
                                                      ,@[@"jia",@"gu"],@"贾"
                                                      ,@[@"de",@"di"],@"的"
                                                      ,@[@"feng",@"ping"],@"冯"
                                                      ,@[@"ha",@"ka"],@"哈"
                                                      ,@[@"ju",@"ji"],@"居"
                                                      ,@[@"ge",@"gai"],@"盖"
                                                      ,@[@"zha",@"cha"],@"查"
                                                      ,@[@"sheng",@"cheng"],@"盛"
                                                      ,@[@"he",@"huo"],@"和"
                                                      ,@[@"bai",@"bo"],@"柏"
                                                      ,@[@"piao",@"pu"],@"朴"
                                                      ,@[@"mu",@"mou"],@"牟"
                                                      ,@[@"yin",@"yan"],@"殷"
                                                      ,@[@"gu",@"yu"],@"谷"
                                                      ,@[@"qian",@"gan"],@"乾"
                                                      ,@[@"lu",@"liu"],@"陆"
                                                      ,@[@"nie",@"mie"],@"乜"
                                                      ,@[@"le",@"yue"],@"乐"
                                                      ,@[@"tao",@"yao"],@"陶"
                                                      ,@[@"kan",@"han"],@"阚"
                                                      ,@[@"ye",@"xie"],@"叶"
                                                      ,@[@"qiang",@"jiang"],@"强"
                                                      ,@[@"bu",@"fou"],@"不"
                                                      ,@[@"a",@"e"],@"阿"
                                                      ,@[@"tang",@"shang"],@"汤"
                                                      ,@[@"wan",@"mo"],@"万"
                                                      ,@[@"che",@"ju"],@"车"
                                                      ,@[@"chen",@"cheng"],@"称"
                                                      ,@[@"shen",@"chen"],@"沈"
                                                      ,@[@"ou",@"qu"],@"区"
                                                      ,@[@"qiu",@"chou"],@"仇"
                                                      ,@[@"su",@"xiu"],@"宿"
                                                      ,@[@"nan",@"na"],@"南"
                                                      ,@[@"shan",@"dan"],@"单"
                                                      ,@[@"bu",@"bo"],@"卜"
                                                      ,@[@"niao",@"diao"],@"鸟"
                                                      ,@[@"si",@"sai"],@"思"
                                                      ,@[@"xun",@"xin"],@"寻"
                                                      ,@[@"yu",@"wu"],@"於"
                                                      ,@[@"yan",@"yin"],@"烟"
                                                      ,@[@"yu",@"tu"],@"余"
                                                      ,@[@"qian",@"jian"],@"浅"
                                                      ,@[@"ai",@"yi"],@"艾"
                                                      ,@[@"wan",@"huan"],@"浣"
                                                      ,nil];
                  });
    return g_pAllPolyphoneSurnamePinYin;
}















/**
 *  所有多音字匹配的带音调拼音键值对，每个姓氏多音字对应一个数组，数组中第一个字为正确发音，第二个为错误发音，错误发音用来做字符串替换使用
 *  多音字姓氏使用系统默认转换时，如果转换错误，将使用该键值对匹配替换
 */
+ (NSDictionary*)getDicForAllPolyphoneSurnamePinYinWithYinDiao;
{
    static NSDictionary* g_pAllPolyphoneSurnamePinYinWithYinDiao = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^
                  {
                      g_pAllPolyphoneSurnamePinYinWithYinDiao = [NSMutableDictionary dictionaryWithObjectsAndKeys
                                                                 :@[@"pó",@"fán"],@"繁"
                                                                 ,@[@"ōu",@"qū"],@"区"
                                                                 ,@[@"qiú",@"chóu"],@"仇"
                                                                 ,@[@"chóng",@"zhǒng"],@"种"
                                                                 ,@[@"shàn",@"dān"],@"单"
                                                                 ,@[@"xiè",@"jiě"],@"解"
                                                                 ,@[@"zhā",@"chá"],@"查"
                                                                 ,@[@"zēng",@"céng"],@"曾"
                                                                 ,@[@"bì",@"mì"],@"秘"
                                                                 ,@[@"yuè",@"lè"],@"乐"
                                                                 ,@[@"chóng",@"zhòng"],@"重"
                                                                 ,@[@"piáo",@"pǔ"],@"朴"
                                                                 ,@[@"miào",@"móu"],@"缪"
                                                                 ,@[@"xiǎn",@"shěng"],@"冼"
                                                                 ,@[@"zhái",@"dí"],@"翟"
                                                                 ,@[@"shé",@"zhé"],@"折"
                                                                 ,@[@"hè",@"hēi"],@"黑"
                                                                 ,@[@"gě",@"gài"],@"盖"
                                                                 ,@[@"shěn",@"chén"],@"沈"
                                                                 ,@[@"yù chí",@"wèi chí"],@"尉迟"
                                                                 ,@[@"mò qí",@"wàn qí"],@"万俟"
                                                                 ,nil];
                  });
    return g_pAllPolyphoneSurnamePinYinWithYinDiao;
}

/**
 *  所有的多音字匹配的拼音首字母键值对，每个姓氏多音字对应一字符串
 *  多音字姓氏使用第三方平台转换时，如果转换错误，将使用该键值对匹配替换
 */
+ (NSDictionary*)getDicForAllPolyphoneSurnameFirstLetters;
{
    static NSDictionary* g_pAllPolyphoneSurnameFirstLetters = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^
                  {
                      g_pAllPolyphoneSurnameFirstLetters = [NSMutableDictionary dictionaryWithObjectsAndKeys
                                                            :@"p",@"繁"
                                                            ,@"o",@"区"
                                                            ,@"q",@"仇"
                                                            ,@"c",@"种"
                                                            ,@"s",@"单"
                                                            ,@"x",@"解"
                                                            ,@"z",@"查"
                                                            ,@"z",@"曾"
                                                            ,@"b",@"秘"
                                                            ,@"y",@"乐"
                                                            ,@"c",@"重"
                                                            ,@"x",@"冼"
                                                            ,@"z",@"翟"
                                                            ,@"s",@"折"
                                                            ,@"s",@"沈"
                                                            ,@"yc",@"尉迟"
                                                            ,@"mq",@"万俟"
                                                            ,nil];
                  });
    return g_pAllPolyphoneSurnameFirstLetters;
}

/**
 *  把字符串中的汉字转换成拼音
 *
 *  @param isForSurname 明确字符串是否表示姓名
 *  @param bFlag        明确字符串转换完毕后是否需要拼音音调
 *
 *  @return 返回结果不做特殊处理，请注意系统默认转换汉字时采用小写拼音
 */
- (NSString*)pinyinForSort:(BOOL)isForSurname withYindiao:(BOOL)bFlag;
{
    NSString* convertString = self;
    if (isForSurname)
    {
        //如果是姓名优先去掉“·”符号
        convertString = [self stringByReplacingOccurrencesOfString:@"·" withString:@""];
    }
    NSMutableString *mutableString = [NSMutableString stringWithString:convertString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    if (bFlag)
    {
        NSString* pinyinString = [NSString stringWithString:mutableString];
        NSMutableString* resultString = [NSMutableString stringWithString:pinyinString];
        
        if (isForSurname) {
            //处理姓氏多音字
            NSArray* allPolyphoneSurname = [[NSString getDicForAllPolyphoneSurnamePinYinWithYinDiao] allKeys];
            for (NSString* tempPolyphoneSurname in allPolyphoneSurname)
            {
                if ([convertString hasPrefix:tempPolyphoneSurname])
                {
                    NSArray* arrayOfPolyphoneSurnamePinYinWithYinDiao = [[NSString getDicForAllPolyphoneSurnamePinYinWithYinDiao] valueForKey:tempPolyphoneSurname];
                    NSString* rightPinYin = arrayOfPolyphoneSurnamePinYinWithYinDiao[0];//[arrayOfPolyphoneSurnamePinYinWithYinDiao getObjectAtIndex:0];
                    NSString* wrongPinYin = arrayOfPolyphoneSurnamePinYinWithYinDiao[1];//[arrayOfPolyphoneSurnamePinYinWithYinDiao getObjectAtIndex:1];
                    NSRange rangeOfPinYin = NSMakeRange(0, wrongPinYin.length);
                    if ([[resultString substringWithRange:rangeOfPinYin] isEqualToString:wrongPinYin])
                    {
                        [resultString replaceCharactersInRange:rangeOfPinYin withString:rightPinYin];
                    }
                    break;
                }
            }
        }
        return resultString;
    
    } else {
        NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
        NSMutableString* resultString = [NSMutableString stringWithString:pinyinString];
        
        if (isForSurname)
        {
            //处理姓氏多音字
            NSArray* allPolyphoneSurname = [[NSString getDicForAllPolyphoneSurnamePinYin] allKeys];
            for (NSString* tempPolyphoneSurname in allPolyphoneSurname)
            {
                if ([convertString hasPrefix:tempPolyphoneSurname])
                {
                    NSArray* arrayOfPolyphoneSurnamePinYin = [[NSString getDicForAllPolyphoneSurnamePinYin] valueForKey:tempPolyphoneSurname];
                    NSString* rightPinYin = arrayOfPolyphoneSurnamePinYin[0];//[arrayOfPolyphoneSurnamePinYin getObjectAtIndex:0];
                    NSString* wrongPinYin = arrayOfPolyphoneSurnamePinYin[1];//[arrayOfPolyphoneSurnamePinYin getObjectAtIndex:1];
                    NSRange rangeOfPinYin = NSMakeRange(0, wrongPinYin.length);
                    if ([[resultString substringWithRange:rangeOfPinYin] isEqualToString:wrongPinYin])
                    {
                        [resultString replaceCharactersInRange:rangeOfPinYin withString:rightPinYin];
                    }
                    break;
                }
            }
        }
        return resultString;
    }
}

#pragma mark - PublicFunctions
- (NSString*)firstLettersForSort:(BOOL)isForSurname;
{
    NSString* convertString = self;
    if (isForSurname)
    {
        //如果是姓名优先去掉“·”符号
        convertString = [self stringByReplacingOccurrencesOfString:@"·" withString:@""];
    }
    NSMutableString* resultString = [NSMutableString string];
    if (convertString.length > 0)
    {
        unichar indexChar;
        for (NSUInteger nIndex = 0; nIndex < convertString.length; ++nIndex)
        {
            indexChar = [convertString characterAtIndex:nIndex];
            //判断字符是否为英文字母
            if ((indexChar >= 'A' && indexChar <= 'Z') ||
                (indexChar >= 'a' && indexChar <= 'z'))
            {
                [resultString appendString:[NSString stringWithFormat:@"%c", indexChar]];
            }
            //判断字符是否为汉字
            else if (isFirstLetterHANZI(indexChar))
            {
                NSString* firstCharacterInPinYin = [NSString stringWithFormat:@"%c",pinyinFirstLetter(indexChar)];//从第三方库中匹配这个汉子的拼音首字母
                if (firstCharacterInPinYin)
                {
                    [resultString appendString:firstCharacterInPinYin];
                }
                else//未识别字符保持不变
                {
                    [resultString appendString:[convertString substringWithRange:NSMakeRange(nIndex, 1)]];
                }
            }
            //其他字符保持不变
            else
            {
                [resultString appendString:[convertString substringWithRange:NSMakeRange(nIndex, 1)]];
            }
        }
        if (isForSurname)
        {
            //处理姓氏多音字
            NSArray* allPolyphoneSurname = [[NSString getDicForAllPolyphoneSurnameFirstLetters] allKeys];
            for (NSString* tempPolyphoneSurname in allPolyphoneSurname)
            {
                if ([convertString hasPrefix:tempPolyphoneSurname])
                {
                    [resultString replaceCharactersInRange:NSMakeRange(0, tempPolyphoneSurname.length) withString:[[NSString getDicForAllPolyphoneSurnameFirstLetters] valueForKey:tempPolyphoneSurname]];
                    break;
                }
            }
        }
    }
    return resultString;
}

- (NSString*)pinyinForSort:(BOOL)isForSurname;
{
    return [self pinyinForSort:isForSurname withYindiao:NO];
}

//- (NSString*)pinyinWithToneForSort:(BOOL)isForSurname;
//{
//    return [self pinyinForSort:isForSurname withYindiao:YES];
//}

@end
