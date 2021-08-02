import os, sys, glob
import multiprocessing as mp
from multiprocessing import Pool, cpu_count
import time


fs_R1 = glob.glob("Volumes/LaCie/MAZTER_SEQ/???/*1.fastq.gz")
fs_R2 = glob.glob("Volumes/LaCie/MAZTER_SEQ/???/*2.fastq.gz")


for f in fs_R1:
	sid = f.split('/')[-1]
	sid_in = sid					# Read1 trimming input : U20XXX_1.fastq.gz
	sid_out = 'trimmed_wo_' + sid_in	# Read1 trimming output : trimmed_wo_U20XXX_1.fastq.gz
	cmd = ' '.join(['~/.local/bin/cutadapt', '-u 3 -a "A{100}"', '-o', +sid_out, +sid_in])

	print ("\n\n*****************************************************************")
    print (sid)
    print ("*****************************************************************\n\n")
    time.sleep(1)

    print(cmd)
    print("\n")
    time.sleep(1)

    os.system(cmd)


for f in fs_R2:
	sid = f.split('/')[-1]
	sid_in = sid_in                        # Read2 trimming input : U20XXX_2.fastq.gz
	sid_out1 = 'T.trimmed_wo_' + sid_in    # Read2 first trimming : T.trimmed_wo_U20XXX_2.fastq.gz
	sid_out2 = 'adapter.' + sid_out1       # Read2 Second trimming : adapter.T.trimmed_wo_U20XXX_2.fastq.gz
	sid_out3 = 'complete_' + sid_out2      # Read2 final trimming : complete_adapter.T.trimmed_wo_U20XXX_2.fastq.gz

	cmd1 = ' '.join(['~/.local/bin/cutadapt', '-g "T{100}"', '-o', +sid_out1, +sid_in])

	cmd2 = ' '.join(['~/.local/bin/cutadapt', '-a AGATCGGAAGAG', '-o', +sid_out2, +sid_out1])

	cmd3 = ' '.join(['~/.local/bin/cutadapt', '-u -3', '-o', +sid_out3, +sid_out2])

	print ("\n\n*****************************************************************")
    print (sid)
    print ("*****************************************************************\n\n")
    time.sleep(1)

    print(cmd1)
    print("\n")
    time.sleep(1)
    os.system(cmd1)

    print(cmd2)
    print("\n")
    time.sleep(1)
    os.system(cmd2)

    print(cmd3)
    print("\n")
    time.sleep(1)
    os.system(cmd3)

