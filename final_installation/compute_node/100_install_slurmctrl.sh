#!/bin/bash

# correct /var/log permissions
sudo chmod g-w /var/log

# need to generate a password
sudo apt update
sudo apt install --assume-yes pwgen

PW=$(pwgen --capitalize --numerals --secure --no-vowels 24 1)

echo "
mysql-server-5.7 mysql-server/root_password password $PW
mysql-server-5.7 mysql-server/root_password_again password $PW
" | sudo debconf-set-selections

sudo apt install --assume-yes mysql-server libmysqlclient-dev libmysqld-dev
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

sudo apt install --assume-yes munge mailutils

sudo create-munge-key -f

sudo base64 /etc/munge/munge.key

sudo service munge stop
sudo service munge start

sudo apt install --assume-yes build-essential gcc bison make flex libncurses5-dev tcsh pkg-config blcr-util blcr-testsuite libcr-dbg libcr-dev libcr0
sudo apt install --assume-yes checkinstall wget tar bzip2
sudo apt install --assume-yes python

cd /tmp/
wget -O slurm.tar.bz2 https://www.schedmd.com/downloads/latest/slurm-16.05.10-2.tar.bz2
tar xjf slurm.tar.bz2
cd slurm-16.05.10-2

./configure --enable-multiple-slurmd
make
checkinstall --install=yes

mkdir -p /etc/slurm-llnl
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
MailProg=/usr/bin/mail
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

sudo ln -s /etc/slurm-llnl/slurm.conf /usr/local/etc/slurm.conf

echo "slurm:x:2000:2000:slurm admin:/home/slurm:/bin/bash" | sudo tee --append /etc/passwd
echo "slurm:x:2000:slurm" | sudo tee --append /etc/groups
pwconv

sudo mkdir /var/spool/slurm
sudo chown -R slurm:slurm /var/spool/slurm
sudo mkdir /var/log/slurm
sudo chown -R slurm:slurm /var/log/slurm

sudo touch /etc/init.d/slurmctl
sudo touch /etc/init.d/slurmdbd
sudo chmod +x /etc/init.d/slurm
sudo chmod +x /etc/init.d/slurmdbd

cat <<"EOF" | tee /etc/init.d/slurmctl
#!/bin/sh
#
# chkconfig: 345 90 10
# description: SLURM is a simple resource management system which \
#              manages exclusive access o a set of compute \
#              resources and distributes work to those resources.
#
# processname: /usr/local/sbin/slurmctld
# pidfile: /var/run/slurm/slurmctld.pid
#
# config: /etc/default/slurmctld
#
### BEGIN INIT INFO
# Provides:          slurmctld
# Required-Start:    $remote_fs $syslog $network munge
# Required-Stop:     $remote_fs $syslog $network munge
# Should-Start:      $named
# Should-Stop:       $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: slurm daemon management
# Description:       Start slurm to provide resource management
### END INIT INFO

BINDIR="/usr/local/bin"
CONFDIR="/usr/local/etc"
LIBDIR="/usr/local/lib"
SBINDIR="/usr/local/sbin"

# Source slurm specific configuration
if [ -f /etc/default/slurmctld ] ; then
    . /etc/default/slurmctld
else
    SLURMCTLD_OPTIONS=""
fi

# Checking for slurm.conf presence
if [ ! -f $CONFDIR/slurm.conf ] ; then
    if [ -n "$(echo $1 | grep start)" ] ; then
      echo Not starting slurmctld
    fi
      echo slurm.conf was not found in $CONFDIR
    exit 0
fi

DAEMONLIST="slurmctld"
test -f $SBINDIR/slurmctld || exit 0

#Checking for lsb init function
if [ -f /lib/lsb/init-functions ] ; then
  . /lib/lsb/init-functions
else
  echo Can\'t find lsb init functions
  exit 1
fi
# setup library paths for slurm and munge support
export LD_LIBRARY_PATH=$LIBDIR${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}

#Function to check for cert and key presence and key vulnerabilty
checkcertkey()
{
  MISSING=""
  keyfile=""
  certfile=""

  if [ "$1" = "slurmctld" ] ; then
    keyfile=$(grep JobCredentialPrivateKey $CONFDIR/slurm.conf | grep -v "^ *#")
    keyfile=${keyfile##*=}
    keyfile=${keyfile%#*}
    [ -e $keyfile ] || MISSING="$keyfile"
  fi

  if [ "${MISSING}" != "" ] ; then
    echo Not starting slurmctld
    echo $MISSING not found
    exit 0
  fi

  if [ -f "$keyfile" ] && [ "$1" = "slurmctld" ] ; then
    keycheck=$(openssl-vulnkey $keyfile | cut -d : -f 1)
    if [ "$keycheck" = "COMPROMISED" ] ; then
      echo Your slurm key stored in the file $keyfile
      echo is vulnerable because has been created with a buggy openssl.
      echo Please rebuild it with openssl version \>= 0.9.8g-9
      exit 0
    fi
  fi
}

get_daemon_description()
{
    case $1 in
      slurmd)
        echo slurm compute node daemon
        ;;
      slurmctld)
        echo slurm central management daemon
        ;;
      *)
        echo slurm daemon
        ;;
    esac
}

start() {
  CRYPTOTYPE=$(grep CryptoType $CONFDIR/slurm.conf | grep -v "^ *#")
  CRYPTOTYPE=${CRYPTOTYPE##*=}
  CRYPTOTYPE=${CRYPTOTYPE%#*}
  if [ "$CRYPTOTYPE" = "crypto/openssl" ] ; then
    checkcertkey $1
  fi

  # Create run-time variable data
  mkdir -p /var/run/slurm
  chown slurm:slurm /var/run/slurm

  # Checking if StateSaveLocation is under run
  if [ "$1" = "slurmctld" ] ; then
    SDIRLOCATION=$(grep StateSaveLocation /usr/local/etc/slurm.conf \
                       | grep -v "^ *#")
    SDIRLOCATION=${SDIRLOCATION##*=}
    SDIRLOCATION=${SDIRLOCATION%#*}
    if [ "${SDIRLOCATION}" = "/var/run/slurm/slurmctld" ] ; then
      if ! [ -e /var/run/slurm/slurmctld ] ; then
        ln -s /var/lib/slurm/slurmctld /var/run/slurm/slurmctld
      fi
    fi
  fi

desc="$(get_daemon_description $1)"
  log_daemon_msg "Starting $desc" "$1"
  unset HOME MAIL USER USERNAME
  #FIXME $STARTPROC $SBINDIR/$1 $2
  STARTERRORMSG="$(start-stop-daemon --start --oknodo \
                   --exec "$SBINDIR/$1" -- $2 2>&1)"
  STATUS=$?
  log_end_msg $STATUS
  if [ "$STARTERRORMSG" != "" ] ; then
    echo $STARTERRORMSG
  fi
  touch /var/lock/slurm
}

stop() {
    desc="$(get_daemon_description $1)"
    log_daemon_msg "Stopping $desc" "$1"
    STOPERRORMSG="$(start-stop-daemon --oknodo --stop -s TERM \
                    --exec "$SBINDIR/$1" 2>&1)"
    STATUS=$?
    log_end_msg $STATUS
    if [ "$STOPERRORMSG" != "" ] ; then
      echo $STOPERRORMSG
    fi
    rm -f /var/lock/slurm
}

getpidfile() {
    dpidfile=`grep -i ${1}pid $CONFDIR/slurm.conf | grep -v '^ *#'`
    if [ $? = 0 ]; then
        dpidfile=${dpidfile##*=}
        dpidfile=${dpidfile%#*}
    else
        dpidfile=/var/run/${1}.pid
    fi

    echo $dpidfile
}

#
# status() with slight modifications to take into account
# instantiations of job manager slurmd's, which should not be
# counted as "running"
#

slurmstatus() {
    base=${1##*/}

    pidfile=$(getpidfile $base)

    pid=`pidof -o $$ -o $$PPID -o %PPID -x $1 || \
         pidof -o $$ -o $$PPID -o %PPID -x ${base}`

    if [ -f $pidfile ]; then
        read rpid < $pidfile
        if [ "$rpid" != "" -a "$pid" != "" ]; then
            for i in $pid ; do
                if [ "$i" = "$rpid" ]; then
                    echo "${base} (pid $pid) is running..."
                    return 0
                fi
            done
        elif [ "$rpid" != "" -a "$pid" = "" ]; then
#           Due to change in user id, pid file may persist
#           after slurmctld terminates
            if [ "$base" != "slurmctld" ] ; then
               echo "${base} dead but pid file exists"
            fi
            return 1
       fi

    fi

    if [ "$base" = "slurmctld" -a "$pid" != "" ] ; then
        echo "${base} (pid $pid) is running..."
        return 0
    fi

    echo "${base} is stopped"

    return 3
}

#
# stop slurm daemons,
# wait for termination to complete (up to 10 seconds) before returning
#

slurmstop() {
    for prog in $DAEMONLIST ; do
       stop $prog
       for i in 1 2 3 4
       do
          sleep $i
          slurmstatus $prog
          if [ $? != 0 ]; then
             break
          fi
       done
    done
}

#
# The pathname substitution in daemon command assumes prefix and
# exec_prefix are same.  This is the default, unless the user requests
# otherwise.
#
# Any node can be a slurm controller and/or server.
#
case "$1" in
    start)
        start slurmctld "$SLURMCTLD_OPTIONS"
        ;;
    startclean)
        SLURMCTLD_OPTIONS="-c $SLURMCTLD_OPTIONS"
        start slurmctld "$SLURMCTLD_OPTIONS"
        ;;
    stop)
        slurmstop
        ;;
    status)
        for prog in $DAEMONLIST ; do
           slurmstatus $prog
        done
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    force-reload)
        $0 stop
        $0 start
        ;;
    condrestart)
        if [ -f /var/lock/subsys/slurm ]; then
            for prog in $DAEMONLIST ; do
                 stop $prog
                 start $prog
            done
        fi
        ;;
    reconfig)
        for prog in $DAEMONLIST ; do
            PIDFILE=$(getpidfile $prog)
            start-stop-daemon --stop --signal HUP --pidfile \
              "$PIDFILE" --quiet $prog
        done
        ;;
    test)
        for prog in $DAEMONLIST ; do
            echo "$prog runs here"
        done
        ;;
    *)
        echo "Usage: $0 {start|startclean|stop|status|restart|reconfig|condrestart|tes$
        exit 1
        ;;
esac
EOF

cat <<EOF


***************************************************************
*  Installation details                                       *
***************************************************************

Root password for MySQL database: '$PW'

MySQL user for slurmctrl  : '$DB_USER'
Password for that user    : '$PW_slurm'
Database for accounting   : '$DB_ACCOUNTING'
Database for jobcompletion: '$DB_JOBCOMPLETION'


EOF

sudo service start slurmctld
