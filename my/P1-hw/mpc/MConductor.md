## redis key

### 1. Instance

1. instance 在实例init时save

   `k: instance.{id}	v: Encode(Instance)`

   `k: instance.{id}.alive	v: true)  interval`

   

2. instances(hashMap)：在实例init后save

   `k: instances  	f:{id} 	v:{InstanceKey:mconductor.instance.{id},  AliveKey:mconductor.instance.{id}.alive`

### 2.workflow

 1. workflowManager 进程启动时save一次，在加入workflow时会save

    ​	`k: workflow_mgr.{manager_id}	v:{encode(workflowManager)}`

 2. workflow

     	k: workflows.{id}	v: encode(workflow)

    ​	k: z.workflows.all	member: time, workflows.{id}

## 3. task

 1. tasks

    ​	hashmap:	k:	conductor.tasks	field: taskID	v: conductor.task.taskID

	2. task  new,execute,updateStatus都会save

    ​	string			k:	tcbs.taskID	v:	encode(TCB)



## 4. PrioQ

list :	instance/service/tag/version/prio	

 	 	 k: conductor.prioq.{live.trancode.tag.version}.on.instanceID.prio_22 	value: taskID



set:  	instance/service/tag/version

 		k: conductor.prioq.{live.trancode.tag.version}.on.instanceID	value: conductor.prioq.{live.trancode.tag.version}.on.instanceID.prio_22   score: 22



chanel:	 conductor.pubsub.live.transcode.tag.version.on.instanceID   message:	new obj %v with priority %d arrived



## 5. worker

1. works mananger

   hashmap： k：conductor.workers.HKey	field: 			value: encode(worker)

 2. rank

    set  k: conductor.rank.sel.feedback.live.transcode.tag.version	Z{workID, 	cap}
    
    

## utils

1. mctx.context：全局上下文，包含nameSpace，config，log，reidsClient，PubSub，TearDown等，利用withValue放到Context传到各类，然后可以直接使用
2. PubSub：管理全局channel
3. Teardown：初始化时add了一回调函数，在进程退出的时候调用
4. KeyPair：{{namespace}.instance.{instance.id}  ，{namespace}.instance.{instance.id}.alive}
5. PrioQ
6. Refer，Saver，Builder
7. 通过可变参数自定义new函数，减少构造接口复杂度







# 代码逻辑

## workerFlow

## worker

1. 



## TODO

1. handoff原理？

   1. ```go
      instance.IM.Monitor(myself, monitorHook(ctx))
      
      myself.AddFacility("workflow", workflow.HM)
      ```









# 需要能力

### 1. 切转合

### 1.1 是否切片---参考netflix的decision

```JSON
{
  "name": "decide_task",
  "taskReferenceName": "decide1",
  "inputParameters": {
    "case_value_param": "${workflow.input.movieType}"
  },
  "type": "DECISION",
  "caseValueParam": "case_value_param",
  "decisionCases": {
    "Show": [
      {
        "name": "setup_episodes",
        "taskReferenceName": "se1",
        "inputParameters": {
          "movieId": "${workflow.input.movieId}"
        },
        "type": "SIMPLE"
      },
      {
        "name": "generate_episode_artwork",
        "taskReferenceName": "ga",
        "inputParameters": {
          "movieId": "${workflow.input.movieId}"
        },
        "type": "SIMPLE"
      }
    ],
    "Movie": [
      {
        "name": "setup_movie",
        "taskReferenceName": "sm",
        "inputParameters": {
          "movieId": "${workflow.input.movieId}"
        },
        "type": "SIMPLE"
      },
      {
        "name": "generate_movie_artwork",
        "taskReferenceName": "gma",
        "inputParameters": {
          "movieId": "${workflow.input.movieId}"
        },
        "type": "SIMPLE"
      }
    ]
  }
}
```



### 1.2  动态转码任务数

```json
{
  "inputParameters": {
     "dynamicTasks": "${taskA.output.dynamicTasksJSON}",
     "dynamicTasksInput": "${taskA.output.dynamicTasksInputJSON}"
  },
  "type": "FORK_JOIN_DYNAMIC",
  "dynamicForkTasksParam": "dynamicTasks",
  "dynamicForkTasksInputParamName": "dynamicTasksInput"
}
```

​	问题：

 	1. 如何解决边切边转？目前感觉无法实现
     - 通过心跳fork？如何确认fork成功并响应work？
     - 转码参数都是work填充
 	2. 通过join后，下发合并，合并输入参数有哪些？如何定义？

### 1.3 倍速转码问题

？？



## 2.  多任务切转合的优化问题

- 考虑任务优先级
- 考虑用户优先级
- 考虑任务是否下发的约束（与倍速转码结合，与worker负载也有关系？）

## 3. worker调度优化

- 预估模型
- 负载反馈
- 刚启动时下发多少任务的问题

### 4. 其他

- conductor重启，worker是否继续工作