#line 1 "Tweak.xm"



#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class MMTableViewInfo; @class ContactInfoViewController; @class AddFriendEntryViewController; @class MMSearchBar; 
static void (*_logos_orig$_ungrouped$AddFriendEntryViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL AddFriendEntryViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$AddFriendEntryViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL AddFriendEntryViewController* _LOGOS_SELF_CONST, SEL, BOOL); static void _logos_method$_ungrouped$AddFriendEntryViewController$getInputNumber(_LOGOS_SELF_TYPE_NORMAL AddFriendEntryViewController* _LOGOS_SELF_CONST, SEL); static _Bool (*_logos_orig$_ungrouped$MMSearchBar$searchBarShouldBeginEditing$)(_LOGOS_SELF_TYPE_NORMAL MMSearchBar* _LOGOS_SELF_CONST, SEL, id); static _Bool _logos_method$_ungrouped$MMSearchBar$searchBarShouldBeginEditing$(_LOGOS_SELF_TYPE_NORMAL MMSearchBar* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$MMSearchBar$writeToFile$(_LOGOS_SELF_TYPE_NORMAL MMSearchBar* _LOGOS_SELF_CONST, SEL, NSString *); static NSArray * _logos_method$_ungrouped$MMSearchBar$read(_LOGOS_SELF_TYPE_NORMAL MMSearchBar* _LOGOS_SELF_CONST, SEL); static id (*_logos_orig$_ungrouped$MMTableViewInfo$tableView$titleForFooterInSection$)(_LOGOS_SELF_TYPE_NORMAL MMTableViewInfo* _LOGOS_SELF_CONST, SEL, id, long long); static id _logos_method$_ungrouped$MMTableViewInfo$tableView$titleForFooterInSection$(_LOGOS_SELF_TYPE_NORMAL MMTableViewInfo* _LOGOS_SELF_CONST, SEL, id, long long); static void (*_logos_orig$_ungrouped$ContactInfoViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL ContactInfoViewController* _LOGOS_SELF_CONST, SEL, _Bool); static void _logos_method$_ungrouped$ContactInfoViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL ContactInfoViewController* _LOGOS_SELF_CONST, SEL, _Bool); static void _logos_method$_ungrouped$ContactInfoViewController$_postData$(_LOGOS_SELF_TYPE_NORMAL ContactInfoViewController* _LOGOS_SELF_CONST, SEL, NSData *); static void _logos_method$_ungrouped$ContactInfoViewController$_back(_LOGOS_SELF_TYPE_NORMAL ContactInfoViewController* _LOGOS_SELF_CONST, SEL); 

#line 3 "Tweak.xm"



static void _logos_method$_ungrouped$AddFriendEntryViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL AddFriendEntryViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
    _logos_orig$_ungrouped$AddFriendEntryViewController$viewDidAppear$(self, _cmd, arg1);

    NSInteger x = arc4random() % 10;
    [self performSelector:@selector(getInputNumber) withObject:nil afterDelay:x];
}  




static void _logos_method$_ungrouped$AddFriendEntryViewController$getInputNumber(_LOGOS_SELF_TYPE_NORMAL AddFriendEntryViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    id searchView = [self valueForKey:@"m_headerSearchView"];
    [(UIResponder *)searchView becomeFirstResponder];
}







static _Bool _logos_method$_ungrouped$MMSearchBar$searchBarShouldBeginEditing$(_LOGOS_SELF_TYPE_NORMAL MMSearchBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    _logos_orig$_ungrouped$MMSearchBar$searchBarShouldBeginEditing$(self, _cmd, arg1);
    
    NSURL *url = [NSURL URLWithString:@"http://10.21.131.12:9999/spider/taskseed/pull?size=1&needremove=false"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 60;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error)
        {
            NSLog(@"请求出错:%@", error);
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSError *jsonError = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError)
            {
                NSLog(@"JSONSerialization Error: %@", jsonError);
                return;
            }

            NSString *phoneStr = nil;
            if ([json isKindOfClass:[NSDictionary class]])
            {
                NSArray *dataArray =  [json valueForKey:@"seeds"];

                 phoneStr = [dataArray firstObject];
            }


            if (phoneStr && phoneStr.length > 0)
            {
                id m_searchBar = [self valueForKey:@"m_searchBar"];
                [m_searchBar setValue:phoneStr forKey:@"text"];

                NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

                NSString *txtPath = [docPath stringByAppendingPathComponent:@"objc.txt"]; 
                NSString *string = phoneStr;
                
                [string writeToFile:txtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

                
                [self performSelector:@selector(writeToFile:) withObject:phoneStr afterDelay:0];

                [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:nil afterDelay:0];
            }
            else
            {
                NSLog(@"--phone number response error: %@", phoneStr);
            }
        });

    }];

    [dataTask resume];

    return YES;
}



static void _logos_method$_ungrouped$MMSearchBar$writeToFile$(_LOGOS_SELF_TYPE_NORMAL MMSearchBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSString * phoneNum) {
    
    NSArray *readArr = [self performSelector:@selector(read) withObject:nil];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:readArr];
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
    [[NSFileManager defaultManager] createFileAtPath:plistPath contents:nil attributes:nil];
    [arr addObject:phoneNum];
    
    [arr writeToFile:plistPath atomically:YES];
    
    NSLog(@"--------------------写入数据--------------");
    
}



static NSArray * _logos_method$_ungrouped$MMSearchBar$read(_LOGOS_SELF_TYPE_NORMAL MMSearchBar* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
    NSArray *datas0 = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *datas = [NSMutableArray arrayWithArray:datas0];
    NSLog(@"----rrrrrr--%@", datas);
    return datas;
}









static id _logos_method$_ungrouped$MMTableViewInfo$tableView$titleForFooterInSection$(_LOGOS_SELF_TYPE_NORMAL MMTableViewInfo* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1, long long arg2) {
    _logos_orig$_ungrouped$MMTableViewInfo$tableView$titleForFooterInSection$(self, _cmd, arg1, arg2);
   
    if (arg2 == 2)
    {
        
        [[arg1 subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
                [[obj subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:NSClassFromString(@"UITableViewCell")])
                    {   
                        [[obj subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) 
                            {
                                [[obj subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

                                     if ([obj isKindOfClass:NSClassFromString(@"MMHeadImageView")])
                                    {
                                        NSString * urlStr = [obj valueForKeyPath:@"_nsHeadImgUrl"];
                                       
                                         NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

                                        NSString *txtPath = [docPath stringByAppendingPathComponent:@"urlStr.txt"]; 
                                        NSString *string = urlStr;
                                        
                                        [string writeToFile:txtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
                                    }
                                }];

                            }
                        }];
                    }
                }];
            }
        }];
    }

     return @"1232";
}







static void _logos_method$_ungrouped$ContactInfoViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL ContactInfoViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, _Bool arg1) {
    _logos_orig$_ungrouped$ContactInfoViewController$viewDidAppear$(self, _cmd, arg1);


     id  m_contact = [self valueForKeyPath:@"m_contact"];

    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];

    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *txtPath = [docPath stringByAppendingPathComponent:@"objc.txt"];
    NSString *resultStr = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];


    
    NSString *urlPath = [docPath stringByAppendingPathComponent:@"urlStr.txt"];
    NSString *urlResultStr = [NSString stringWithContentsOfFile:urlPath encoding:NSUTF8StringEncoding error:nil];

    NSString *phone = resultStr;
    if (phone.length > 0)
    {
        
        [dic3 setObject:phone forKey:@"Contact_Search_Mobile"];
    }

    NSString *urlPic = urlResultStr;
    if (urlPic.length > 0)
    {
        
        [dic3 setObject:urlPic forKey:@"Contact_Header"];
    }


    
    NSString *signatureStr = [m_contact valueForKey:@"m_nsSignature"];
    if (signatureStr.length > 0)
    {
        [dic3 setObject:signatureStr forKey:@"Contact_Signature"];
    }
   

   
    NSString *country = [m_contact valueForKey:@"m_nsCountry"] ? [m_contact valueForKey:@"m_nsCountry"] : @"";
    NSString *province = [m_contact valueForKey:@"m_nsProvince"];
    province = province.length > 0 ? [NSString stringWithFormat:@"_%@",[m_contact valueForKey:@"m_nsProvince"]] : @"";
    NSString *city = [m_contact valueForKey:@"m_nsCity"] ;
    city = city.length > 0 ? [NSString stringWithFormat:@"_%@",[m_contact valueForKey:@"m_nsCity"]] : @"";
    NSString *regionStr = [NSString stringWithFormat:@"%@%@%@", country, province, city];
    

   [dic3 setObject:regionStr forKey:@"Contact_RegionCode"];

    
    [dic3 setObject:[m_contact valueForKey:@"m_nsNickName"] forKey:@"Contact_Nick"];
    
    [dic3 setObject:[m_contact valueForKey:@"m_uiSex"]  forKey:@"Contact_Sex"];

    
    [dic3 setObject:[m_contact valueForKey:@"m_nsAliasName"]  forKey:@"Contact_Alias"];

    
    [dic3 setObject:[m_contact valueForKey:@"m_nsUsrName"]  forKey:@"Contact_User"];

    if (phone.length > 0)
    {
        [dic2 setObject:dic3 forKey:phone];
    }

    [dic2 setObject:@"TASK_CHESS_IOS_TEST_20180807" forKey:@"taskName"];

    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dic2 options:0 error:nil];
    NSString *ss = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];

    [dic1 setObject:ss forKey:@"data"];
    NSLog(@"-------dic1----%@", dic1);
    

    NSData *data = [NSJSONSerialization dataWithJSONObject:dic1 options:0 error:nil];

    
    
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
    NSArray *datas0 = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *datas = [NSMutableArray arrayWithArray:datas0];

    
    if (datas.count > 1)
    {
        
        [datas enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:phone])
            {
                
                NSLog(@"--0000--上传服务器");
                [self performSelector:@selector(_postData:) withObject:data];
            }
            else
            {
                
                NSLog(@"---1111-上传服务器");
                
                
                NSMutableArray *phoneArray = [NSMutableArray array];
                [phoneArray addObject:obj];

                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];

                [dic setObject:phoneArray forKey:@"noBindingList"];

                NSData *JSONData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
                NSString *ss = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
                
                [dic1 setObject:ss forKey:@"data"];
                NSData *nobingData = [NSJSONSerialization dataWithJSONObject:dic1 options:0 error:nil];

                [self performSelector:@selector(_postData:) withObject:nobingData];
            }
        }];
        
        
        [datas removeAllObjects];
        NSString *filePath2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *plistPath2 = [filePath2 stringByAppendingPathComponent:@"test.plist"];
        
        [[NSFileManager defaultManager] removeItemAtPath:plistPath2 error:nil];
    }
    else
    {
        
        NSLog(@"--0000--上传服务器");
        [self performSelector:@selector(_postData:) withObject:data];
        
        [datas removeAllObjects];
        NSString *filePath2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *plistPath2 = [filePath2 stringByAppendingPathComponent:@"test.plist"];
        
        [[NSFileManager defaultManager] removeItemAtPath:plistPath2 error:nil];
        
    }


    
    NSError *error = nil;
    NSString *docPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *txtPath2 = [docPath2 stringByAppendingPathComponent:@"objc.txt"];
    [[NSFileManager defaultManager] removeItemAtPath:txtPath2 error:&error];
    
    NSString *urlPath2 = [docPath2 stringByAppendingPathComponent:@"urlStr.txt"];
    [[NSFileManager defaultManager] removeItemAtPath:urlPath2 error:&error];

    [self performSelector:@selector(_back) withObject:nil afterDelay:5];

}




static void _logos_method$_ungrouped$ContactInfoViewController$_postData$(_LOGOS_SELF_TYPE_NORMAL ContactInfoViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSData * data) {
    
    
    NSURL *url = [NSURL URLWithString:@"http://10.21.131.12:9999/spider/tasklog/push"];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 60;
    
    NSString *contentType = [NSString stringWithFormat:@"application/json"];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:contentType forHTTPHeaderField:@"Accept"];
    
    NSLog(@"Successfully serialized the dictionary into data.");

    [request setHTTPBody:data];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"------上传数据成功");
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"状态码:%ld", (long)[httpResponse statusCode]);
    }];
    
    
    [dataTask resume];
}



static void _logos_method$_ungrouped$ContactInfoViewController$_back(_LOGOS_SELF_TYPE_NORMAL ContactInfoViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    
    id rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    if ([rootVC isKindOfClass:NSClassFromString(@"MainTabBarViewController")])
    {
        id vc = [[rootVC viewControllers] firstObject];
        [vc popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"----555----%@", rootVC);
    }
}

























static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$AddFriendEntryViewController = objc_getClass("AddFriendEntryViewController"); MSHookMessageEx(_logos_class$_ungrouped$AddFriendEntryViewController, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$AddFriendEntryViewController$viewDidAppear$, (IMP*)&_logos_orig$_ungrouped$AddFriendEntryViewController$viewDidAppear$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$AddFriendEntryViewController, @selector(getInputNumber), (IMP)&_logos_method$_ungrouped$AddFriendEntryViewController$getInputNumber, _typeEncoding); }Class _logos_class$_ungrouped$MMSearchBar = objc_getClass("MMSearchBar"); MSHookMessageEx(_logos_class$_ungrouped$MMSearchBar, @selector(searchBarShouldBeginEditing:), (IMP)&_logos_method$_ungrouped$MMSearchBar$searchBarShouldBeginEditing$, (IMP*)&_logos_orig$_ungrouped$MMSearchBar$searchBarShouldBeginEditing$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString *), strlen(@encode(NSString *))); i += strlen(@encode(NSString *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MMSearchBar, @selector(writeToFile:), (IMP)&_logos_method$_ungrouped$MMSearchBar$writeToFile$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSArray *), strlen(@encode(NSArray *))); i += strlen(@encode(NSArray *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$MMSearchBar, @selector(read), (IMP)&_logos_method$_ungrouped$MMSearchBar$read, _typeEncoding); }Class _logos_class$_ungrouped$MMTableViewInfo = objc_getClass("MMTableViewInfo"); MSHookMessageEx(_logos_class$_ungrouped$MMTableViewInfo, @selector(tableView:titleForFooterInSection:), (IMP)&_logos_method$_ungrouped$MMTableViewInfo$tableView$titleForFooterInSection$, (IMP*)&_logos_orig$_ungrouped$MMTableViewInfo$tableView$titleForFooterInSection$);Class _logos_class$_ungrouped$ContactInfoViewController = objc_getClass("ContactInfoViewController"); MSHookMessageEx(_logos_class$_ungrouped$ContactInfoViewController, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$ContactInfoViewController$viewDidAppear$, (IMP*)&_logos_orig$_ungrouped$ContactInfoViewController$viewDidAppear$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSData *), strlen(@encode(NSData *))); i += strlen(@encode(NSData *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$ContactInfoViewController, @selector(_postData:), (IMP)&_logos_method$_ungrouped$ContactInfoViewController$_postData$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$ContactInfoViewController, @selector(_back), (IMP)&_logos_method$_ungrouped$ContactInfoViewController$_back, _typeEncoding); }} }
#line 404 "Tweak.xm"
