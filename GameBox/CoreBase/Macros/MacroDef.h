//
//  MacroDef.h
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#ifndef MacroDef_h
#define MacroDef_h

#define GB_CURRENT_APPVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define GB_CURRENT_APPBUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//系统版本
#define SystemVersion systemVersion()

#define GreaterThanSystem(_version) (systemVersion() >= (_version))
#define GreaterThanIOS6System       GreaterThanSystem(6.f)
#define GreaterThanIOS7System       GreaterThanSystem(7.f)
#define GreaterThanIOS8System       GreaterThanSystem(8.f)
#define GreaterThanIOS9System       GreaterThanSystem(9.f)
#define GreaterThanIOS10System      GreaterThanSystem(10.f)
#define GreaterThanIOS11System      GreaterThanSystem(11.f)

#define IS_SUPPORT_ARC  __has_feature(objc_arc)

//----------------------------------------------------------
//----------------------------------------------------------

#define MainScreenH [UIScreen mainScreen].bounds.size.height
#define MainScreenW [UIScreen mainScreen].bounds.size.width
#define MainScreenBounds [UIScreen mainScreen].bounds

/**
 *字符号转成DATA encoding utf-8
 */
#define DataWithUTF8Code(_str)          [_str dataUsingEncoding:NSUTF8StringEncoding]

/**
 *对象指针转成nsnumber类型
 **/
#define NSNumberWithPointer(_pointer) [NSNumber numberWithUnsignedInteger:((NSUInteger)(_pointer))]

#define ifRespondsSelector(_obj,_sel)  if (_obj&&[(NSObject *)_obj respondsToSelector:_sel])

//判断是否为http请求的URL
#define __IS_HTTP_URL__IMP__(_url,L)                                                \
({                                                                                  \
NSString * __NSX_PASTE__(__url,L) = (id)(_url);                                 \
BOOL __NSX_PASTE__(__bRet,L) = NO;                                              \
if([__NSX_PASTE__(__url,L) isKindOfClass:[NSString class]] && __NSX_PASTE__(__url,L).length) {  \
__NSX_PASTE__(__url,L) = [__NSX_PASTE__(__url,L) lowercaseString];          \
__NSX_PASTE__(__bRet,L) = [__NSX_PASTE__(__url,L) hasPrefix:@"http://"] ||  \
[__NSX_PASTE__(__url,L) hasPrefix:@"https://"];   \
}                                                                               \
__NSX_PASTE__(__bRet,L);                                                        \
})
#define IS_HTTP_URL(_url) __IS_HTTP_URL__IMP__(_url,__COUNTER__)

//颜色创建
#define ColorWithRGBA(int_r,int_g,int_b,_alpha)  \
[UIColor colorWithRed:(int_r)/255.0 green:(int_g)/255.0 blue:(int_b)/255.0 alpha:_alpha]
#define colorWithRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//通过数字初始化颜色
#define ColorWithNumberRGBA(_hex,_alpha) ColorWithRGBA(((_hex)>>16)&0xFF,((_hex)>>8)&0xFF,(_hex)&0xFF,_alpha)
#define ColorWithNumberRGB(_hex) ColorWithNumberRGBA(_hex,1.f)

//通过数字初始化颜色
#define ColorWithNumberRGBA(_hex,_alpha) ColorWithRGBA(((_hex)>>16)&0xFF,((_hex)>>8)&0xFF,(_hex)&0xFF,_alpha)
#define ColorWithNumberRGB(_hex) ColorWithNumberRGBA(_hex,1.f)

#define ColorWithWhite(int_w,_alpha) [UIColor colorWithWhite:(int_w)/255.0 alpha:_alpha]
#define BlackColorWithAlpha(_alpha) ColorWithWhite(0,_alpha)

//----------------------------------------------------------

//转换TimeInterval 到 分，小时，天
#define SecPerDay                               86400.0
#define SecPerHour                              3600.0
#define MinPerHour                              60.0
#define SecPerMin                               MinPerHour
#define DayForTimeInterval(_time)               floor((_time) / SecPerDay)
#define HourForTimeInterval(_time)              floor((_time) / SecPerHour)
#define MinForTimeInterval(_time)               floor((_time) / SecPerMin)


//改变到范围内
#define ChangeInMinToMax(_value,_min,_max)  MAX(MIN(_value,_max),_min)

//像素转换为点
#define PixelToPoint(_p)   ((_p) / [UIScreen mainScreen].scale)

//通过名字初始化图片
#define ImageWithName(_name)  [UIImage imageNamed:(_name)]

//断言
#if DEBUG
#define	MyAssert(e) assert(e)
#else
#define	MyAssert(e)
#endif

//调试输出

#if DEBUG

#define DebugLog(_targetDomin,_format,...)                                                  \
do {                                                                                    \
fprintf(stderr, "\n--------------------------------\n\n");                          \
fprintf(stderr, "<%s : %d> %s\n\n",                                                 \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
NSLog(@"\n\n["#_targetDomin@"]\n\n"_format,##__VA_ARGS__);                          \
fprintf(stderr, "\n--------------------------------\n\n");                          \
} while (0)

#else

#define DebugLog(_targetDomin,_format,...)

#endif


//错误创建
#define __ERROR_CREATE_IMP__(_domain, _code, _description, _userinfo, L)                                            \
({                                                                                                                  \
NSMutableDictionary * __NSX_PASTE__(__userinfo,L) = (id)(_userinfo);                                            \
if(__NSX_PASTE__(__userinfo,L)) {                                                                               \
__NSX_PASTE__(__userinfo,L) = [NSMutableDictionary dictionaryWithDictionary:__NSX_PASTE__(__userinfo,L)];   \
}else {                                                                                                         \
__NSX_PASTE__(__userinfo,L) = [NSMutableDictionary dictionary];                                             \
}                                                                                                               \
NSString * __NSX_PASTE__(__description,L)  = (id)(_description);                                                \
if([__NSX_PASTE__(__description,L) isKindOfClass:[NSString class]]) {                                           \
[__NSX_PASTE__(__userinfo,L) setObject:__NSX_PASTE__(__description,L)                                       \
forKey:NSLocalizedDescriptionKey];                                          \
}                                                                                                               \
[NSError errorWithDomain:_domain                                                                                \
code:_code                                                                                  \
userInfo:__NSX_PASTE__(__userinfo,L)];                                                          \
})
#define ERROR_CREATE(_domain,_code,_description,_userinfo)        \
__ERROR_CREATE_IMP__(_domain, _code, _description, _userinfo, __COUNTER__)

//错误识别,判断错误是否为_domain错误域的错误
#define __IS_DOMAIN_ERROR_IMP__(_error,_domain,L)                 \
({                                                                \
NSError * __NSX_PASTE__(__error,L)  = _error;                 \
[__NSX_PASTE__(__error,L).domain isEqualToString:_domain];    \
})
#define IS_DOMAIN_ERROR(_error,_domain) __IS_DOMAIN_ERROR_IMP__(_error,_domain,__COUNTER__)


//错误识别,判断错误是否为_domain错误域的code错误码的错误
#define __IS_SPECIFIC_ERROR_IMP__(_error,_domain,_code,L)         \
({                                                                \
NSError * __NSX_PASTE__(__error,L)  = _error;                 \
([__NSX_PASTE__(__error,L).domain isEqualToString:_domain] && \
(__NSX_PASTE__(__error,L).code == (_code)));                 \
})
#define IS_SPECIFIC_ERROR(_error,_domain,_code)  __IS_SPECIFIC_ERROR_IMP__(_error,_domain,_code,__COUNTER__)

//矩形中心
#define __CenterForRect_IMP__(_rect,L)  \
({ \
CGRect __NSX_PASTE__(__rect,L) = _rect; \
CGPointMake(CGRectGetMidX(__NSX_PASTE__(__rect,L)), CGRectGetMidY(__NSX_PASTE__(__rect,L))); \
})
#define CenterForRect(_rect) __CenterForRect_IMP__(_rect,__COUNTER__)

#pragma mark- layout 属性
//初始化一个布局限制
#define InitConstraint(_view1,_attr1,_view2,_attr2,_relation,_mul,_constance)  \
[NSLayoutConstraint constraintWithItem:_view1 attribute:_attr1 relatedBy:_relation toItem:_view2 attribute:_attr2 multiplier:_mul constant:_constance]

//初始化一个相关的相同属性的布局限制
#define InitRelatedCommonAttrConstraint(_view1,_attr,_view2,_mul,_constance)    \
InitConstraint(_view1,_attr,_view2,_attr,NSLayoutRelationEqual,_mul,_constance)

//设置子视图与父视图同一属性相关的限制
#define setRelatedCommonAttrConstraint(_view,_attr,_superView,_mul,_constance) \
[_superView addConstraint:InitRelatedCommonAttrConstraint(_view,_attr,_superView,_mul,_constance)]

//设置边界限制
#define setEdgeConstraint(_view,_attr,_superView,_constance) \
setRelatedCommonAttrConstraint(_view,_attr,_superView,1.f,_constance)

//设置大小限制
#define setSizeConstraint(_view,_attr,_constance) \
setSizeConstraint_(_view,_attr,NSLayoutRelationEqual,_constance)

//设置大小限制
#define setSizeConstraint_(_view,_attr,_relation,_constance) \
[_view addConstraint:InitConstraint(_view,_attr,nil,NSLayoutAttributeNotAnAttribute,NSLayoutRelationEqual,0.f,_constance)]


//设置所有子视图到父视图所有边界距离为固定值，实现居中效果，且会自动调整大小
#define setAllEdgeConstraint(_view,_superView,_constance)                      \
do{                                                                            \
setEdgeConstraint(_view,NSLayoutAttributeLeft,_superView,_constance);      \
setEdgeConstraint(_view,NSLayoutAttributeRight,_superView,-_constance);    \
setEdgeConstraint(_view,NSLayoutAttributeTop,_superView,_constance);       \
setEdgeConstraint(_view,NSLayoutAttributeBottom,_superView,-_constance);   \
}while(0)

//实现居中效果，不会自动调节大小
#define setCenterConstraint(_view,_superView)                                              \
do{                                                                                        \
setRelatedCommonAttrConstraint(_view, NSLayoutAttributeCenterX, _superView,1.f,0.f);   \
setRelatedCommonAttrConstraint(_view, NSLayoutAttributeCenterY, _superView,1.f,0.f);   \
}while(0)

#pragma mark---

#define _ACCESSOR(accessor,ctype,member) \
-(ctype)accessor{\
return member ;\
}

#define _MUTATOR(mutator,ctype,member) \
-(void)mutator:(ctype)value { \
member = value ; \
}

#define PROPERTY_IMP(accessor,mutator,ctype,member) \
_ACCESSOR(accessor, ctype, member) \
_MUTATOR(mutator, ctype, member)

//指针的安全转换
#define ConvertToClassPointer(className,instance) \
[(NSObject *)instance isKindOfClass:[className class]] ? (className *)instance : nil

#define NSNumberWithPointer(_pointer) [NSNumber numberWithUnsignedInteger:((NSUInteger)(_pointer))]


//获取资源路径
#define __PathForResource__IMP__(_name, _bundle, L)                                              \
({                                                                                               \
NSString * __NSX_PASTE__(__path,L) = nil;                                                    \
NSString * __NSX_PASTE__(__name,L) = _name;                                                  \
if (__NSX_PASTE__(__name,L).length) {                                                        \
NSRange __NSX_PASTE__(__range,L) = [__NSX_PASTE__(__name,L) rangeOfString:@"." options:NSBackwardsSearch]; \
NSBundle *  __NSX_PASTE__(__bundle,L) = _bundle ?: [NSBundle mainBundle];                \
if (__NSX_PASTE__(__range,L).location != NSNotFound &&                                   \
__NSX_PASTE__(__range,L).location < __NSX_PASTE__(__name,L).length - 1) {            \
__NSX_PASTE__(__path,L) = [__NSX_PASTE__(__bundle,L) pathForResource:[__NSX_PASTE__(__name,L) substringToIndex:__NSX_PASTE__(__range,L).location] ofType:[__NSX_PASTE__(__name,L) substringFromIndex:__NSX_PASTE__(__range,L).location + 1]];                                                                  \
}                                                                                        \
}                                                                                            \
__NSX_PASTE__(__path,L);                                                                     \
})
#define PathForResource(_name, _bundle) __PathForResource__IMP__(_name, _bundle, __COUNTER__)


#define ResourceFilePathInBundle(_bundle,_name,_type) \
[_bundle ?: [NSBundle mainBundle] pathForResource:_name ofType:_type]
#define ResourceFilePath(_name,_type) \
[[NSBundle mainBundle] pathForResource:_name ofType:_type]

#define PlistResourceFilePathInBundle(_bundle,_name) \
[_bundle ?: [NSBundle mainBundle] pathForResource:_name ofType:@"plist"]
#define PlistResourceFilePath(_name) \
[[NSBundle mainBundle] pathForResource:_name ofType:@"plist"]


#define __CLStringIsEqual_IMP__(_str1, _str2, L)   \
({ \
NSString *  __NSX_PASTE__(__str1,L) = _str1; \
NSString * __NSX_PASTE__(__str2,L) = _str2;  \
([__NSX_PASTE__(__str1,L) length] == 0 && [__NSX_PASTE__(__str2,L) length] == 0) || \
[__NSX_PASTE__(__str1,L) isEqualToString:__NSX_PASTE__(__str2,L)]; \
})
#define CLStringIsEqual(_str1, _str2) __CLStringIsEqual_IMP__(_str1, _str2, __COUNTER__)


//单行文本尺寸
#define TEXTSIZE(text, font)   \
([text length] > 0 ? [text sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero)

//多行文本尺寸
#define MULTILINE_TEXTSIZE(text, font, maxSize, mode)  \
([text length] > 0 ? [text boundingRectWithSize:maxSize  \
options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
attributes:@{NSFontAttributeName           : font, \
NSForegroundColorAttributeName: [UIColor blackColor]} \
context:nil].size : CGSizeZero)

//获取内容矩形，单位量，0~1
#define __ContentsRectForRect_IMP__(_contentRect,_rect,L) \
({ \
CGRect __NSX_PASTE__(__rect,L) = _rect; \
CGRect __NSX_PASTE__(__contentRect,L) = _contentRect; \
CGFloat __NSX_PASTE__(__width,L) = CGRectGetWidth(__NSX_PASTE__(__rect,L));  \
CGFloat __NSX_PASTE__(__height,L) = CGRectGetHeight(__NSX_PASTE__(__rect,L)); \
CGRectMake(__NSX_PASTE__(__width,L)  ? CGRectGetMinX(__NSX_PASTE__(__contentRect,L)) / __NSX_PASTE__(__width,L) : 0.f,    \
__NSX_PASTE__(__height,L) ? CGRectGetMinY(__NSX_PASTE__(__contentRect,L)) / __NSX_PASTE__(__height,L) : 0.f,   \
__NSX_PASTE__(__width,L)  ? CGRectGetWidth(__NSX_PASTE__(__contentRect,L)) / __NSX_PASTE__(__width,L) : 0.f,   \
__NSX_PASTE__(__height,L) ? CGRectGetHeight(__NSX_PASTE__(__contentRect,L)) / __NSX_PASTE__(__height,L) : 0.f);\
})
#define ContentsRectForRect(_contentRect,_rect) __ContentsRectForRect_IMP__(_contentRect,_rect,__COUNTER__)

//是否是长图
#define __IS_LONGIMAGE__IMP__(_imageSize, _basicSize, _factor,L) \
({  \
CGSize __NSX_PASTE__(__imageSize,L) = _imageSize;   \
CGSize __NSX_PASTE__(__basicSize,L) = _basicSize;   \
BOOL __NSX_PASTE__(__bRet,L) = NO;  \
if(__NSX_PASTE__(__imageSize,L).width && __NSX_PASTE__(__basicSize,L).width &&              \
(__NSX_PASTE__(__imageSize,L).width  >= __NSX_PASTE__(__basicSize,L).width * 0.5f ||      \
__NSX_PASTE__(__imageSize,L).height >= __NSX_PASTE__(__basicSize,L).height) * 0.5f  ) {  \
__NSX_PASTE__(__bRet,L) = (__NSX_PASTE__(__imageSize,L).height / __NSX_PASTE__(__imageSize,L).width) >= \
((_factor) * (__NSX_PASTE__(__basicSize,L).height / __NSX_PASTE__(__basicSize,L).width));  \
}   \
__NSX_PASTE__(__bRet,L);    \
})
#define IS_LONGIMAGE(_imageSize, _basicSize, _factor)   __IS_LONGIMAGE__IMP__(_imageSize, _basicSize, _factor,__COUNTER__)
#define IS_LONGIMAGE_BASIC_SCREEN(_imageSize, _factor)  IS_LONGIMAGE(_imageSize, screenSize(), _factor)

//创建引用
#define WEAK_REFRENCE(_obj,_name) typeof(_obj) __weak _name = _obj;
#define STRONG_REFRENCE(_obj,_name) typeof(_obj) __strong _name = _obj;

#define IS_EMPTY_STRING(para) ([para isEqual:[NSNull null]] || para == nil || [[para stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])

//调试输出

#if DEBUG

#define DebugLog(_targetDomin,_format,...)                                                  \
do {                                                                                    \
fprintf(stderr, "\n--------------------------------\n\n");                          \
fprintf(stderr, "<%s : %d> %s\n\n",                                                 \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
NSLog(@"\n\n["#_targetDomin@"]\n\n"_format,##__VA_ARGS__);                          \
fprintf(stderr, "\n--------------------------------\n\n");                          \
} while (0)

#else

#define DebugLog(_targetDomin,_format,...)

#endif

//默认作用域的debug输出
#define DefaultDebugLog(_format,...)   DebugLog(DefaultDomin,_format, ##__VA_ARGS__)

#endif /* MacroDef_h */
