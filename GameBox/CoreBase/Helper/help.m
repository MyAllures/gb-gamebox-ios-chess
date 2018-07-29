//
//  help.c
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "help.h"
#import "MacroDef.h"
#import "CLNetReachability.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>
#import <mach/mach.h>
//#import "SAMKeychain.h"
#import "sys/utsname.h"
#import "RH_UserInfoManager.h"

#pragma mark -
NSString * const defaultReuseDef = @"defaultReuseDef";


#pragma mark -

//返回物理内存大小，单位是MB
double physicalMemorySize() {
    return [[NSProcessInfo processInfo] physicalMemory] / (1024.0 * 1024.0);
}

//当前任务占用的内存数，单位是MB
double usedMemorySize()
{
    //获取当前任务的信息
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);

    if (kernReturn != KERN_SUCCESS) {
        return CLMemorySizeUnknown;
    }

    return taskInfo.resident_size / (1024.0 * 1024.0);
}

double memorySizeForType(CLMemoryType type)
{
    if (type == CLMemoryTypeNone) {
        return 0.0;
    }

    //获取内存统计信息
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);

    if (kernReturn != KERN_SUCCESS) {
        return CLMemorySizeUnknown;
    }

    unsigned long long size = 0;

    if (type & CLMemoryTypeFree) size += vmStats.free_count;
    if (type & CLMemoryTypeUsed) size += (vmStats.active_count + vmStats.wire_count);
    if (type & CLMemoryTypeInactive) size += vmStats.inactive_count;

    return (size * vm_page_size) / (1024.0 * 1024.0);
}

#pragma MARK-
void showNetworkActivityIndicator(BOOL bShow)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        static NSUInteger networkActivityIndicatorShowTimes = 0;
        
        if (bShow) {
            
            if (networkActivityIndicatorShowTimes == 0) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            }
            
            //显示次数+1
            networkActivityIndicatorShowTimes ++ ;
            
        }else if (networkActivityIndicatorShowTimes > 0) {
            
            networkActivityIndicatorShowTimes -- ;
            
            //无显示次数，则隐藏
            if (networkActivityIndicatorShowTimes == 0) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        }
    }) ;
}

CAShapeLayer * createLineLayer(CGPoint startPoint,CGPoint endPoint,CGFloat lineWidth,UIColor * lineColor)
{
    CAShapeLayer * lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.lineWidth = lineWidth;
    lineLayer.strokeColor = lineColor.CGColor;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathCloseSubpath(path);
    lineLayer.path = path;
    CGPathRelease(path);

    return lineLayer;
}
/*
NSString *getDeviceID()
{
#define RH_DeviceID             @"RH_DeviceID"
    NSString * currentDeviceUUIDStr = [SAMKeychain passwordForService:@" "account:RH_DeviceID];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""])
    {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SAMKeychain setPassword: currentDeviceUUIDStr forService:@" "account:RH_DeviceID];
    }

    return currentDeviceUUIDStr;
}
*/
//获得唯一标识ID
NSString * getUniqueID()
{
    //创建一个CFUUIDRef类型对象
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);

    //获得一个唯一的字符ID
    CFStringRef newUniqueString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);

    //转换成NSString
    NSString *str = (__bridge NSString *)newUniqueString;

    //释放
    CFRelease(newUniqueID);
    CFRelease(newUniqueString);

    return str;
}

NSString * hashStrWithStr(NSString *STR,HashFuncType TYPE)
{
    if (!STR) {
        return nil;
    }

    unsigned char * (*caculateFunc)(const void *, CC_LONG , unsigned char *);
    CC_LONG DIGEST_LENGTH = 0;


#define SwitchCaseWithHashFuncName(_name)         \
case HashFuncType_##_name:                        \
DIGEST_LENGTH = CC_##_name##_DIGEST_LENGTH;   \
caculateFunc = CC_##_name;                    \
break;

    switch (TYPE) {
            SwitchCaseWithHashFuncName(MD2)
            SwitchCaseWithHashFuncName(MD4)
            SwitchCaseWithHashFuncName(MD5)
            SwitchCaseWithHashFuncName(SHA1)
            SwitchCaseWithHashFuncName(SHA224)
            SwitchCaseWithHashFuncName(SHA256)
            SwitchCaseWithHashFuncName(SHA384)
            SwitchCaseWithHashFuncName(SHA512)
    }

    unsigned char *digest = malloc(sizeof(unsigned char) * DIGEST_LENGTH);
    NSData *stringBytes = [STR dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableString *returnStr = nil;
    if (caculateFunc([stringBytes bytes],(CC_LONG)[stringBytes length],digest)) {
        returnStr = [NSMutableString stringWithCapacity:DIGEST_LENGTH * 2];
        for (CC_LONG i = 0; i < DIGEST_LENGTH; i ++) {
            [returnStr appendFormat:@"%02X",digest[i]];
        }
    }

    free(digest);

    return returnStr;
}


//----------------------------------------------------------

float systemVersion()
{
    static float version = 0.f;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSArray * components = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];

        NSInteger count = components.count;
        if (count >= 2) {
            NSMutableString * versionStr = [NSMutableString stringWithFormat:@"%@.",[components firstObject]];
            for (NSInteger i = 1; i < count; ++ i) {
                [versionStr appendString:components[i]];
            }
            version = [versionStr floatValue];
        }else {
            version = [[components firstObject] integerValue];
        }
    });


    return version;
}

NSString *getDeviceModel(void)
{
    static NSString *deviceName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
//        deviceName = [[UIDevice currentDevice] systemName];
        NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        //iPhone
        if ([deviceString isEqualToString:@"iPhone1,1"]){
            deviceName =  @"iPhone 1G";
        }else if ([deviceString isEqualToString:@"iPhone1,2"]){
            deviceName =  @"iPhone 3G";
        }else if ([deviceString isEqualToString:@"iPhone2,1"]){
            deviceName =  @"iPhone 3GS";
        }else if ([deviceString isEqualToString:@"iPhone3,1"]){
            deviceName = @"iPhone 4";
        }else if ([deviceString isEqualToString:@"iPhone3,2"]){
            deviceName = @"Verizon iPhone 4";
        }else if ([deviceString isEqualToString:@"iPhone4,1"]){
            deviceName = @"iPhone 4S" ;
        }else if ([deviceString isEqualToString:@"iPhone5,1"]){
            deviceName = @"iPhone 5";
        }else if ([deviceString isEqualToString:@"iPhone5,2"]){
            deviceName = @"iPhone 5";
        }else if ([deviceString isEqualToString:@"iPhone5,3"]){
            deviceName = @"iPhone 5C";
        }else if ([deviceString isEqualToString:@"iPhone5,4"]){
            deviceName =  @"iPhone 5C";
        }else if ([deviceString isEqualToString:@"iPhone6,1"]){
            deviceName = @"iPhone 5S";
        }else if ([deviceString isEqualToString:@"iPhone6,2"]){
            deviceName = @"iPhone 5S";
        }else if ([deviceString isEqualToString:@"iPhone7,1"]){
            deviceName = @"iPhone 6 Plus";
        }else if ([deviceString isEqualToString:@"iPhone7,2"]){
            deviceName = @"iPhone 6";
        }else if ([deviceString isEqualToString:@"iPhone8,1"]){
            deviceName = @"iPhone 6s" ;
        }else if ([deviceString isEqualToString:@"iPhone8,2"]){
           deviceName = @"iPhone 6s Plus";
        }else if ([deviceString isEqualToString:@"iPhone9,1"]){
            deviceName = @"iPhone 7";
        }
        else if ([deviceString isEqualToString:@"iPhone9,2"]){
            deviceName = @"iPhone 7 Plus";
        }
        else if ([deviceString isEqualToString:@"iPhone10,1"]){
            deviceName = @"iPhone 8";
        }
        else if ([deviceString isEqualToString:@"iPhone10,2"]){
            deviceName = @"iPhone 8 Plus";
        }
        else{
            deviceName = @"iPhone" ;
        }
    });
    
    return deviceName;
}

CGSize screenSize()
{
    static CGSize _screenSize;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize _screenSize_ = [UIScreen mainScreen].bounds.size;
        _screenSize.width = MIN(_screenSize_.width, _screenSize_.height);
        _screenSize.height = MAX(_screenSize_.width, _screenSize_.height);

    });

    return _screenSize;
}


BOOL nibFileExist(NSString * nibName, NSBundle * bundle)
{
    if (nibName.length) {
        return [bundle ?: [NSBundle mainBundle] pathForResource:nibName ofType:@"nib"].length;
    }

    return NO;
}

#pragma mark-
CGSize sizeZoomToTagetSize(CGSize sourceSize, CGSize targetSize, CLZoomMode zoomMode)
{
    CGSize resultSize = targetSize;

    if (zoomMode != CLZoomModeFill) {

        //计算长宽压缩比例
        CGFloat widthFactor  = sourceSize.width  ? fabs(targetSize.width  / sourceSize.width)  : 0.f;
        CGFloat heightFactor = sourceSize.height ? fabs(targetSize.height / sourceSize.height) : 0.f;

        //当长宽压缩比例很接近可认为等比例压缩，绘制大小直接等于目标大小
        if (fabs(widthFactor - heightFactor) > 0.000001) {

            //计算绘制的尺寸（不使用缩放比例相乘是为了避免不必要的背景色）
            if (zoomMode == CLZoomModeAspectFit) {
                if (widthFactor < heightFactor) {
                    resultSize.height = sourceSize.height * widthFactor;
                }else {
                    resultSize.width  = sourceSize.width * heightFactor;
                }
            }else {
                if (widthFactor > heightFactor) {
                    resultSize.height = sourceSize.height * widthFactor;
                }else {
                    resultSize.width  = sourceSize.width * heightFactor;
                }
            }
        }
    }

    return resultSize;
}

CGSize convertSizeToCurrentScale(CGSize size, CLScaleMode sizeScaleMode, CGFloat currentScale)
{
    if (sizeScaleMode == CLScaleModeCurrent) {
        return size;
    }else {
        return convertSizeToScale(size, (sizeScaleMode == CLScaleModeScreen) ? [UIScreen mainScreen].scale : 1.f, currentScale);
    }
}

CGSize convertSizeToScale(CGSize size, CGFloat fromScale, CGFloat toScale)
{
    if (fromScale == toScale) {
        return size;
    }else {
        CGFloat scaleFator = toScale ?  fromScale / toScale : 0.f;
        return CGSizeMake(size.width * scaleFator, size.height * scaleFator);
    }
}

CGSize sizeZoomToTagetSize_extend(CGSize sourceSize, CGSize targetSize, CLZoomMode zoomMode, CLZoomOption zoomOption)
{
    CGSize size = sizeZoomToTagetSize(sourceSize, targetSize, zoomMode);

    switch (zoomOption) {
        case CLZoomOptionZoomIn:

            //缩放后的尺寸小于原尺寸，才有效
            if (size.width > sourceSize.width &&
                size.height > sourceSize.height) {
                size = sourceSize;
            }

            break;

        case CLZoomOptionZoomOut:

            //缩放后的尺寸大于原尺寸，才有效
            if (size.width < sourceSize.width &&
                size.height < sourceSize.height) {
                size = sourceSize;
            }

            break;

        default:
            break;
    }

    return size;
}

#pragma mark-
CGRect contentRectForLayout(CGRect rect, CGSize contentSize, CLContentLayout contentLayout)
{
    //原点
    CGPoint origin = CGPointZero;

    //水平
    if (contentLayout & CLContentLayoutLeft) {
        origin.x = CGRectGetMinX(rect);
    }else if(contentLayout & CLContentLayoutRight){
        origin.x = CGRectGetMaxX(rect) - contentSize.width;
    }else{
        origin.x = CGRectGetMinX(rect) + (CGRectGetWidth(rect) - contentSize.width) * 0.5f;
    }

    //竖直
    if (contentLayout & CLContentLayoutTop) {
        origin.y = CGRectGetMinY(rect);
    }else if(contentLayout & CLContentLayoutBottom){
        origin.y = CGRectGetMaxY(rect) - contentSize.height;
    }else{
        origin.y = CGRectGetMinY(rect) + (CGRectGetHeight(rect) - contentSize.height) * 0.5f;
    }

    return CGRectMake(origin.x, origin.y, contentSize.width, contentSize.height);
}

#pragma mark- 计算 label 文字大小
CGSize caculaterLabelTextDrawSize_e(NSAttributedString * attributedString,CGFloat containerWidth)
{
    static UILabel * labelForCaculaterSize = nil;
    if (!labelForCaculaterSize) {
        labelForCaculaterSize = [[UILabel alloc] init];
        labelForCaculaterSize.numberOfLines = NSIntegerMax;
    }

    labelForCaculaterSize.preferredMaxLayoutWidth = containerWidth;
    labelForCaculaterSize.attributedText = attributedString;

    return labelForCaculaterSize.intrinsicContentSize;
}

CGSize caculaterLabelTextDrawSize(NSString * text,UIFont * font,CGFloat containerWidth)
{
    if (text.length) {
        return caculaterLabelTextDrawSize_e([[NSAttributedString alloc] initWithString:text  attributes:@{NSFontAttributeName:font ?: [UIFont systemFontOfSize:17.f]}], containerWidth);
    }

    return CGSizeZero;
}

#pragma mark- 弹窗显示类
MBProgressHUD * showCustomMBProgressHUDView(UIView *view,NSString *titleText,NSString * detailText,UIView * customView,void(^completedBlock)(void))
{
    //初始化
    MBProgressHUD * progressHUD = [[MBProgressHUD alloc] init];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.customView = customView;
    progressHUD.label.text = titleText;
    progressHUD.detailsLabel.text = detailText;
    progressHUD.userInteractionEnabled = NO;

    if (!view) {

        UIWindow * topWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        topWindow.windowLevel = UIWindowLevelAlert;
        topWindow.userInteractionEnabled = NO;
        [topWindow makeKeyAndVisible];
        [topWindow addSubview:progressHUD];

        //构成短暂的循环保留
        progressHUD.completionBlock = ^{
            topWindow.hidden= YES;

            if (completedBlock) {
                completedBlock();
            }
        };

    }else{
        progressHUD.completionBlock = completedBlock;
        [view addSubview:progressHUD];
    }

    //显示
    [progressHUD showAnimated:YES];

    return progressHUD;
}

MBProgressHUD * showMessage(UIView *view,NSString * titleText,NSString * detailText) {
    return showMessage_b(view, titleText, detailText, nil);
}

MBProgressHUD * showMessage_b(UIView *view,NSString *titleText,NSString * detailText,void(^completedBlock)(void))
{
    MBProgressHUD * progressHUD = showMessageWithCustomView_b(view,titleText,detailText,nil,completedBlock);
    progressHUD.mode = MBProgressHUDModeText;

    return progressHUD;
}

MBProgressHUD * showMessageWithCustomView(UIView *view,NSString *titleText,NSString * detailText,UIView * customView) {
    return  showMessageWithCustomView_b(view, titleText, detailText, customView, nil);
}

MBProgressHUD * showMessageWithCustomView_b(UIView *view,NSString *titleText,NSString * detailText,UIView * customView,void(^completedBlock)(void))
{
    MBProgressHUD * progressHUD = showCustomMBProgressHUDView(view, titleText, detailText, customView, completedBlock);
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    [progressHUD hideAnimated:YES afterDelay:1.5f];

    return progressHUD;
}

MBProgressHUD * showMessageWithImage(UIView *view,NSString *titleText,NSString * detailText,UIImage * image) {
    return showMessageWithImage_b(view, titleText, detailText, image, nil);
}

MBProgressHUD * showMessageWithImage_b(UIView *view,NSString *titleText,NSString * detailText,UIImage * image,void(^completedBlock)(void))
{
    UIImageView * imageView = image ? [[UIImageView alloc] initWithImage:image] : nil;
    return showMessageWithCustomView_b(view, titleText, detailText, imageView, completedBlock);
}

//显示错误消息
MBProgressHUD * showErrorMessage(UIView *view,NSError *error,NSString *titleText) {
    return showErrorMessage_b(view, error, titleText,nil);
}

MBProgressHUD * showErrorMessage_b(UIView *view,NSError *error,NSString *titleText,void(^completedBlock)(void)) {
    return showErrorMessage_e(view,titleText,error.localizedDescription,completedBlock);
}

MBProgressHUD * showErrorMessage_e(UIView *view,NSString *titleText,NSString *detailText,void(^completedBlock)(void)) {
    return showMessageWithImage_b(view, titleText, detailText, ImageWithName(@"error_msg.png"), completedBlock);
}

//显示成功消息
MBProgressHUD * showSuccessMessage(UIView *view,NSString *titleText,NSString * detailText) {
    return showSuccessMessage_b(view, titleText, detailText, nil);
}

MBProgressHUD * showSuccessMessage_b(UIView *view,NSString *titleText,NSString * detailText,void(^completedBlock)(void))
{
    return showMessageWithImage_b(view, titleText, detailText, ImageWithName(@"success_msg.png"), completedBlock);
}

MBProgressHUD * showHUDWithActivityIndicatorView(UIView * view,UIView<CLActivityIndicatorViewProtocol> * activityIndicatorView,NSString *title)
{
    MBProgressHUD * progressHUD = showCustomMBProgressHUDView(view, title, nil, activityIndicatorView,nil);
    progressHUD.animationType = MBProgressHUDAnimationZoom;
    progressHUD.userInteractionEnabled = YES;
    if (!view) {
        progressHUD.superview.userInteractionEnabled = YES;
    }
    [activityIndicatorView startAnimating];

    return progressHUD;
}

MBProgressHUD * showHUDWithMyActivityIndicatorView(UIView * view,UIColor *color,NSString *title)
{
    CLActivityIndicatorView * activityIndicatorView = [[CLActivityIndicatorView alloc] initWithStyle:CLActivityIndicatorViewStyleIndeterminate];
    activityIndicatorView.bounds = CGRectMake(0.f, 0.f, 30.f, 30.f);
    activityIndicatorView.twoStepAnimation = NO;
    activityIndicatorView.tintColor = color;

    return showHUDWithActivityIndicatorView(view, activityIndicatorView,title);
}

MBProgressHUD *progressIndicatorView(){
    CLActivityIndicatorView *activityIndicatorView = [[CLActivityIndicatorView alloc] initWithStyle:CLActivityIndicatorViewStyleIndeterminate] ;
    activityIndicatorView.bounds = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f) ;
    [activityIndicatorView startAnimating];
    
    return nil;
}

void showNetworkStatusMessage(UIView *view)
{
    //网络状态
    NetworkStatus status = [CLNetReachability currentNetReachabilityStatus];

    if (status == NotReachable) {
        showMessage(view, @"当前无可用网络", nil);
    }else if (status == ReachableViaWWAN){
        showMessage(view, @"当前处于蜂窝移动网络", nil);
    }else{
        showMessage(view, @"当前处于WIFI网络", nil);
    }
}

UIAlertView * showAlertView(NSString *titleText,NSString * detailText)
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:titleText
                                                         message:detailText
                                                        delegate:nil
                                               cancelButtonTitle:@"知道了"
                                               otherButtonTitles:nil];

    [alertView show];

    return alertView;
}

#pragma mark-
void checkIndexAtRange(NSUInteger index,NSRange range)
{
    if (!NSLocationInRange(index,range)) {

        @throw [[NSException alloc] initWithName:NSRangeException
                                          reason:[NSString stringWithFormat:@"index = %u 超出范围 %u ~ %u",(unsigned int)index,(unsigned int)range.location,(unsigned int)NSMaxRange(range)]
                                        userInfo:nil];
    }

}

#pragma mark -

BOOL makeSrueDirectoryExist(NSString *path)
{
    if (!path.length) {
        return NO;
    }

    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] || !isDir) {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }

    return YES;
}

#pragma amrk -

BOOL fileExistAtPath(NSString *path)
{
    if (!path.length) {
        return NO;
    }

    //文件存在且不是路径
    BOOL isDir;
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && !isDir;
}

long long fileSizeAtPath(NSString *filePath)
{
    if (filePath.length) {

        BOOL isDir;
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir){
            return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        }
    }

    return 0;
}

long long folderSizeAtPath(NSString *folderPath)
{
    //1.判断路径所指定的类型
    //2.遍历所有子路径计算大小

    BOOL isDir;
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath isDirectory:&isDir]){
        return 0;
    }else if (!isDir){
        return [[manager attributesOfItemAtPath:folderPath error:nil] fileSize];
    }

    //遍历子路径
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];

    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        //完整路径
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += fileSizeAtPath(fileAbsolutePath);
    }

    return folderSize;
}

void folderSizeAtPath_asyn(NSString *folderPath, void (^completeBlock)(long long))
{
    if (completeBlock) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            long long resultSize = folderSizeAtPath(folderPath);

            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(resultSize);
            });
        });
    }
}

BOOL removeItemAtPath(NSString * path,BOOL onlyRemoveFile)
{
    BOOL isDir;
    NSFileManager* manager = [NSFileManager defaultManager];

    if (![manager fileExistsAtPath:path isDirectory:&isDir]){
        return NO;
    }else if (!isDir || !onlyRemoveFile){
        return [manager removeItemAtPath:path error:nil];
    }else{

        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:path] objectEnumerator];

        NSString * fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil) {

            NSString * fileAbsolutePath = [path stringByAppendingPathComponent:fileName];

            if ([manager fileExistsAtPath:fileAbsolutePath isDirectory:&isDir] && !isDir) {
                [manager removeItemAtPath:fileAbsolutePath error:NULL];
            }else {
                removeItemAtPath(fileAbsolutePath, onlyRemoveFile);
            }
        }
        return YES;
    }
}


#pragma mark -

BOOL NSProtocolContainSelector(Protocol *p, SEL aSel, BOOL isRequiredMethod, BOOL isInstanceMethod)
{
    struct objc_method_description method_description = protocol_getMethodDescription(p,aSel,isRequiredMethod,isInstanceMethod);
    return method_description.name != NULL && method_description.types != NULL;
}

#pragma mark-
//手机判断
BOOL isPhoneNumber(NSString *mobileNum)
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,178,147
     * 联通：130,131,132,155,156,185,186,176,145
     * 电信：133,1349,153,180,181,189,177
     * other:170
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|7[0678]|4[57])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,163,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0-27-9]|8[2-478]|77|47)\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[56]|8[56]|76|45)\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[019]|77)[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];

    if ([regextestmobile evaluateWithObject:mobileNum]
        || [regextestcm evaluateWithObject:mobileNum]
        || [regextestct evaluateWithObject:mobileNum]
        || [regextestcu evaluateWithObject:mobileNum]){
        return YES;
    }else{
        return NO;
    }
}

//邮箱判断
BOOL isEmailAddress(NSString * email)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//整形判断
BOOL isInteger(NSString * integerStr)
{
    NSString *integerRegex = @"[0-9]+";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", integerRegex];
    return [integerTest evaluateWithObject:integerStr];
}
//SID
BOOL isSidStr(NSString *sidStr)
{
    NSString *sidStrRegex = @"SID=(.*?)";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", sidStrRegex];
    return [integerTest evaluateWithObject:sidStr];
}

//SID 匹配数组
NSArray * matchString(NSString *string)
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"SID=(.*?);" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    //match: 所有匹配到的字符,根据() 包含级
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            [array addObject:component];
        }
    }
    return array;
}

//长SID 匹配数组
NSArray * matchLongString(NSString *string)
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"SID=(.*?)," options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    //match: 所有匹配到的字符,根据() 包含级
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            [array addObject:component];
        }
    }
    return array;
}

#pragma mark - 纯数字正则
BOOL isNumberSecert(NSString *secPassword)
{
    NSString *passwordStrRegex = @"^[0-9]*$";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordStrRegex];
    return [integerTest evaluateWithObject:secPassword];
}

BOOL isSimplePwd(NSString *password)
{
    NSString *passwordStrRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordStrRegex];
    return [integerTest evaluateWithObject:password];
}
#pragma mark -- 是否升序
BOOL isAscendingPwd(NSString *password)
{
    NSString *passwordStrRegex = @"(?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)){5}\\d";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordStrRegex];
    return [integerTest evaluateWithObject:password];
}

#pragma mark - 是否降序
BOOL isDescendingPwd(NSString *password)
{
    NSString *passwordStrRegex = @"(?:9(?=8)|8(?=7)|7(?=6)|6(?=5)|5(?=4)|4(?=3)|3(?=2)|2(?=1)|1(?=0)){5}\\d";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordStrRegex];
    return [integerTest evaluateWithObject:password];
}
#pragma mark - 是否升降序
BOOL isDescendingAndPwdisAscendingPwd(NSString *password)
{
    NSString *passwordStrRegex = @"(?:(?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)){5}|(?:9(?=8)|8(?=7)|7(?=6)|6(?=5)|5(?=4)|4(?=3)|3(?=2)|2(?=1)|1(?=0)){5})\\d";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordStrRegex];
    return [integerTest evaluateWithObject:password];
}

#pragma mark -连续三个以上重复数字
BOOL isSameMoreThreePwd(NSString *password)
{
    NSString *passwordStrRegex = @"([\\d])\\1{2,}";
    NSPredicate *integerTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordStrRegex];
    return [integerTest evaluateWithObject:password];
}

NSString * dateString(NSDate * date,NSString * dateFormat)
{
    if (date == nil || dateFormat.length == 0) {
        return nil;
    }
    static NSDateFormatter * dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    }

        NSTimeZone *sourceTimeZone = [NSTimeZone systemTimeZone];
        dateFormatter.timeZone = sourceTimeZone;
        dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:date];
}
NSString * dateStringWithFormatterWithTimezone(NSDate * date,NSString * dateFormat,NSString *timezone)
{
    if (date == nil || dateFormat.length == 0) {
        return nil;
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timezone]] ;
    
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:date];
}

#pragma mark-
NSArray * indexPathsFromRange(NSInteger section,NSRange range) {
    return indexPathsFromIndexSet(section, [NSIndexSet indexSetWithIndexesInRange:range]);
}

NSArray * indexPathsFromIndexSet(NSInteger section,NSIndexSet * indexSet)
{
    NSMutableArray * indexPaths = [NSMutableArray arrayWithCapacity:indexSet.count];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [indexPaths addObject:[NSIndexPath indexPathForItem:idx inSection:section]];
    }];

    return indexPaths;
}

#pragma mark-
CGAffineTransform rotationAffineTransformForOrientation(UIInterfaceOrientation orientation)
{
    switch (orientation) {

        case UIInterfaceOrientationLandscapeRight:
            return CGAffineTransformMakeRotation(M_PI_2);
            break;

        case UIInterfaceOrientationLandscapeLeft:
            return CGAffineTransformMakeRotation(- M_PI_2);
            break;

        case UIInterfaceOrientationPortraitUpsideDown:
            return CGAffineTransformMakeRotation(M_PI);
            break;

        default:
            return CGAffineTransformIdentity;
            break;
    }
}

#pragma mark-

NSString * appStoreURL(NSString * appID) {
    return [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",appID];
}

NSString * appStoreHTTPURL(NSString * appID) {
    return [NSString  stringWithFormat: @"http://itunes.apple.com/cn/app/id%@?mt=8",appID];
}

void gotoAppStore(NSString * appID) {
    openURL(appStoreURL(appID));
}

BOOL openURL(NSString * url)
{
    NSURL * _url = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if (_url && [[UIApplication sharedApplication] openURL:_url]) {
        return YES;
    }

    return NO;
}

//BOOL isIgnoreHTTPS(NSString *domain)
//{
//    for (NSString * ignoreStr in RH_IgnoreHTTPS_LIST) {
//        if ([domain containsString:ignoreStr])
//            return TRUE ;
//    }
//    return FALSE ;
//}

#pragma mark--获取 设备 ip address
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
//#import "RH_Crash.h"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

BOOL isValidatIP(NSString * ipAddress)
{
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"__%@",result);
//            RH_Crash *crash = [[RH_Crash alloc]init];
//            crash.ipStr = result;
            return YES;
        }
    }
    return NO;
}

NSDictionary * getIPAddresses()
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


NSString *getIPAddress(BOOL preferIPv4)
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = getIPAddresses() ;
    NSLog(@"addresses: %@", addresses);
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
    {
         address = addresses[key];
         //筛选出IP地址格式
         if(isValidatIP(address)) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

NSString *getLocalizedString(CLLanguageOption languageOption,NSString* key)
{
    NSString *keyPath = nil ;
    switch (languageOption) {
        case CLLanguageOptionZHhans:
            keyPath = @"zh-Hans" ;
            break;
        
        case CLLanguageOptionZHhant:
            keyPath = @"zh-Hant" ;
            break;
        
        case CLLanguageOptionEnglish:
            keyPath = @"en" ;
            break;
        
        case CLLanguageOptionJapanese:
            keyPath = @"ja" ;
            break;
            
        default:
            keyPath = @"zh-Hant" ;
            break;
    }
    
    return [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:keyPath ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"language"] ;
}

