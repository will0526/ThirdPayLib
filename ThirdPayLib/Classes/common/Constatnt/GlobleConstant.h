/*!
 
 @header   TipInfoConstant.h
 @abstract IOSTempleteProject   
 @author   will
 @version  1.0  14-1-24 Creation
 
 */

#ifndef GlobleConstant_h
#define GlobleConstant_h

//===============================================================================


typedef enum {
    BOXTYPE_PAX,
    BOXTYPE_NEWLAND,
    BOXTYPE_LANDI,
    BOXTYPE_SUNYARD
}BOXTYPE;


#pragma mark ----------------------------- 分页默认配置

#define kDefaultStartPage           (0)
#define kDefaultPageSize            (10)

#pragma mark ----------------------------- 系统控件默认尺寸

#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)

#define NAV_WIDTH                   SCREEN_WIDTH
#define NAV_HEIGHT                  (44)

#define TAB_BAR_WIDTH               SCREEN_WIDTH
#define TAB_BAR_HEIGHT              (48)

#define STATUS_BAR_HEIGHT           (20)
#define MESSAGE_COUNTDOWN        60
#endif
