#!/bin/bash
# script to bag up directories from the PDC rsync destination
# sbm 20120419

# root source directory - contains content directories to be bagged
SOURCE_DIR=/mnt/polar1/pdc_sync/ipy
# root destination directory - root directory where to dump the bags
DEST_DIR=/mnt/irods01/bags
# root scratch directory - temporary location for the bags while they are compared to existing
SCRATCH_DIR=/mnt/irods01/scratch
# path to bagit executables
BAGIT_DIR=/usr/local/bagit/bin
# damn dirty logging because I dunno how to do it properly
LOG_DIR=/var/log/notirods


#for i in $( ls $SOURCE_DIR );
for i in 756 622 9885
do
        timestamp=$(date +%Y%m%d%H%M%S)
        # source directory to be used in this iteration
        src=$SOURCE_DIR/$i
        # full target directory
        tgt=$DEST_DIR/$i/$timestamp
        # full scratch directory
        scratch=$SCRATCH_DIR/$i
        # construct location of 'current' pointer
        current=$DEST_DIR/$i/current
        # log file name
        logfile=$LOG_DIR/notireg.$(date +%Y%m%d)
        #just checking
        echo "bag from $src to $tgt"
        #bag and move to scratch space
        mkdir $SCRATCH_DIR/$i
        $BAGIT_DIR/bag create $SCRATCH_DIR/$i $src
        #if $current exists
        if [ -L $current ]; then
                #we know there's a previous verison. is it the same as the one we have?
                #if scratch equals current
                if diff -qr $current $scratch ; then
                        #the data hasn't changed.
                        #log that it hasn't been updated
                        echo `date`" [MATCH] bag $current is up to date." >> $logfile
                        #delete scratch version
                        rm -rf $scratch
                        #end
                else
                        #the data has changed. save the new bag and make it current.
                        #move the scratch version to its home in storage
                        mv $scratch $tgt
                        #remove the current pointer
                        rm $current
                        #and recreate it pointing at the new version
                        ln -s $tgt $DEST_DIR/$i/current
                        #log that it has been updated.
                        echo `date`" [UPDATE] bag $tgt is now current" >> $logfile
                fi
        else
                #it is new content. move it to storage and make it current.
		#make parent directory
		mkdir $DEST_DIR/$i
                #move $scratch to $tgt
                mv $scratch $tgt
                #create the 'current' symlink to $tgt
                ln -s $tgt $current
                echo `date`" [NEW] bag $tgt is new content." >> $logfile
        fi
done
