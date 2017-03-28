#!/bin/bash

# correct /var/log permissions
sudo chmod g-w /var/log

# need to generate a password
sudo apt update
sudo apt install --assume-yes pwgen

PW=$(pwgen --capitalize --numerals --secure --no-vowels 24 1)
echo "
mysql-server-5.7 mysql-server/root_password_again password $PW	
mysql-server-5.7 mysql-server/root_password password $PW
" | sudo debconf-set-selections

sudo apt install --assume-yes mysql-server-5.7

sudo service mysql start

DB_USER="slurm"
DB_ACCOUNTING="cctbhpc_accounting"
DB_JOBCOMPLETION="cctbhpc_jobcompletion"

# create user and database entries for slurm + grant privilegeues
PW_slurm=$(pwgen --capitalize --numerals --secure --no-vowels 12 1)
sudo mysql --password="$PW" --execute="create user '$DB_USER'@'localhost' identified by '$PW_slurm';"

for i in "$DB_ACCOUNTING" "$DB_JOBCOMPLETION"
do
    sudo mysql --password="$PW" --execute="create database $i;"
    sudo mysql --password="$PW" --execute="grant all on "$i".* TO '$DB_USER'@'localhost';"
done

sudo apt install --assume-yes munge slurm-llnl mailutils

sudo create-munge-key -f

sudo base64 /etc/munge/munge.key

sudo service munge stop
sudo service munge start

cat <<EOF | sudo tee /etc/slurm-llnl/slurm.conf
# slurm.conf file generated by configurator.html.
# Put this file on all nodes of your cluster.
# See the slurm.conf man page for more information.
#
ControlMachine=$HOSTNAME
#ControlAddr=
#BackupController=
#BackupAddr=
# 
AuthType=auth/munge
#CheckpointType=checkpoint/none 
CryptoType=crypto/munge
#DisableRootJobs=NO 
#EnforcePartLimits=NO 
#Epilog=
#EpilogSlurmctld= 
#FirstJobId=1 
#MaxJobId=999999 
#GresTypes= 
#GroupUpdateForce=0 
#GroupUpdateTime=600 
#JobCheckpointDir=/var/slurm/checkpoint 
#JobCredentialPrivateKey=
#JobCredentialPublicCertificate=
#JobFileAppend=0 
#JobRequeue=1 
#JobSubmitPlugins=1 
#KillOnBadExit=0 
#LaunchType=launch/slurm 
#Licenses=foo*4,bar 
MailProg=/bin/mail 
#MaxJobCount=5000 
#MaxStepCount=40000 
#MaxTasksPerNode=128 
MpiDefault=none
#MpiParams=ports=#-# 
#PluginDir= 
#PlugStackConfig= 
#PrivateData=jobs 
ProctrackType=proctrack/pgid
#Prolog=
#PrologFlags= 
#PrologSlurmctld= 
#PropagatePrioProcess=0 
#PropagateResourceLimits= 
#PropagateResourceLimitsExcept= 
#RebootProgram= 
ReturnToService=2
#SallocDefaultCommand= 
SlurmctldPidFile=/var/run/slurmctld.pid
SlurmctldPort=6817
SlurmdPidFile=/var/run/slurmd.pid
SlurmdPort=6818
SlurmdSpoolDir=/tmp/slurmd
SlurmUser=slurm
#SlurmdUser=root 
#SrunEpilog=
#SrunProlog=
StateSaveLocation=/tmp/slurmd
SwitchType=switch/none
#TaskEpilog=
TaskPlugin=task/none
#TaskPluginParam=
#TaskProlog=
#TopologyPlugin=topology/tree 
#TmpFS=/tmp 
#TrackWCKey=no 
#TreeWidth= 
#UnkillableStepProgram= 
#UsePAM=0 
# 
# 
# TIMERS 
#BatchStartTimeout=10 
#CompleteWait=0 
#EpilogMsgTime=2000 
#GetEnvTimeout=2 
#HealthCheckInterval=0 
#HealthCheckProgram= 
InactiveLimit=0
KillWait=30
#MessageTimeout=10 
#ResvOverRun=0 
MinJobAge=300
#OverTimeLimit=0 
SlurmctldTimeout=120
SlurmdTimeout=300
#UnkillableStepTimeout=60 
#VSizeFactor=0 
Waittime=0
# 
# 
# SCHEDULING 
#DefMemPerCPU=0 
FastSchedule=1
#MaxMemPerCPU=0 
#SchedulerTimeSlice=30 
SchedulerType=sched/backfill
SelectType=select/linear
#SelectTypeParameters=
# 
# 
# JOB PRIORITY 
#PriorityFlags= 
#PriorityType=priority/basic 
#PriorityDecayHalfLife= 
#PriorityCalcPeriod= 
#PriorityFavorSmall= 
#PriorityMaxAge= 
#PriorityUsageResetPeriod= 
#PriorityWeightAge= 
#PriorityWeightFairshare= 
#PriorityWeightJobSize= 
#PriorityWeightPartition= 
#PriorityWeightQOS= 
# 
# 
# LOGGING AND ACCOUNTING 
#AccountingStorageEnforce=0 
AccountingStorageHost=localhost
AccountingStorageLoc=$DB_ACCOUNTING
AccountingStoragePass=$PW_slurm
#AccountingStoragePort=
AccountingStorageType=accounting_storage/mysql
AccountingStorageUser=$DB_USER
AccountingStoreJobComment=YES
ClusterName=cctbhpc
#DebugFlags= 
JobCompHost=localhost
JobCompLoc=$DB_JOBCOMPLETION
JobCompPass=$PW_slurm
#JobCompPort=
JobCompType=jobcomp/mysql
JobCompUser=$DB_USER
#JobContainerType=job_container/none 
JobAcctGatherFrequency=30
JobAcctGatherType=jobacct_gather/linux
SlurmctldDebug=3
#SlurmctldLogFile=
SlurmdDebug=3
#SlurmdLogFile=
#SlurmSchedLogFile= 
#SlurmSchedLogLevel= 
# 
# 
# POWER SAVE SUPPORT FOR IDLE NODES (optional) 
#SuspendProgram= 
#ResumeProgram= 
#SuspendTimeout= 
#ResumeTimeout= 
#ResumeRate= 
#SuspendExcNodes= 
#SuspendExcParts= 
#SuspendRate= 
#SuspendTime= 
# 
# 
# COMPUTE NODES 
NodeName=saturn1 CPUs=80 RealMemory=500000 Sockets=4 CoresPerSocket=10 ThreadsPerCore=2 State=UNKNOWN
NodeName=saturn2 CPUs=80 RealMemory=500000 Sockets=4 CoresPerSocket=10 ThreadsPerCore=2 State=UNKNOWN
NodeName=jupiter CPUs=80 RealMemory=1000000 Sockets=4 CoresPerSocket=10 ThreadsPerCore=2 State=UNKNOWN
NodeName=uranus[1-3] CPUs=32 RealMemory=190000 Sockets=2 CoresPerSocket=16 ThreadsPerCore=1 State=UNKNOWN
NodeName=neptun1 CPUs=24 RealMemory=190000 Sockets=2 CoresPerSocket=6 ThreadsPerCore=2 State=UNKNOWN
PartitionName=default Nodes=saturn1,saturn2,jupiter,neptun1,uranus[1-3] Default=YES MaxTime=INFINITE State=UP
EOF

sudo service start slurmctr
