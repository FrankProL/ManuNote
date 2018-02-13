#!/bin/bash
adate=`date -d '-1 day' "+%Y%m%d"`
bdate=`date -d '-1 day' "+%Y-%m-%d"`
echo "活动日期：">jingcai0213.txt
echo $adate >>jingcai0213.txt
echo $bdate 
echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt


adate='2018-02-09'
bdate='20180209'

echo "mysql查询"
echo "竞猜题目数" >>jingcai0213.txt 
mysql -h rr-bp1o90m39oporf1g1o.mysql.rds.aliyuncs.com -P 3306 -u loujianfeng -pFeTuH9bo6fakUw9 >>jingcai0213.txt <<EOF
use live_core
select room_id,count(id) from jc_quiz_question 
where left(start_time,10)='$adate' group by room_id
EOF

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "历史首次充值人数	历史首次充值用户充值金额" >>jingcai0213.txt 
impala-shell -q  "SELECT COUNT(DISTINCT user_id),SUM(money)
from stats_user_account_log_v1
where money>0 and create_time_day='$adate'
and user_id not in 
(
SELECT DISTINCT user_id
from stats_user_account_log_v1
where create_time_day<'$adate' and money>0
)" -B --output_delimiter="\t" --print_header >> jingcai0213.txt 

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "房间登录用户数" >>jingcai0213.txt 
impala-shell -q  "select roomid,count(distinct uid)
from ssets_weblogs201
where day='$bdate'
and roomid in ('123269','124770')
group by roomid" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "123269房间登录用户充值人数" >>jingcai0213.txt
impala-shell -q  "select count(distinct user_id)
from stats_user_account_log_v1
where money>0 and create_time_day='$adate'
and user_id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='123269')" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "124770房间登录用户充值人数" >>jingcai0213.txt
impala-shell -q  "select count(distinct user_id)
from stats_user_account_log_v1
where money>0 and create_time_day='$adate'
and user_id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='124770')" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "123269房间登录用户充值金额（去除红星闪闪）" >>jingcai0213.txt
impala-shell -q  "select sum(money)
from stats_user_account_log_v1
where money>0 and create_time_day='$adate'
and user_id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='123269')
and user_id<>20002130" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "124770房间登录用户充值金额（去除红星闪闪）" >>jingcai0213.txt
impala-shell -q  "select sum(money)
from stats_user_account_log_v1
where money>0 and create_time_day='$adate'
and user_id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='124770')
and user_id<>20002130" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "123269房间登录用户首次充值人数" >>jingcai0213.txt
impala-shell -q  "SELECT COUNT(DISTINCT user_id)
from stats_user_account_log_v1
where money>0 and create_time_day='$adate'
and user_id not in 
(
SELECT DISTINCT user_id
from stats_user_account_log_v1
where create_time_day<'$adate' and money>0
)
and user_id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='123269')" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "124770房间登录用户首次充值人数" >>jingcai0213.txt
impala-shell -q  "SELECT COUNT(DISTINCT user_id)
from stats_user_account_log_v1
where money>0 and create_time_day='$adate'
and user_id not in 
(
SELECT DISTINCT user_id
from stats_user_account_log_v1
where create_time_day<'$adate' and money>0
)
and user_id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='124770')" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "123269房间登录用户首次充值金额" >>jingcai0213.txt
impala-shell -q  "select sum(b.money) 
from 
(
  select a.user_id,sum(a.money) as money 
  from 
  (
    select user_id,create_time_day,money,row_number() over (partition by user_id order by create_time) as row_number from stats_user_account_log_v1 where money>0
  ) a
  where a.row_number =1 and a.create_time_day = '$adate' group by a.user_id
) b
where b.user_id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='123269')" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "124770房间登录用户首次充值金额" >>jingcai0213.txt
impala-shell -q  "select sum(b.money) 
from 
(
  select a.user_id,sum(a.money) as money 
  from 
  (
    select user_id,create_time_day,money,row_number() over (partition by user_id order by create_time) as row_number from stats_user_account_log_v1 where money>0
  ) a
  where a.row_number =1 and a.create_time_day = '$adate' group by a.user_id
) b
where b.user_id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='124770')" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "123269房间登录用户数新增注册人数" >>jingcai0213.txt
impala-shell -q  "select count(id) 
from stats_user_base_v1
where create_time_day='$adate'
and id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='123269')" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "124770房间登录用户数新增注册人数" >>jingcai0213.txt
impala-shell -q  "select count(id) 
from stats_user_base_v1
where create_time_day='$adate'
and id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='124770')" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "123269房间登录用户数新增注册充值人数	房间登录用户数新增注册充值金额" >>jingcai0213.txt
impala-shell -q  "SELECT COUNT(DISTINCT user_id),SUM(money)
from stats_user_account_log_v1
where money>0 and create_time_day='$adate'
and user_id in 
(
select id 
from stats_user_base_v1
where create_time_day='$adate'
and id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='123269')
)" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

echo "-----------------------------------------------------------"
echo "-----------------------------------------------------------" >>jingcai0213.txt
echo "124770房间登录用户数新增注册充值人数	房间登录用户数新增注册充值金额" >>jingcai0213.txt
impala-shell -q  "SELECT COUNT(DISTINCT user_id),SUM(money)
from stats_user_account_log_v1
where money>0 and create_time_day='$adate'
and user_id in 
(
select id 
from stats_user_base_v1
where create_time_day='$adate'
and id in (select distinct cast(trim(uid) as bigint)
from ssets_weblogs201
where day='$bdate'
and roomid='124770')
)" -B --output_delimiter="\t" --print_header >> jingcai0213.txt

# -------------------------------------------------------------------------
echo "-----------------------------------------------------------"
echo "mysql查询"
echo "竞猜用户" >jingcai_user.txt 
mysql -h rr-bp1o90m39oporf1g1o.mysql.rds.aliyuncs.com -P 3306 -u loujianfeng -pFeTuH9bo6fakUw9 >>jingcai_user.txt <<EOF
use live_core
select DISTINCT r.room_id,r.user_id,s.nickname,s.create_time,t.historyrecharge,u.recharge,r.xnum,r.money,r.award
from 
(
select b.room_id,a.user_id,sum(a.xiazhu) as money,sum(a.rew) as award,sum(a.num) xnum
from 
(select user_id,question_id,sum(quizzes_amount) as xiazhu ,sum(reward_amount) as rew,count(user_id) as num 
from jc_quiz
where left(quiz_time,10)='$adate'
GROUP BY user_id,question_id
ORDER BY user_id,question_id
) as a ,
(select id,room_id from jc_quiz_question where left(start_time,10)='$adate') as b 
where a.question_id=b.id
group by b.room_id,a.user_id
ORDER BY b.room_id
) as r left join 
user as s
on r.user_id=s.id
left join (select user_id,sum(money) as historyrecharge
 from user_account_log
 where money>0 
 and DATE(create_time)<='$adate'
 group by user_id ) as t on r.user_id=t.user_id
left join (select user_id,sum(money) as recharge
 from user_account_log
 where money>0 
 and DATE(create_time)='$adate'
 group by user_id ) as u on r.user_id=u.user_id
order by r.room_id,r.user_id
EOF
