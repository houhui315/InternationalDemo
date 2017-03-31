//
//  ZXYLanguageManager.m
//  CloudStudy
//
//  Created by 蓝泰致铭        on 2016/11/2.
//  Copyright © 2016年 蓝泰致铭. All rights reserved.
//

#import "ZXYLanguageManager.h"

NSString *const LocalizableName_Normal      = @"Localizable";
NSString *const LocalizableName_Special     = @"SpecialLocalizable";


@interface ZXYLanguageManager ()

@property (nonatomic, strong) NSBundle *bundle;

@property (nonatomic, strong) NSString *languageName;


@end

@implementation ZXYLanguageManager

+ (instancetype)shareInstance {
    static ZXYLanguageManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
        [_manager initUserLanguage];
    });
    return _manager;
}

//初始化语言
- (void)initUserLanguage {
    
#if supportInternational
    //获取系统偏好语言数组
    NSArray *languages = [NSLocale preferredLanguages];
    //第一个为当前语言
    NSString *currentLanguage = [languages firstObject];
#else
    NSString *currentLanguage = @"zh-Hans";
#endif
    
    self.languageName = [self languageFormat:currentLanguage];
    
    [self changeBundle:self.languageName];
    
    [self configureLanguageType];
}

//设置当前语种的类型
- (void)configureLanguageType{
    
    if ([self.languageName isEqualToString:@"zh-Hans"]) {
        
        self.languageType = LanguageType_zh_Hans;
        self.currentLanguageName = @"zh_CN";
    }else{
        self.languageType = LanguageType_en;
        self.currentLanguageName = @"en_US";
    }
}

//语言和语言对应的.lproj的文件夹前缀不一致时在这里做处理
- (NSString *)languageFormat:(NSString*)language {
    if([language rangeOfString:@"zh-Hans"].location != NSNotFound||
       [language rangeOfString:@"zh-Hant"].location != NSNotFound||
       [language rangeOfString:@"zh-HK"].location != NSNotFound||
       [language rangeOfString:@"zh-TW"].location != NSNotFound||
       [language rangeOfString:@"zh-Hans-CN"].location != NSNotFound) {
        
        return @"zh-Hans";
    }else{
        return @"en";
    }
}

//改变bundle
- (void)changeBundle:(NSString *)language {
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    _bundle = [NSBundle bundleWithPath:path];
}


//获取当前语种下的内容
- (NSString *)localizedStringForKey:(NSString *)key
                              table:(NSString*)table
                              value:(NSString *)value {
    
    if (key.length > 0) {
        if (_bundle) {
            
            NSString *str = NSLocalizedStringFromTableInBundle(key, table, _bundle, value);
            if (str.length > 0) {
                return str;
            }
        }
    }
    return @"";
}

- (NSString *)localizedStringForKey:(NSString *)key
                              table:(NSString*)table
                           valueDic:(NSDictionary *)value{
    
    
    __block NSString *localString = [self localizedStringForKey:key table:table value:nil];
    [value enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        
        if (key && key.length && obj && obj.length) {
            
            localString = [localString stringByReplacingOccurrencesOfString:key withString:obj];
        }
    }];
    return localString;
}

- (NSMutableAttributedString *)localizedStringForKey:(NSString *)key
                                               table:(NSString*)table
                                            valueDic:(NSDictionary *)value
                                        attributeDic:(NSDictionary *)attribute
                                       baseAttribute:(NSDictionary *)baseAttribute{
    
    __block NSString *localString = [self localizedStringForKey:key table:table value:nil];
    
    NSMutableDictionary *rangesDic = [NSMutableDictionary dictionary];
    
    [value enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
        
        if (key && key.length && obj && obj.length) {
            
            NSRange range = [localString rangeOfString:key];
            [rangesDic setObject:NSStringFromRange(range) forKey:key];
        }
    }];
    NSArray *sortKeyArray = [rangesDic keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSRange range1 = NSRangeFromString(obj1);
        NSRange range2 = NSRangeFromString(obj2);
        
        if (range1.location < range2.location) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    
    NSMutableDictionary *nRangeDic = [NSMutableDictionary dictionary];
    [sortKeyArray enumerateObjectsUsingBlock:^(NSString  *key, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *obj = value[key];
        NSRange range = [localString rangeOfString:key];
        range.length = obj.length;
        localString = [localString stringByReplacingOccurrencesOfString:key withString:obj];
        [nRangeDic setObject:NSStringFromRange(range) forKey:key];
    }];
    
    NSMutableAttributedString *muArrtibuteString = [[NSMutableAttributedString alloc] initWithString:localString];
    if (baseAttribute) {
        [muArrtibuteString addAttributes:baseAttribute range:NSMakeRange(0, localString.length)];
    }
    [attribute enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *attr, BOOL * _Nonnull stop) {
        
        NSRange range = NSRangeFromString(nRangeDic[key]);
        [muArrtibuteString addAttributes:attr range:range];
    }];
    return muArrtibuteString;
}

//图片多语言处理,用下面这种方法，图片命名的时候加上语言后缀，获取的时候调用此方法，在图片名后面加上语言后缀来显示图片。英文则为en后缀
- (NSString *)internationalImageWithName:(NSString *)name {
    if (self.languageType == LanguageType_en) {
        
        return [NSString stringWithFormat:@"%@_en",name];
    }else{
        return name;
    }
}

@end
