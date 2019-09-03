# ![EasyReact](https://raw.githubusercontent.com/meituan/EasyReact/master/images/Banner.png)

[![Build Status](https://travis-ci.com/meituan/EasyReact.svg?branch=master)](https://travis-ci.com/meituan/EasyReact)
[![Version](https://img.shields.io/cocoapods/v/EasyReact.svg?style=flat)](http://cocoapods.org/pods/EasyReact)
[![License](https://img.shields.io/cocoapods/l/EasyReact.svg?style=flat)](http://cocoapods.org/pods/EasyReact)
[![Platform](https://img.shields.io/cocoapods/p/EasyReact.svg?style=flat)](http://cocoapods.org/pods/EasyReact)
[![codecov](https://codecov.io/gh/meituan/EasyReact/branch/master/graph/badge.svg)](https://codecov.io/gh/meituan/EasyReact)

*Read this in other languages: [简体中文](README-Chinese.md)*

## What is EasyReact

EasyReact is an easy-to-use reactive programming framework.

## Why use EasyReact

Are you confused by the functors, applicatives, and monads in RxSwift and ReactiveCocoa? It doesn't matter, the concepts are so complicated that not many developers actually use them in normal projects. Is there an easy-to-use way to use reactive programming? EasyReact is born for this reason.

## Features

Note: The "Node" listed below refer to `EZRNode`, a unified representation of various values (all object types) in EasyReact.

- [x] [Create node or mutable node](./Documents/English/BasicOperators.md#create-node)
- [x] [Get the value of the node immediately](./Documents/English/BasicOperators.md#get-instant-value)
- [x] [Listen to the future value of the node](./Documents/English/BasicOperators.md#listen-nodes-value)
- [x] [Cancel listening to a node](./Documents/English/BasicOperators.md#listen-nodes-value)
- [x] [Connect two points](./Documents/English/BasicOperators.md#connect-two-nodes)
- [x] [Basic transformation of a node](./Documents/English/BasicOperators.md#basic-transformation)
  - [x] [map](./Documents/English/BasicOperators.md#map)
  - [x] [filter](./Documents/English/BasicOperators.md#filter)
  - [x] [distinctUntilChanged](./Documents/English/BasicOperators.md#distinctuntilchanged)
  - [x] [throttle](./Documents/English/BasicOperators.md#throttle)
  - [x] [skip](./Documents/English/BasicOperators.md#skip)
  - [x] [take](./Documents/English/BasicOperators.md#take)
  - [x] [deliverOn](./Documents/English/BasicOperators.md#deliveron)
  - [x] [delay](./Documents/English/BasicOperators.md#delay)
  - [x] [scan](./Documents/English/BasicOperators.md#scan)
- [x] [Combine multiple nodes](./Documents/English/BasicOperators.md#Combination)
  - [x] [combine](./Documents/English/BasicOperators.md#combine)
  - [x] [merge](./Documents/English/BasicOperators.md#merge)
  - [x] [zip](./Documents/English/BasicOperators.md#zip)
- [x] [Branch a node to get multiple nodes](./Documents/English/BasicOperators.md#Branch)
  - [x] [switch-case-default](./Documents/English/BasicOperators.md#switch-case-default)
  - [x] [if-then-else](./Documents/English/BasicOperators.md#if-then-else)
- [x] [Synchronize values across multiple nodes](./Documents/English/BasicOperators.md#Sync)
  - [x] [syncWith](./Documents/English/BasicOperators.md#syncwith)
  - [x] [Manual Sync](./Documents/English/BasicOperators.md#manual-sync)
- [x] [High-order transformation of nodes](./Documents/English/BasicOperators.md#high-order-transformation)
  - [x] [flatten](./Documents/English/BasicOperators.md#flatten)
  - [x] [flattenMap](./Documents/English/BasicOperators.md#flattenmap)
- [x] [Traversing nodes and edges](./Documents/English/BasicOperators.md#graph-traversal)
  - [x] [Simple Access](./Documents/English/BasicOperators.md#simple-access)
  - [x] [Accessor Mode](./Documents/English/BasicOperators.md#accessor-mode)

## Learn more

1. [Framework Overview](./Documents/English/FrameworkOverview.md)

2. [Basic Operations](./Documents/English/BasicOperators.md)

3. [Memory Management](./Documents/English/MemoryManagement.md)

4. [How to Contribute](./CONTRIBUTING.md)

## Compare other Functional Reactive libraries (e.g. [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) or [ReactiveX](https://github.com/ReactiveX))

| Project                    | EasyReact                                                                                                                  | ReactiveCocoa          | ReactiveX                                      |
| :------------------------: | :------------------------------------------------------------------------------------------------------------------------: | :--------------------: | :--------------------------------------------: |
| Core idea                  | Graph theory and object-oriented programming                                                                               | Functional programming | Functional programming and generic programming |
| Propagation variability    | ✅                                                                                                                         | ❌                      | ❌                                             |
| Basic transformation       | ✅                                                                                                                         | ✅                      | ✅                                             |
| Combination transformation | ✅                                                                                                                         | ✅                      | ✅                                             |
| High-order transformation  | ✅                                                                                                                         | ✅                      | ✅                                             |
| Traversal node/signal      | ✅                                                                                                                         | ❌                      | ❌                                             |
| Multi-language support     | Objective-C<br>(Other language versions will open source in the future)                                                    | Objective-C, Swift     | Many language versions                         |
| Performance                | faster                                                                                                                     | slow                   | fastest                                        |
| Chinese document support   | ✅                                                                                                                         | ❌                      | ❌                                             |
| Debugging tools            | [Topology display](./Documents/English/BasicOperators.md#simple-access) <br>More rich dynamic debugging tools(Coming soon) | Instrument             | ❌                                             |

## System Requirements

- iOS 8.0 +
- Xcode 8.0 +

## How to run the example project

`git clone` this repo，excute `pod install` in Example/,  then open `EasyReact.xcworkspace`.

## Installation

### CocoaPods

Add the following content in `Podfile`

```ruby
pod 'EasyReact'
```

Then execute `pod install`

## How to use (For a more detailed example, please see the test specs in the example project Tests/)

### Unit Test

EasyReact contains a complete unit test with the relevant code in the Example/Tests folder. You can open the sample project and execute the Test command to run these unit tests.

## Time-consuming Benchmarking with EasyReact and ReactiveCocoa Common APIs

### Environment

Build Platform: macOS Mojave 10.14

IDE: Xcode 10.0(10A255)

Device: iPhone XS Max 256G iOS 12.0(16A366)

### Cases

1. Single stage operations, such as listener, map, filter, flattenMap, etc.
2. Multicast operations, such as combine, zip, merge, etc.
3. syncWith operations

The scale of the test is based on 10 operating objects and 1000 triggers. For example, the listener method has 10 listeners and repeats the action of sending the value 1000 times.
The unit of time is ns.

### Result data

Repeat the above experiment 10 times to get the data as follows:

|name|listener|map|filter|flattenMap|combine|zip|merge|syncWith|
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
|EasyReact|4218689|26615802|9872381|9896752|5744164|48405085|29639206|11846827|
|ReactiveCocoa|2263981|42883385|28768289|28810331|127882031|82689281|6809210|30935277|
|RAC:EasyReact|53.7%|161.1%|291.4%|291.1%|2226.3%|170.8%|23.0%|261.1%|

![benchmark](./images/benchmark.png)

### Summary

ReactiveCocoa's average time consuming is 434.8% times more than EasyReact.

EasyReact will compare benchmark with RxSwift when the Swift version open source recently.

## Authors

William Zang, [chengwei.zang.1985@gmail.com](mailto:chengwei.zang.1985@gmail.com)  
姜沂, [nero_jy@qq.com](mailto:nero_jy@qq.com)  
Qin Hong, [qinhong@face2d.com](mailto:qinhong@face2d.com)  
SketchK, [zhangsiqi1988@gmail.com](mailto:zhangsiqi1988@gmail.com)  
zesming, [ming9010@gmail.com](mailto:ming9010@gmail.com)  
Zhiyu Wong, [www312422@vip.qq.com](mailto:www312422@vip.qq.com)  
johnnywjy, [johnny.wjy07@gmail.com](mailto:johnny.wjy07@gmail.com)  
qiezishu, [qiezishu@yahoo.com](mailto:qiezishu@yahoo.com)  

## License

EasyReact is [Apache Public License 2.0](./LICENSE)
