

#ifndef EnvironmentConfig_h

#define EnvironmentConfig_h

//#define kRelease 1
#define kDevelop 1



//显示版本号
//测试环境
#ifdef kRelease

#define DDLog(string, object) 



//===============================================================================

//#define __IPHONE_9_0 90000
#elif kDevelop

#define RSAKEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdt/JhIxl43udV0yXvFOSC/BMP5eZ7yGlj+sL5jGNtbx+X2WZdVDaBODA81vrXdZIEnPnKIKOKBFznj0J1XJ5R70a042RroPPt5dqVuA6duJbwOzpIhTbA5JTA4QrszzivsKEPLJWti+oDzMY/YBfgZlpmIz53UXyltJStfiYEYQIDAQAB--"

#define RSAPRIVATE @"MIICXgIBAAKBgQC7v7KUibAVio9bcZnrc5/CabMKY9zhwUV5tFKzeSrqZc8dDEq/X5EAU3PuKVfV2YwcB+Irr7qbkvkr4v8hZ2Tckl2I4+V/8yYnb+cN40ugCjfuDrW3feFT0FJ10H4DVCENol2mHdlsuDfdaDaGElwabs+iFzPUKzJ5cXxEHhE2IwIDAQABAoGBAIdPIOTsVnsv4SGGPefy7LCwfNiAIDCTmf6cdv3h1YwY06ubsEM8HMSfYG3EXglBQDjzdY0GmPaGdg2rCzSHz6fqHBUXHPSbK8jPdrxFPNLSSjnCHewDnsl9mR1O3Lgezw5TJp72leGgopwdVi4onWH4MI1s8mvpcSlHIJ3tLPgBAkEA80r7nuRqAF8/35Ftv9rGdTe5i8kcF9W1pmqXIPqv4KTeTG6OI+CgqS98W4YsItoFpuHdPh4d6j9Jrz/KRxvUWQJBAMWOC/OP8C5D7ziTTqSE1rmc7l/CuyFNzS+dfbA9N7mEQ/aZ1ekI+CoREZ0REcpUPDVxjeFpLRVuk1sogLPdPtsCQQCYLaHAHH2VZ/7K9+tfIxgZv9ZmclAJNJrf0jJf5Y5XhKirxEdSd7HmwZYWpZE754W7gfHiZfIuUJHldZAv9F9ZAkBceQpFH0pJDcmrjOCSCBBO4BOAxbE8fKOgNzM/TNiJwUzi4M2NgIJRhp3dDMFsGRP53EaSjd3pm1HkqMfd6aFjAkEAi86FneZ/uNlb98DL8w2sRVqpBehuiQnbhgybovVSWhGqg4vL82+Exx8obTaUMwVUKC3hWZ/auweVVQQnb1a4bA=="
#define VERSION @"1.0.0"//APP版本
#define APIVER @"1.0"//api版本

#define DDLog(string, object) NSLog(@"%@..........%@",string,object)

#define BASEURL @"https://ipp.pnrtec.com/front/gateway/sdk/interface.json"//URL
#define SALT @"fTWFH3QRH7gSs3DE"



#endif

#endif




