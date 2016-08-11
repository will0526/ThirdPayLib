/*!
 
 @header   SystemInfo.h
 @abstract IOSTempleteProject
 @author   will
 @version  1.0  14-2-10 Creation
 
 */

#ifndef SuningEBuy_IPAddress_h
#define SuningEBuy_IPAddress_h


#define MAXADDRS     32

extern char *if_names[MAXADDRS];

extern char *ip_names[MAXADDRS];

extern char *hw_addrs[MAXADDRS];

extern unsigned long ip_addrs[MAXADDRS];


void InitAddresses(void);

void FreeAddresses(void);

void GetIPAddresses(void);

void GetHWAddresses(void);


#endif
