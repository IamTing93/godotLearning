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
* 物品拖拽                      -- Done 20250727
* 插件化                         -- 暂停
* 数据存储                     -- 暂停
* ... 

## 问题记录

### tooltip展示的页面高度和设计的不一致：未解决

### 物品拖拽，当物品槽没有道具并且处于被选择时无法放置 ： 已解决

物品槽的UI表示如下

![item_slot](blog\images\item_slot.png)

当物品槽被选中时，蒙版就会显示。之所以不能放置，是因为ColorRect的mouse_filter为STOP，也就意味着这个控件会把鼠标事件拦截，并且不会往上冒泡。当道具槽没有道具的时候，ItemTile不会展示，这个物品槽的最顶层就是蒙版了，蒙版拦截鼠标事件，ItemSlot无法收到放置的事件，所以无法放置。

解决方案就是把ColorRect的mouse_filter设置为IGNORE。

### 当物品槽选择其它分类，如装备，拖拽会展示不正常：已解决

这个是代码设计不够好。物品拖拽后，会直接对逻辑层Inventory的items进行操作，然后再更新表示层InventoryPanel。但是分类的逻辑在表示层，会先获取Inventory的items，再根据当前分类过滤，所以这个时候表示层操作的item_slot无法与逻辑层进行一一对应，导致拖拽的时候没有办法按照预期工作。

解决方案是当分类并不是全部的时候，禁用掉拖拽功能。

## 其他

想吐槽一下godot工具，有些莫名其妙的bug，譬如新建tres后并操作后，信息没有进行更新，测试起来就出现货不对板的情况。有时候一些现象和想象中不一样，但是重启后又正常。另外这个编辑器也是不够智能，习惯了idea上开发，用godot的编辑器开发就比用txt工具好一点，得看看有没啥好的插件工具
