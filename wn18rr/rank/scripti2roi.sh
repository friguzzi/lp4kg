#!/bin/bash
#SBATCH -p computeFat
#SBATCH -N 1                # 1 node
#SBATCH --time 00:30:00     # format: HH:MM:SS
#SBATCH --ntasks-per-node=192 # 4 tasks out of 32
#SBATCH --gres=gpu:0        # 4 gpus per node out of 4
#SBATCH --mem=450GB        # memory per node out of 494000MB 
#SBATCH --job-name=wni2r
#SBATCH --error=myJobi2r.err            # standard error file
#SBATCH --output=myJobi2r.out           # standard output file

/usr/bin/time -v $HOME/bin/swipl --stack-limit=450g inst2ranksoi.pl >rank.pl
