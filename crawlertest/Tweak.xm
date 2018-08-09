

%hook AddFriendEntryViewController

- (void)viewDidAppear:(BOOL)arg1
{
    %orig;

    NSInteger x = arc4random() % 10;
    [self performSelector:@selector(getInputNumber) withObject:nil afterDelay:x];
}  


%new
- (void)getInputNumber
{
    id searchView = [self valueForKey:@"m_headerSearchView"];
    [(UIResponder *)searchView becomeFirstResponder];
}

%end


%hook MMSearchBar

- (_Bool)searchBarShouldBeginEditing:(id)arg1
{
    %orig;
    
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

                NSString *txtPath = [docPath stringByAppendingPathComponent:@"objc.txt"]; // 此时仅存在路径，文件并没有真实存在
                NSString *string = phoneStr;
                //字符串写入时执行的方法
                [string writeToFile:txtPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

                //写入数据
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

%new
- (void)writeToFile:(NSString *)phoneNum
{
    //先取出来，再写进去一个
    NSArray *readArr = [self performSelector:@selector(read) withObject:nil];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:readArr];
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
    [[NSFileManager defaultManager] createFileAtPath:plistPath contents:nil attributes:nil];
    [arr addObject:phoneNum];
    //[[arr copy] writeToFile:plistPath atomically:YES];
    [arr writeToFile:plistPath atomically:YES];
    
    NSLog(@"--------------------写入数据--------------");
    
}

%new
- (NSArray *)read
{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
    NSArray *datas0 = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *datas = [NSMutableArray arrayWithArray:datas0];
    NSLog(@"----rrrrrr--%@", datas);
    return datas;
}



%end



%hook MMTableViewInfo
- (id)tableView:(id)arg1 titleForFooterInSection:(long long)arg2
{
    %orig;
   
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
                                        //字符串写入时执行的方法
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

%end


%hook ContactInfoViewController

- (void)viewDidAppear:(_Bool)arg1
{
    %orig;


     id  m_contact = [self valueForKeyPath:@"m_contact"];

    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];

    //取出手机号
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *txtPath = [docPath stringByAppendingPathComponent:@"objc.txt"];
    NSString *resultStr = [NSString stringWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];


    //取出头像
    NSString *urlPath = [docPath stringByAppendingPathComponent:@"urlStr.txt"];
    NSString *urlResultStr = [NSString stringWithContentsOfFile:urlPath encoding:NSUTF8StringEncoding error:nil];

    NSString *phone = resultStr;
    if (phone.length > 0)
    {
        //手机号
        [dic3 setObject:phone forKey:@"Contact_Search_Mobile"];
    }

    NSString *urlPic = urlResultStr;
    if (urlPic.length > 0)
    {
        //头像
        [dic3 setObject:urlPic forKey:@"Contact_Header"];
    }


    //个性签名
    NSString *signatureStr = [m_contact valueForKey:@"m_nsSignature"];
    if (signatureStr.length > 0)
    {
        [dic3 setObject:signatureStr forKey:@"Contact_Signature"];
    }
   

   //地区
    NSString *country = [m_contact valueForKey:@"m_nsCountry"] ? [m_contact valueForKey:@"m_nsCountry"] : @"";
    NSString *province = [m_contact valueForKey:@"m_nsProvince"];
    province = province.length > 0 ? [NSString stringWithFormat:@"_%@",[m_contact valueForKey:@"m_nsProvince"]] : @"";
    NSString *city = [m_contact valueForKey:@"m_nsCity"] ;
    city = city.length > 0 ? [NSString stringWithFormat:@"_%@",[m_contact valueForKey:@"m_nsCity"]] : @"";
    NSString *regionStr = [NSString stringWithFormat:@"%@%@%@", country, province, city];
    

   [dic3 setObject:regionStr forKey:@"Contact_RegionCode"];

    // 昵称
    [dic3 setObject:[m_contact valueForKey:@"m_nsNickName"] forKey:@"Contact_Nick"];
    //性别
    [dic3 setObject:[m_contact valueForKey:@"m_uiSex"]  forKey:@"Contact_Sex"];

    //微信号
    [dic3 setObject:[m_contact valueForKey:@"m_nsAliasName"]  forKey:@"Contact_Alias"];

    //用户ID
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

    //----------
    //先把手机号读出来
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];
    NSArray *datas0 = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *datas = [NSMutableArray arrayWithArray:datas0];

    
    if (datas.count > 1)
    {
        //数组元素 大于1 则有用户不存在的
        [datas enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:phone])
            {
                //用户存在
                NSLog(@"--0000--上传服务器");
                [self performSelector:@selector(_postData:) withObject:data];
            }
            else
            {
                //用户不存在
                NSLog(@"---1111-上传服务器");
                //去除手机号
                //noBindingList
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
        
        //删除所有数据
        [datas removeAllObjects];
        NSString *filePath2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *plistPath2 = [filePath2 stringByAppendingPathComponent:@"test.plist"];
        
        [[NSFileManager defaultManager] removeItemAtPath:plistPath2 error:nil];
    }
    else
    {
        //用户存在
        NSLog(@"--0000--上传服务器");
        [self performSelector:@selector(_postData:) withObject:data];
        //删除所有数据
        [datas removeAllObjects];
        NSString *filePath2 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *plistPath2 = [filePath2 stringByAppendingPathComponent:@"test.plist"];
        
        [[NSFileManager defaultManager] removeItemAtPath:plistPath2 error:nil];
        
    }


    //删除子文件夹
    NSError *error = nil;
    NSString *docPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *txtPath2 = [docPath2 stringByAppendingPathComponent:@"objc.txt"];
    [[NSFileManager defaultManager] removeItemAtPath:txtPath2 error:&error];
    
    NSString *urlPath2 = [docPath2 stringByAppendingPathComponent:@"urlStr.txt"];
    [[NSFileManager defaultManager] removeItemAtPath:urlPath2 error:&error];

    [self performSelector:@selector(_back) withObject:nil afterDelay:5];

}


%new
- (void)_postData:(NSData *)data
{
    //上传数据
    //线上
    NSURL *url = [NSURL URLWithString:@"http://10.21.131.12:9999/spider/tasklog/push"];
    //测试
    //NSURL *url = [NSURL URLWithString:@"http://192.168.103.74:9999/spider/tasklog/push"];
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
    
    //开始网络任务
    [dataTask resume];
}

%new
- (void)_back
{
    
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

%end























