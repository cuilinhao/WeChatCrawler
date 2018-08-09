# WeChatCrawler
微信爬虫，
实现自动化输入手机号，然后通过手机号获取微信号，以及头像，昵称等
核心代码如下：

>>>>>>>> 搜索   >>>>>>>>>>>

%hook MMSearchBar

- (_Bool)searchBarShouldBeginEditing:(id)arg1
{
    %orig;
    
    if (phoneStr && phoneStr.length > 0)
      {
          id m_searchBar = [self valueForKey:@"m_searchBar"];
          [m_searchBar setValue:phoneStr forKey:@"text"];
          [self performSelector:@selector(searchBarSearchButtonClicked:) withObject:nil afterDelay:0];
      }
      else
      {
          NSLog(@"--phone number response error: %@", phoneStr);
      }
      
      
 }
            
            
 %end
 
 >>>>>>>>>> 获取微信号 >>>>>>>>>>>>>
 
 %hook ContactInfoViewController

- (void)viewDidAppear:(_Bool)arg1
{
    %orig;
    id  m_contact = [self valueForKeyPath:@"m_contact"];
    
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


}

%end

            
            
