# disable the restart dialogue and install several packages
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
sudo apt-get update
sudo apt install wget git python3 python3-venv build-essential net-tools awscli -y

# install CUDA (from https://developer.nvidia.com/cuda-downloads)
wget https://developer.download.nvidia.com/compute/cuda/12.0.0/local_installers/cuda_12.0.0_525.60.13_linux.run
sudo sh cuda_12.0.0_525.60.13_linux.run --silent

# install git-lfs
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
sudo apt-get install git-lfs
sudo -u ubuntu git lfs install --skip-smudge

# download the SD model v2.1 and move it to the SD model directory
sudo -u ubuntu git clone --depth 1 https://huggingface.co/runwayml/stable-diffusion-inpainting
cd stable-diffusion-inpainting/
sudo -u ubuntu git lfs pull --include "sd-v1-5-inpainting.ckpt"
sudo -u ubuntu git lfs install --force
cd ..
mv stable-diffusion-inpainting/sd-v1-5-inpainting.ckpt stable-diffusion-webui/models/Stable-diffusion/
rm -rf stable-diffusion-inpainting/

# download the corresponding config file and move it also to the model directory (make sure the name matches the model name)
wget https://github.com/runwayml/stable-diffusion/blob/main/configs/stable-diffusion/v1-inpainting-inference.yaml
cp v1-inpainting-inference.yaml stable-diffusion-webui/models/Stable-diffusion/sd-v1-5-inpainting.yaml


# change ownership of the web UI so that a regular user can start the server
sudo chown -R ubuntu:ubuntu stable-diffusion-webui/

# start the server as user 'ubuntu'
sudo -u ubuntu nohup bash stable-diffusion-webui/webui.sh --listen > log.txt

