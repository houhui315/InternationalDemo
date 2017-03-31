//
//  ZXYLanguageManager.h
//  CloudStudy
//
//  Created by 蓝泰致铭        on 2016/11/2.
//  Copyright © 2016年 蓝泰致铭. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const LocalizableName_Normal;
FOUNDATION_EXPORT NSString *const LocalizableName_Special;


typedef NS_ENUM(NSInteger, LanguageType) {
    
    LanguageType_zh_Hans,
    LanguageType_en
};


//是否支持国际化(1：支持 0：不支持)
#define supportInternational 0

#define kLanguageManager [ZXYLanguageManager shareInstance]

//当前系统语言设置是否是中文
#define ZXYIsCNLanguage ((kLanguageManager.languageType == LanguageType_zh_Hans)?YES:NO)

/**!
 *
 *  根据关键字找到对应的中文或英文翻译
 *
 */

#define ZXYLocalizedString(key) [kLanguageManager localizedStringForKey:key table:LocalizableName_Normal value:nil]

#define ZXYLocalizedTableString(key, tb) [kLanguageManager localizedStringForKey:key table:tb value:nil]

/**!
 *  文字里面有数字时本地化方法
 *  key为字符串
 *  value为字典
 *  用法:用唯一的标识符来标识一个位置的key（英文和中文的位置可能不一样），dic里key为唯一标识字符串，value为要替换的字符串，这样就完成了中文和英文翻译一句话里数字出现很多不同地方的不能准确翻译的问题。
 *
 */
#define ZXYLocalizedDicString(key, value) [kLanguageManager localizedStringForKey:key table:LocalizableName_Normal valueDic:value]

#define ZXYLocalizedTableDicString(key, tb, value) [kLanguageManager localizedStringForKey:key table:tb valueDic:value]

/*! @brief  多语言返回对应的图片方法
 *
 *  @attention
 *  @param  imageName      传入的图片名称
 *  @return 返回的多语言图片名称
 */

#define ZXYLocalizedImageString(imageName) [kLanguageManager internationalImageWithName:imageName]

@interface ZXYLanguageManager : NSObject

@property (nonatomic,copy) void (^completion)(NSString *currentLanguage);

@property (nonatomic, assign) LanguageType languageType;

@property (nonatomic, strong) NSString *currentLanguageName;

- (NSString *)languageFormat:(NSString*)language;

//多语言获取文本
- (NSString *)localizedStringForKey:(NSString *)key
                              table:(NSString *)table
                              value:(NSString *)value;

//多语言单文本
- (NSString *)localizedStringForKey:(NSString *)key
                              table:(NSString *)table
                           valueDic:(NSDictionary *)value;

//多语言富文本
- (NSMutableAttributedString *)localizedStringForKey:(NSString *)key
                                               table:(NSString *)table
                                            valueDic:(NSDictionary *)value
                                        attributeDic:(NSDictionary *)attribute
                                       baseAttribute:(NSDictionary *)baseAttribute;

- (NSString *)internationalImageWithName:(NSString *)name;

+ (instancetype)shareInstance;



@end
