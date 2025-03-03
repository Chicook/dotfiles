#!/usr/bin/env bash
# backup-twitter.sh by Amory Meltzer
# Twitter backup script, modified from:
# http://blog.jphpsf.com/2012/05/07/backing-up-your-twitter-account-with-t/

DAY=$(date +'%Y-%m-%d_%H%M%S')
FOLDERPATH="$HOME/Dropbox/twitter_backup/"$DAY
twitname=$TWITTER_USERNAME

mkdir "$FOLDERPATH"


echo "Backing up tweets..."
t timeline $twitname --csv --number 3000 > $FOLDERPATH/tweets-$DAY.csv
echo "Backing up retweets..."
t retweets --csv --number 3000 > $FOLDERPATH/retweets-$DAY.csv
echo "Backing up mentions..."
t mentions --csv --number 3000 > $FOLDERPATH/mentions-$DAY.csv
echo "Backing up favorites..."
t favorites --csv --number 3000 > $FOLDERPATH/favorites-$DAY.csv
echo "Backing up DM received..."
t direct_messages --csv --number 3000 > $FOLDERPATH/dm_received-$DAY.csv
echo "Backing up DM sent..."
t direct_messages_sent --csv --number 3000 > $FOLDERPATH/dm_sent-$DAY.csv
echo "Backing up followers..."
t followers --csv > $FOLDERPATH/followers-$DAY.csv
t followers > $FOLDERPATH/followers-$DAY.txt
echo "Backing up followings..."
t followings --csv > $FOLDERPATH/followings-$DAY.csv

# echo "Backing up lists..."
# listlist=$(t lists)
# listlist=$(echo $listlist | sed -e 's/$twitname\///g')
# for i in $listlist
# do
#     t list members $twitname/$i --csv > $FOLDERPATH/list-$i-$DAY.csv
# done

echo -e "\nBacked up the following:"
echo -e "- "`wc -l $FOLDERPATH/tweets-$DAY.csv|cut -d" " -f 1`" tweets"
echo -e "- "`wc -l $FOLDERPATH/retweets-$DAY.csv|cut -d" " -f 1`" retweets"
echo -e "- "`wc -l $FOLDERPATH/mentions-$DAY.csv|cut -d" " -f 1`" mentions"
echo -e "- "`wc -l $FOLDERPATH/favorites-$DAY.csv|cut -d" " -f 1`" favorites"
echo -e "- "`wc -l $FOLDERPATH/dm_received-$DAY.csv|cut -d" " -f 1`" DM received"
echo -e "- "`wc -l $FOLDERPATH/dm_sent-$DAY.csv|cut -d" " -f 1`" DM sent"
echo -e "- "`wc -l $FOLDERPATH/followings-$DAY.csv|cut -d" " -f 1`" followings"
echo -e "- "`wc -l $FOLDERPATH/followers-$DAY.csv|cut -d" " -f 1`" followings"
echo -e "- "`wc -l $FOLDERPATH/list-*-$DAY.csv|cut -d" " -f 1`" lists"

echo -e `t followers | wc -l`" followers"

echo -e "\nDone"
