#!/bin/bash
# script to bag up directories from the PDC rsync destination
# sbm 20120419

# source directory - content to be bagged
SOURCE_DIR=/mnt/polar1/pdc_sync/ipy
# destination directory - where to dump the bags
DEST_DIR=/mnt/irods01/bags
# scratch directory - temporary location for the bags while they are compared to existing
SCRATCH_DIR=/mnt/irods01/scratch

# path to bagit executables
BAGIT_DIR=/usr/local/bagit/bin

for i in $( ls $SOURCE_DIR );
do
        timestamp=$(date +%Y%m%d%H%M%S)
        src=$SOURCE_DIR/$i
        tgt=$DEST_DIR/$i/$timestamp
        scratch=$SCRATCH_DIR/$i
        current=$DEST_DIR/$i/current
        echo "bag from $src to $tgt"
        #bag and move to scratch space
        $BAGIT_DIR/bag create $SCRATCH_DIR/$i $src
        #if $current exists
                #md5sum $scratch
                #md5sum $current
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
