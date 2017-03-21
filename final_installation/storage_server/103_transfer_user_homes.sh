#!/bin/bash
OLDHOMES=$(cat<<'EOF' | sed '/^$/d'
/wbbi120/home/alk50uw
/wbbi120/home/s216121
/wbbi120/home/wis26sq

/wbbi120/home/frm73du

/wbbi120/home/s216849
/wbbi120/home/jus15cq

/wbbi120/home/ama42bf
/wbbi120/home/ark06eu
/wbbi120/home/jaf81qa
/wbbi120/home/s2046859

/wbbi120/home/phk57mf
/wbbi120/home/top40ub
/wbbi120/home/s323672

/wbbi120/home/binf009
/wbbi120/home/binf017
/wbbi120/home/binf019
/wbbi120/home/binf033
/wbbi120/home/binf034
/wbbi120/home/chk21hr
/wbbi120/home/dak76sx
/wbbi120/home/frf53jh
/wbbi120/home/heb56qy
/wbbi120/home/its2
/wbbi120/home/mal41rx
/wbbi120/home/s171333
/wbbi120/home/s187512
/wbbi120/home/s187864
/wbbi120/home/s194335
/wbbi120/home/s195052
/wbbi120/home/s195127
/wbbi120/home/s196670
/wbbi120/home/s200605
/wbbi120/home/s205020
/wbbi120/home/s211854
/wbbi120/home/s211910
/wbbi120/home/s215634
/wbbi120/home/s216017
/wbbi120/home/s216115
/wbbi120/home/s216125
/wbbi120/home/s216155
/wbbi120/home/s217942
/wbbi120/home/s222434
/wbbi120/home/s227942
/wbbi120/home/s227991
/wbbi120/home/s228165
/wbbi120/home/s228711
/wbbi120/home/s231779
/wbbi120/home/s319932
/wbbi120/home/s320561
/wbbi120/home/s321065
/wbbi120/home/tek47sn
/wbbi120/home/tis55hc
EOF
)

for i in $OLDHOMES;
do
    TO=/new_home/$(basename "$i")
    sudo rsync -avP "$i"/ "$TO"
done

# special case merge two home folders
# get the new UID
NEWUID=$(ls -ld --numeric-uid-gid /wbbi120/home/s229502_cctb/ | grep -v total | awk '{print $3}')
# get the old UID
OLDUID=$(ls -ld --numeric-uid-gid /wbbi120/home/s229502/ | grep -v total | awk '{print $3}')

sudo rsync -avP /wbbi120/home/s229502_cctb/ /new_home/s229502
sudo rsync -avP --usermap="$OLDUID":"$NEWUID" /wbbi120/home/s229502/ /new_home/s229502/home_from_bioinf

# move ngsgrid homes
GRIDHOMES=$(cat<<'EOF' | sed '/^$/d'
/ngsgrid_home/alk50uw
/ngsgrid_home/ark06eu
/ngsgrid_home/binf009
/ngsgrid_home/frf53jh
/ngsgrid_home/jaf81qa
/ngsgrid_home/phk57mf
/ngsgrid_home/s187512
/ngsgrid_home/s194335
/ngsgrid_home/s195052
/ngsgrid_home/s211854
/ngsgrid_home/s211910
/ngsgrid_home/s216017
/ngsgrid_home/s216115
/ngsgrid_home/s216121
/ngsgrid_home/s216849
/ngsgrid_home/s217942
/ngsgrid_home/s228165
/ngsgrid_home/s228711
/ngsgrid_home/s229502
/ngsgrid_home/s231779
/ngsgrid_home/s319932
/ngsgrid_home/s320561
/ngsgrid_home/s321065
/ngsgrid_home/top40ub
EOF
)

for i in $GRIDHOMES;
do
    TO=/new_home/$(basename "$i")
    # get the new UID
    NEWUID=$(ls -ld --numeric-uid-gid "$TO" | grep -v total | awk '{print $3}')
    # get the old UID
    OLDUID=$(ls -ld --numeric-uid-gid "$i" | grep -v total | awk '{print $3}')

    sudo rsync -avP --usermap="$OLDUID":"$NEWUID" "$i"/ "$TO"/ngsgrid_home
done


