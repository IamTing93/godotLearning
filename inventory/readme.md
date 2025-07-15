# 背包系统

## 项目说明

这个是模仿[大佬的背包系统](https://www.bilibili.com/video/BV1C142127oK?spm_id_from=333.788.videopod.sections&vd_source=38ca4cbea34805ef6e2c2733b2469854)而创建的个人项目。主要是参考UI界面，代码逻辑部分都是按照个人理解重写，旨在熟悉godot的这个工具，同时记录一下学习过程以及途中遇到的问题和解决方法。



## 项目结构

+---.godot

+---assets  						-- 项目资产元数据

+---resources					 -- 项目用到的tres资源

|   +---equipment_slots

|   \---items

+---scenes						 -- 项目场景

|   +---components             -- 通用组件

|   +---modules				   -- 模块

|   +---objects					 -- 可复用对象

|   +---test						   -- 测试场景

|   \---ui							    -- ui界面相关

\---scripts							-- 全局脚本

## 实现思路

项目借鉴MVC框架的思想，ui为表现层，逻辑层的代码存放在modules



## todo list

* 背包系统的打开与隐藏 -- Done 20250713
* 物品信息展示               -- Done 20250715
* 物品拖拽
* 插件化
* 数据存储
* ... 

## 问题记录

- tooltip展示的页面高度和设计的不一致：未解决

## 其他

想吐槽一下godot工具，有些莫名其妙的bug，譬如新建tres后并操作后，信息没有进行更新，测试起来就出现货不对板的情况。有时候一些现象和想象中不一样，但是重启后又正常。另外这个编辑器也是不够智能，习惯了idea上开发，用godot的编辑器开发就比用txt工具好一点，得看看有没啥好的插件工具
