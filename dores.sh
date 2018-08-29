# !/bin/sh
#  dores.sh
#  gameBoxEx
#
#  Created by Shin on 2018/6/2.
#  Copyright © 2018年 Shin. All rights reserved.
# 将对应SID的资源打包，避免ipa过大

#根据SID配置文件决定需要使用的资源
#读取sid的配置

 project_path=$(cd "$(dirname "$0")";pwd) #工程文件夹路径
cat "${project_path}/sid" | while read line
do
  echo ${line}
  sid=${line} #取sid value
  echo "sid:${sid}"
  all_res_path="${project_path}/icon" #存放所有渠道icon的路径
  assets_path="${project_path}/GameBox/Assets.xcassets" #工程中Assets文件夹的路径
  temp_icon_json_path="${project_path}/temp_json_file" #icon的Contents.json模板路径


  echo "${all_res_path}"
  echo "====="


  for fileDir in "${assets_path}"/*; do
      AppIconFolder=${fileDir##*/} #截取得到sid文件夹名称
      AppIconName=${AppIconFolder%%.*}
      if [[ ${AppIconName} == "AppIcon" ]]; then
        #删除现有icon资源
echo "删除成功 == ${fileDir}"
        rm -r ${fileDir}
      fi
  done

  for fileDir in "${all_res_path}"/*; do
     folder=${fileDir##*/} #截取得到sid文件夹名称
     if [[ ${folder} == ${sid} ]]; then
         #找到需要替换的sid资源目录
       for file in "${fileDir}"/*; do
        picType=${file##*.}
#        更换logo
       if [[ ${picType} == "webp" ]]; then
       cp -f "${file}"  "${project_path}/logo"
       fi
done    
       # 将新的图片资源更换上去
         # 替换icon
        #去assets_path创建一个新的icon sid目录
         #AppIcon.appiconset
         cd ${assets_path}
         mkdir "AppIcon.appiconset"

         #将icon图片copy到新建的appiconset目录
         cd ${fileDir}
         cp -f "app_icon_${sid}_120x120.png" "${assets_path}/AppIcon.appiconset"
         cp -f "app_icon_${sid}_180x180.png" "${assets_path}/AppIcon.appiconset"

         #将icon的Contents.json模板拷贝到appiconset目录
         cd ${temp_icon_json_path}
         cp "icon_Contents.json" "Contents.json"
         mv "Contents.json" "${assets_path}/AppIcon.appiconset"
         #将"filename" : "app_icon_120x120.png" | "app_icon_180x180.png" 替换成对应的值
         cd "${assets_path}/AppIcon.appiconset"
         sed 's/app_icon_120x120.png/app_icon_'${sid}'_120x120.png/g' Contents.json > Contents.json.tmp
         mv Contents.json.tmp Contents.json
         sed 's/app_icon_180x180.png/app_icon_'${sid}'_180x180.png/g' Contents.json > Contents.json.tmp
         mv Contents.json.tmp Contents.json

     fi
  done
done


cat "${project_path}/themeFile" | while read line1
do
  #更换主题文件 webp png json music
  #todo
  theme=${line1} #读取主题文件里面的theme
  themeGroup="${project_path}/themeGroup" #存放当前皮肤的路径
  all_theme="${project_path}/theme" #存放所有皮肤的路径
   assetsPath="${project_path}/GameBox/Assets.xcassets" #工程中Assets文件夹的路径
    for fileDir in "${all_theme}"/*; do
         folder=${fileDir##*/}
     if [[ ${folder} == ${theme} ]]; then
       for file in "${fileDir}"/*; do
        picType=${file##*.}
       if [[ ${picType} == "png" ]]; then
        picName=${file##*/}
        picName=${picName%%@*}
       cp -f "${file}"  "${assetsPath}/${picName}.imageset"
       else
       cp -f "${file}"  "${themeGroup}"
       fi
done
     fi
  done

  done

