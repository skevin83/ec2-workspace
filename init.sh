#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y curl wget nano git docker.io iptables fail2ban awscli
sudo systemctl enable --now docker
sudo usermod -aG docker ubuntu
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo systemctl enable --now fail2ban
sudo fail2ban-client set sshd bantime 10y
sudo chown -R ubuntu:ubuntu /mnt
ln -s /mnt /home/ubuntu/hdd
instanceid=`/usr/bin/curl -s http://169.254.169.254/latest/meta-data/instance-id` 
aws ec2 associate-address --allocation-id "eipalloc-f950ae9d" --instance-id $instanceid --allow-reassociation --region ap-northeast-1
sudo curl --silent --location -o /usr/local/bin/kubectl \
   https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
sudo pip3 install --upgrade awscli && hash -r
sudo yum -y install jq gettext bash-completion moreutils
eksctl completion bash >> ~/.bash_completion
source /etc/profile.d/bash_completion.sh
source ~/.bash_completion
kubectl completion bash >>  ~/.bash_completion
source /etc/profile.d/bash_completion.sh
source ~/.bash_completion
echo 'export LBC_VERSION="v2.0.0"' >>  ~/.bash_profile
source  ~/.bash_profile
echo 'yq() {
  docker run --rm -i -v "${PWD}":/workdir mikefarah/yq yq "$@"
}' | tee -a ~/.bashrc && source ~/.bashrc
for command in kubectl jq envsubst aws
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done
cat <<EOT >> ~/.bashrc
export EDITOR="nano"
alias sshagent='eval \`ssh-agent -s\`'
alias ssht="ssh -D 30000 -f -C -q -N workspace"
alias l="ls -lah"
alias gitfolder="cd ~/github"
alias sshfolder="cd ~/.ssh"
alias gitk8s="cd ~/github/infra/k8s"
alias k="kubectl"
alias kg="kubectl get"
alias kd="kubectl describe"
alias kgp="kubectl get pod"
alias kgn="kubectl get node"
alias kgs="kubectl get service"
alias kgi="kubectl get ingress"
alias kgsts="kubectl get statefulset"
alias kgd="kubectl get deployment"
alias kdp="kubectl describe pod"
alias kdn="kubectl describe node"
alias kds="kubectl describe service"
alias kdi="kubectl describe ingress"
alias kdsts="kubectl describe statefulset"
alias kdd="kubectl describe deployment"
EOT
source helm.sh
curl -fsSL https://starship.rs/install.sh | bash
echo 'eval "$(starship init bash)"' >> ~/.bashrc
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform