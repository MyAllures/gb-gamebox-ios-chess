sites_list=(\
    '7wt3^18^宏图棋牌'  \
    'ojzk^7000^宏图棋牌'  \
	'ty3a^7001^宏图棋牌'  \
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
    echo "code :"${code}
  	echo "sid :"${sid}
    echo "appname :"${appname}
    echo "======================"
    #更改sid配置文件
    echo ${sid} > "${shell_path}/sid"
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
