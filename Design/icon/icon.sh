#!/bin/sh

# # 更新所有图标

# # 原始图片
# verson="1024.png"
# # 保存的文件夹，项目的路径
# folder="/Users/myron/Myron/Project/MyApp/Daily/Daily/Resources/Assets.xcassets/AppIcon.appiconset"

# # 保存的大小
# size_array=(
# 	40 60 
# 	58 87 
# 	80 120 
# 	120 180 
# 	20 40 
# 	29 58 
# 	40 80 
# 	76 152 
# 	167 
# 	1024
# )
# # 保存名字
# name_array=(
# 	"20@2x.png" "20@3x.png"
# 	"29@2x.png" "29@3x.png"
# 	"40@2x.png" "40@3x.png"
# 	"60@2x.png" "60@3x.png"
# 	"20@1x.png" "20@2x-1.png"
# 	"29@1x.png" "29@2x-1.png"
# 	"40@1x.png" "40@2x-1.png"
# 	"76@1x.png" "76@2x.png"
# 	"167@1x.png"
# 	"1024@1x.png"
# )

# # 保存
# for (( i = 0; i < ${#size_array[@]}; i++ )); do
# 	size=${size_array[i]}
# 	name=${name_array[i]}
# 	newfile=$folder"/"$name
# 	cp $verson $newfile
# 	sips -Z $size $newfile
# done


# 将 1024 大小的图片压缩成所有大小

filename="1024.png"
foldername="images"
size_array=(20 29 40 60 76 167 1024)
time_array=(1 2 3)

mkdir $foldername

for (( i = 0; i < ${#size_array[@]}; i++ )); do
	for (( j = 0; j < ${#time_array[@]}; j++ )); do
		newfile=$foldername/${size_array[i]}"@"${time_array[j]}"x.png"	
		size=$[size_array[i]*time_array[j]]
		#echo $newfile"  "$size
		cp $filename $newfile
		sips -Z $size $newfile
	done
done