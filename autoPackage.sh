# !!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!
# 注意 以下站点使用tanka证书打包
# 打完包以后不要留在sites_list数组里面
# 非常重要
# 'lcat^7002^blue^666棋牌'  \
# !!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!


sites_list=(\
    # '7wt3^18^ching^宏图棋牌'  \
    # 'ojzk^7000^ching^宏图棋牌'  \
	# 'ty3a^7001^purple^宏图棋牌'  \
    # 'ou2t^7003^blue^和记棋牌'  \
    # 'ksul^7005^blue^开元棋牌'  \
    # 'cilz^7006^blue^亿发娱乐'  \
    # 'kezf^7007^blue^九发棋牌'  \
    # 'grk9^7008^ching^安博棋牌'  \
    # '4l76^7010^blue^盛大棋牌'  \
    # '3twr^7012^blue^万豪国际'  \
    # '5th9^7009^blue^超人对决'  \
    # 'uxct^7011^blue^三宝棋牌'  \
    # 'au35^7013^blue^五元棋牌'  \
    'jbwk^7017^blue^黑桃棋牌'  \
    # '6l8b^7015^blue^三国棋牌'  \
    # 'kxai^7016^blue^欢乐棋牌'  \
    # 'n6tj^7018^blue^开元棋牌'  \
)

version='1.0.0' #app版本
scheme='GameBox'
shell_path=$(cd "$(dirname "$0")";pwd) #脚本文件路径
uplevel_path=${shell_path%/*} #获取到脚本文件上层路径

cd ${shell_path}

for siteInfo in "${sites_list[@]}"; do
	code=${siteInfo%%^*}        #取code
 	appname=${siteInfo##*^}     #取app显示名称
    sid=${siteInfo#*${code}^}   #取sid
    sid=${sid%%^*}
    theme=${siteInfo#*${sid}^}
    theme=${theme%%^*}
    echo "code :"${code}
  	echo "sid :"${sid}
    echo "appname :"${appname}
    echo "themeColor :"${theme}
    echo "======================"
    #更改sid配置文件
    echo ${sid} > "${shell_path}/sid"
    #更改themeFile配置文件
    echo ${theme} > "${shell_path}/themeFile"
    #替换配置文件的第12行
    sed -i '' "12c\\
    #define _${code} 1
    " ${shell_path}/GameBox/SitesConfig.h
    echo ">>开始打包"
    fastlane inHouse app_name:${appname} sid:${sid} scheme:${scheme} uplevel_path:${uplevel_path} code:${code} version:${version} #打包
    echo ">>打包完毕"
    echo ">>生成plist文件"
    plsitUrl="https://gbboss.com:1344/boss-api/app/package/createPlist.html?siteId=$sid&version=$version"
    http_code=$(curl -I -m 10 -o /dev/null -s -w %{http_code} ${plsitUrl})
    if [[ $http_code -eq 200 ]]; then
        plistResponse=$(curl -s ${plsitUrl})
        echo $plistResponse | jq -r .[0].plistStr > ${uplevel_path}/pkgs/${code}/app_${code}_${version}.plist
        echo "plist文件生成完毕"
    else
        echo ">>>package/createPlist.html访问失败 httpcode:${http_code}"
    fi
done

echo end
