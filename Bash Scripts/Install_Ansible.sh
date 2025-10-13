sudo dnf install epel-release -y
sudo dnf install ansible -y

ansible-galaxy install bertvv.rh-base

ssh-keyscan -H 174.138.9.11 >> ~/.ssh/known_hosts
ssh-keyscan -H 188.166.102.252 >> ~/.ssh/known_hosts