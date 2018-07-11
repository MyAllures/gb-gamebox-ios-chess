//
//  help.h
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#ifndef help_h
#define help_h

#import <UIKit/UIKit.h>
//#import "CLActivityIndicatorView.h"
#import <stdio.h>
#import "MBProgressHUD.h"

#pragma mark -
UIKIT_EXTERN NSString * const defaultReuseDef ;

#pragma mark-通用枚举定义
//----------动画相关--------------
typedef NS_ENUM(int,CLMoveAnimtedDirection) {
    CLMoveAnimtedDirectionUp,
    CLMoveAnimtedDirectionDown,
    CLMoveAnimtedDirectionLeft,
    CLMoveAnimtedDirectionRight
};

//----------------------------------------------------------

typedef NS_ENUM(NSInteger,CLViewControllerDesignatedShowWay){
    CLViewControllerDesignatedShowWayPush,       //push显示
    CLViewControllerDesignatedShowWayPresent,    //prsent显示
    CLViewControllerDesignatedShowWayUserDefine  //用户定义的方式
};

//----------------------------------------------------------
typedef NS_ENUM(NSUInteger, CLTabChangeDirection){
    CLTabChangeDirectionNone = 0,
    CLTabChangeDirectionPrev,//向前
    CLTabChangeDirectionNext //向后
} ;
//----------------------------------------------------------

//----------------------------------------------------------

//图片的的显示状态
typedef NS_OPTIONS(NSInteger,CLScanImageDisplayState) {
    CLScanImageDisplayStateNone    = 0,        //没有显示任何图片
    CLScanImageDisplayStateThumb   = 1 << 0,   //缩略图
    CLScanImageDisplayStateLoading = 1 << 1,   //正在加载
    CLScanImageDisplayStateSource  = 1 << 2    //显示原图
};
//----------------------------------------------------------

typedef NS_ENUM(NSUInteger, CLLanguageOption){
    CLLanguageOptionZHhans = 0,
    CLLanguageOptionZHhant ,
    CLLanguageOptionEnglish ,
    CLLanguageOptionJapanese
} ;


//----------尺寸相关--------------
//----------------------------------------------------------

//缩放模式
typedef NS_ENUM(NSInteger, CLZoomMode){
    /**  不改变长宽比，缩放至合适大小 */
    CLZoomModeAspectFit  = 0,
    /**  不改变长宽比，缩放至合适大小填充 */
    CLZoomModeAspectFill = 1,
    /**  可能改变长宽比，缩放至填充 */
    CLZoomModeFill       = 2
};

//缩放选项
typedef NS_ENUM(NSInteger, CLZoomOption){
    //无选项
    CLZoomOptionNone,
    //即原尺寸大于缩放后的目标尺寸才缩放
    CLZoomOptionZoomIn,
    //即原尺寸小于缩放后的目标尺寸才缩放
    CLZoomOptionZoomOut
};

//----------------------------------------------------------
//比例模式
typedef NS_ENUM(NSInteger, CLScaleMode){
    /** 基于当前比例,和当前比例一致 */
    CLScaleModeCurrent,
    /** 基于屏幕,和屏幕缩放比例一致 */
    CLScaleModeScreen,
    /** 基于像素，即比例为1 */
    CLScaleModePixel
};

//----------------------------------------------------------
//内容布局
typedef NS_ENUM(NSInteger,CLContentLayout) {
    CLContentLayoutCenter = 0,       //布局在中心
    CLContentLayoutTop    = 1 << 0,  //布局在上端，水平居中
    CLContentLayoutBottom = 1 << 1,  //布局在下端，水平居中
    CLContentLayoutLeft   = 1 << 2,  //布局在左端，竖直居中
    CLContentLayoutRight  = 1 << 3,  //布局在右端，竖直居中

    //左上
    CLContentLayoutLeftTop     = (CLContentLayoutLeft  | CLContentLayoutTop),
    //右上
    CLContentLayoutRightTop    = (CLContentLayoutRight | CLContentLayoutTop),
    //左下
    CLContentLayoutLeftBottom  = (CLContentLayoutLeft  | CLContentLayoutBottom),
    //右下
    CLContentLayoutRightBottom = (CLContentLayoutRight | CLContentLayoutBottom)
};

//----------内存相关--------------
//----------------------------------------------------------

// 输出自动释放池信息
extern void _objc_autoreleasePoolPrint(void);

//位置内存大小
#define CLMemorySizeUnknown -1.0

//返回物理内存大小，单位是MB
double physicalMemorySize(void);

//当前任务占用的内存数，单位是MB
double usedMemorySize(void);

//内存类型
typedef NS_OPTIONS(NSUInteger, CLMemoryType) {
    CLMemoryTypeNone      = 0,
    CLMemoryTypeFree      = 1 << 0,  //空闲
    CLMemoryTypeUsed      = 1 << 1,  //已使用
    CLMemoryTypeInactive  = 1 << 2,  //未激活
    CLMemoryTypeAvailable = CLMemoryTypeFree | //可获取的内存包括空闲及未激活的内存
    CLMemoryTypeInactive
};

//获取特定类型的内存大小
double memorySizeForType(CLMemoryType type);

#pragma mark-通用功能函数定义
//设置网络活动指示器的显示情况
void showNetworkActivityIndicator(BOOL bShow);

CAShapeLayer * createLineLayer(CGPoint startPoint,CGPoint endPoint,CGFloat lineWidth,UIColor * lineColor) ;

/**
 *角度与狐度互相转换
 */
static inline float degreesToRadians (float degrees) { return degrees * M_PI / 180;}
static inline float radiansToDegrees (float radians) { return radians * M_1_PI * 180;}

static inline CGRect CGRectAppendSize (CGRect rect,CGSize size) {
    rect.size.width += size.width;
    rect.size.height += size.height;
    return rect;
}

typedef enum {
    HashFuncType_MD2,
    HashFuncType_MD4,
    HashFuncType_MD5,
    HashFuncType_SHA1,
    HashFuncType_SHA224,
    HashFuncType_SHA256,
    HashFuncType_SHA384,
    HashFuncType_SHA512
}HashFuncType;

//获取设备标识号
NSString *getDeviceID(void) ;

//获得唯一标识ID
NSString * getUniqueID(void);

NSString * hashStrWithStr(NSString *STR,HashFuncType TYPE) ;

/*
 *获取系统版本
 */
float systemVersion(void);

/*
 *获取手机弄号
*/
NSString *getDeviceModel(void) ;


/*
 *获取屏幕尺寸
 */
CGSize screenSize(void);

BOOL nibFileExist(NSString * nibName, NSBundle * bundle) ;

#pragma mark- 图相尺寸相关
static inline CGFloat convertLenghtToScale(CGFloat lenght,CGFloat fromScale, CGFloat toScale) {
    return (toScale ? fromScale / toScale : 0.f) * lenght;
}
static inline CGFloat convertLenghtToCurrentScale(CGFloat lenght, CLScaleMode sizeScaleMode, CGFloat currentScale)
{
    if (sizeScaleMode == CLScaleModeCurrent) {
        return lenght;
    }else {
        return convertLenghtToScale(lenght, (sizeScaleMode == CLScaleModeScreen) ? [UIScreen mainScreen].scale : 1.f, currentScale);
    }
}

CGSize sizeZoomToTagetSize(CGSize sourceSize, CGSize targetSize, CLZoomMode zoomMode) ;
CGSize convertSizeToCurrentScale(CGSize size, CLScaleMode sizeScaleMode, CGFloat currentScale) ;
CGSize convertSizeToScale(CGSize size, CGFloat fromScale, CGFloat toScale) ;
CGSize sizeZoomToTagetSize_extend(CGSize sourceSize, CGSize targetSize, CLZoomMode zoomMode, CLZoomOption zoomOption) ;
#pragma mark-
CGRect contentRectForLayout(CGRect rect, CGSize contentSize, CLContentLayout contentLayout) ;


#pragma mark- 计算 label 文字大小
CGSize caculaterLabelTextDrawSize_e(NSAttributedString * attributedString,CGFloat containerWidth) ;
CGSize caculaterLabelTextDrawSize(NSString * text,UIFont * font,CGFloat containerWidth) ;


#pragma mark- 弹窗显示类
MBProgressHUD * showCustomMBProgressHUDView(UIView *view,NSString *titleText,NSString * detailText,UIView * customView,void(^completedBlock)(void)) ;
MBProgressHUD * showMessage(UIView *view,NSString * titleText,NSString * detailText) ;
MBProgressHUD * showMessage_b(UIView *view,NSString *titleText,NSString * detailText,void(^completedBlock)(void)) ;
MBProgressHUD * showMessageWithCustomView(UIView *view,NSString *titleText,NSString * detailText,UIView * customView) ;
MBProgressHUD * showMessageWithCustomView_b(UIView *view,NSString *titleText,NSString * detailText,UIView * customView,void(^completedBlock)(void)) ;
MBProgressHUD * showMessageWithImage(UIView *view,NSString *titleText,NSString * detailText,UIImage * image) ;
MBProgressHUD * showMessageWithImage_b(UIView *view,NSString *titleText,NSString * detailText,UIImage * image,void(^completedBlock)(void));
//显示错误消息
MBProgressHUD * showErrorMessage(UIView *view,NSError *error,NSString *titleText) ;
MBProgressHUD * showErrorMessage_b(UIView *view,NSError *error,NSString *titleText,void(^completedBlock)(void)) ;
MBProgressHUD * showErrorMessage_e(UIView *view,NSString *titleText,NSString *detailText,void(^completedBlock)(void));
//显示成功消息
MBProgressHUD * showSuccessMessage(UIView *view,NSString *titleText,NSString * detailText) ;
MBProgressHUD * showSuccessMessage_b(UIView *view,NSString *titleText,NSString * detailText,void(^completedBlock)(void)) ;
//MBProgressHUD * showHUDWithActivityIndicatorView(UIView * view,UIView<CLActivityIndicatorViewProtocol> * activityIndicatorView,NSString *title);
MBProgressHUD * showHUDWithMyActivityIndicatorView(UIView * view,UIColor *color,NSString *title) ;
void showNetworkStatusMessage(UIView *view) ;
UIAlertView * showAlertView(NSString *titleText,NSString * detailText) ;

void checkIndexAtRange(NSUInteger index,NSRange range) ;

#pragma mark -
BOOL makeSrueDirectoryExist(NSString *path);

#pragma amrk -
BOOL fileExistAtPath(NSString *path) ;
long long fileSizeAtPath(NSString *filePath) ;
long long folderSizeAtPath(NSString *folderPath) ;
void folderSizeAtPath_asyn(NSString *folderPath, void (^completeBlock)(long long)) ;
BOOL removeItemAtPath(NSString * path,BOOL onlyRemoveFile);

#pragma mark -
BOOL NSProtocolContainSelector(Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod) ;

BOOL isPhoneNumber(NSString *mobileNum) ;
BOOL isEmailAddress(NSString * email) ;
BOOL isInteger(NSString * integerStr) ;
BOOL isSidStr(NSString *sidStr) ;
NSArray * matchString(NSString *string) ;
//长SID 匹配数组
NSArray * matchLongString(NSString *string) ;
#pragma mark - 纯数字正则
BOOL isNumberSecert(NSString *secPassword) ;
//密码正则
BOOL isSimplePwd(NSString *password);
#pragma mark -- 是否升序
BOOL isAscendingPwd(NSString *password) ;
#pragma mark - 是否降序
BOOL isDescendingPwd(NSString *password);
#pragma mark - 是否升降序
BOOL isDescendingAndPwdisAscendingPwd(NSString *password) ;
#pragma mark -连续三个以上重复数字
BOOL isSameMoreThreePwd(NSString *password) ;

NSString * dateStringWithFormatter(NSDate * date,NSString * dateFormat) ;
NSString * dateString(NSDate * date,NSString * dateFormat) ;//这里主要处理时间选择器的，因为时间选择器不用转换时区
NSString * dateStringWithFormatterWithTimezone(NSDate * date,NSString * dateFormat,NSString *timezone) ;

#pragma mark-
NSArray * indexPathsFromRange(NSInteger section,NSRange range) ;
NSArray * indexPathsFromIndexSet(NSInteger section,NSIndexSet * indexSet);

#pragma mark-
CGAffineTransform rotationAffineTransformForOrientation(UIInterfaceOrientation orientation) ;

#pragma mark-
NSString * appStoreURL(NSString * appID) ;
NSString * appStoreHTTPURL(NSString * appID) ;
void gotoAppStore(NSString * appID) ;
BOOL openURL(NSString * url);
//BOOL isIgnoreHTTPS(NSString *domain) ;
NSString *getIPAddress(BOOL preferIPv4) ;
NSString *getLocalizedString(CLLanguageOption languageOption,NSString* key) ;
#endif /* help_h */
