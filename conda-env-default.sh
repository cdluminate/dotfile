#!/usr/bin/bash
export PATH=~/anaconda3/bin:${PATH}

# conda init for bash
__conda_setup="$('/home/lumin/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/lumin/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/lumin/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/lumin/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup


if (conda info --envs | grep -q default); then
	conda activate default
else
	conda create --name default --yes
	conda activate default
fi
conda env list

# pytorch 2.0
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch-nightly -c nvidia
