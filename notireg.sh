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

for i in $( ls $SOURCE_DIR );
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
        #just checking
        echo "bag from $src to $tgt"
        #bag and move to scratch space
        $BAGIT_DIR/bag create $SCRATCH_DIR/$i $src
        #if $current exists
                #generate checksum for scratch bag
                scratch_sum=$( md5sum  $scratch )
                #generate checksum for current bag
                current_sum=$( md5sum $current )
                #if scratch_sum equals current_sum
                        #log that it hasn't been updated
                        #rm -rf $scratch
                        #end
                #else
                        #mv $scratch $tgt
                        #rm $current
                        #ln -s $tgt $current
        #else
                #move $scratch to $tgt
                #create the 'current' symlink to $tgt


done

