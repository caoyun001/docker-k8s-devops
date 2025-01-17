# [RabbitMQ消息中间件技术精讲](https://coding.imooc.com/class/chapter/262.html)

> 必须好好学

## 第1章 课程介绍

> 本章首先让大家彻底明白为什么学习RabbitMQ，通过本课程的学习具体收获有哪些？课程内容具体安排与学习建议，然后为大家简单介绍下业界主流消息中间件有哪些，各自适用场景等。（专为没有RabbitMQ基础的同学提供免费入门课程：https://www.imooc.com/learn/1042）...

+ 1-1 课前必读（不看会错过一个亿）
+ 1-2 课程导学 试看
+ 1-3 业界主流消息中间件介绍

## 第2章 低门槛，入门RabbitMQ核心概念

> 本章首先为大家讲解互联网大厂为什么选择RabbitMQ? RabbitMQ的高性能之道是如何做到的？什么是AMPQ高级协议？AMPQ核心概念是什么？RabbitMQ整体架构模型是什么样子的？RabbitMQ消息是如何流转的？RabbitMQ安装与使用命令行与管控台，RabbitMQ消息生产与消费，RabbitMQ交换机详解，RabbitMQ队列、绑定、虚拟主机、消息等...

+ 2-1 本章导航
+ 2-2 哪些互联网大厂在使用RabbitMQ,为什么？
+ 2-3 RabbitMQ高性能的原因
+ 2-4 AMQP高级消息队列协议与模型
+ 2-5 AMQP核心概念讲解
+ 2-6 RabbitMQ整体架构与消息流转
+ 2-7 RabbitMQ环境安装-1
+ 2-8 RabbitMQ环境安装-2
+ 2-9 命令行与管理台结合讲解
+ 2-10 生产者消费者模型构建-1
+ 2-11 生产者消费者模型构建-2
+ 2-12 交换机详解-1
+ 2-13 交换机详解-2
+ 2-14 交换机详解-3
+ 2-15 绑定、队列、消息、虚拟主机详解
+ 2-16 本章小结

## 第3章 渐进式，深入RabbitMQ高级特性

> 本章主要为大家讲解RabbitMQ的高级特性和实际场景应用，包括消息如何保障 100% 的投递成功 ？幂等性概念详解，在海量订单产生的业务高峰期，如何避免消息的重复消费问题？Confirm确认消息、Return返回消息，自定义消费者，消息的ACK与重回队列，消息的限流，TTL消息，死信队列等 ...

+ 3-1 本章导航
+ 3-2 消息如何保障 100% 的投递成功方案-1 试看
+ 3-3 消息如何保障 100% 的投递成功方案-2
+ 3-4 幂等性概念及业界主流解决方案
+ 3-5 Confirm确认消息详解
+ 3-6 Return返回消息详解
+ 3-7 自定义消费者使用
+ 3-8 消费端的限流策略-1
+ 3-9 消费端的限流策略-2
+ 3-10 消费端ACK与重回队列机制
+ 3-11 TTL消息详解
+ 3-12 死信队列详解-1
+ 3-13 死信队列详解-2
+ 3-14 本章小结

## 第4章 手把手，整合RabbitMQ&Spring家族

> 本章为大家讲解RabbitMQ如何与Spring系的框架体系进行整合（RabbitMQ整合Spring AMQP实战，RabbitMQ整合Spring Boot实战 ，RabbitMQ整合Spring Cloud实战），涉及实际工作中需要注意的细节点，与最佳实战应用，通过本章的学习，学员能够掌握RabbitMQ的实战整合能力，直接应用到具体的工作中！ ...

+ 4-1 本章导航
+ 4-2 SpringAMQP用户管理组件-RabbitAdmin应用-1
+ 4-3 SpringAMQP用户管理组件-RabbitAdmin应用-2
+ 4-4 SpringAMQP用户管理组件-RabbitAdmin源码分析
+ 4-5 SpringAMQP-RabbitMQ声明式配置使用
+ 4-6 SpringAMQP消息模板组件-RabbitTemplate实战
+ 4-7 SpringAMQP消息容器-SimpleMessageListenerContainer详解
+ 4-8 SpringAMQP消息适配器-MessageListenerAdapter使用-1
+ 4-9 SpringAMQP消息适配器-MessageListenerAdapter使用-2
+ 4-10 SpringAMQP消息转换器-MessageConverter讲解-1
+ 4-11 SpringAMQP消息转换器-MessageConverter讲解-2
+ 4-12 RabbitMQ与SpringBoot2.0整合实战-基本配置
+ 4-13 RabbitMQ与SpringBoot2.0整合实战-1
+ 4-14 RabbitMQ与SpringBoot2.0整合实战-2
+ 4-15 RabbitMQ与SpringBoot2.0整合实战-3
+ 4-16 RabbitMQ与SpringBoot2.0整合实战-4
+ 4-17 RabbitMQ与Spring Cloud Stream整合实战-1
+ 4-18 RabbitMQ与Spring Cloud Stream整合实战-2
+ 4-19 本章小结

## 第5章 高可靠，构建RabbitMQ集群架构

> 本章为大家讲解RabbitMQ集群架构的各种姿势，以及从零到一带大家构建高可靠性的RabbitMQ集群架构（Haproxy + Keepalived），并分享包括对集群的运维、故障恢复方案以及延迟队列插件应用等

+ 5-1 本章导航
+ 5-2 RabbitMQ集群架构模式-主备模式（Warren）
+ 5-3 RabbitMQ集群架构模式-远程模式（Shovel）
+ 5-4 RabbitMQ集群架构模式-镜像模式（Mirror）
+ 5-5 RabbitMQ集群架构模式-多活模式（Federation）
+ 5-6 RabbitMQ集群镜像队列构建实现可靠性存储
+ 5-7 RabbitMQ集群整合负载均衡基础组件HaProxy
+ 5-8 RabbitMQ集群整合高可用组件KeepAlived-1
+ 5-9 RabbitMQ集群整合高可用组件KeepAlived-2
+ 5-10 RabbitMQ集群配置文件详解
+ 5-11 RabbitMQ集群恢复与故障转移的5种解决方案
+ 5-12 RabbitMQ集群延迟队列插件应用
+ 5-13 本章小结

![高可靠RabbitMQ集群](images/高可靠RabbitMQ集群.png)

## 第6章 追前沿，领略SET化架构衍化与设计

> 本章主要为大家带来一线互联网实现消息中间件多集群的实际落地方案与架构设计思路讲解，涉及目前互联网架构里非常经典的多活，单元化的理念，更有效的提升服务的可靠性与稳定性。

+ 6-1 本章导航
+ 6-2 BAT、TMD大厂单元化架构设计衍变之路分享
+ 6-3 SET化架构设计策略(异地多活架构)
+ 6-4 SET化架构设计原则
+ 6-5 SET化消息中间件架构实现-1
+ 6-6 SET化消息中间件架构实现-2
+ 6-7 本章小结

![SET结构](images/SET结构.png)

## 第7章 学大厂，拓展基础组件封装思路

> 本章节，我们希望和大家分享互联网大厂的基础组件架构封装思路，其中涉及到消息发送的多模式化、消息的高性能序列化、消息的异步化、连接的缓存容器、消息的可靠性投递、补偿策略、消息的幂等解决方案

+ 7-1 本章导航
+ 7-2 一线大厂的MQ组件实现思路和架构设计思路
+ 7-3 基础MQ消息组件设计思路-1（迅速，确认，批量，延迟）
+ 7-4 基础MQ消息组件设计思路-2（顺序）
+ 7-5 基础MQ消息组件设计思路-3(事务)
+ 7-6 消息幂等性保障-消息路由规则架构设计思路
