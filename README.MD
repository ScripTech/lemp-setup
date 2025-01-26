# Automating Efficiency: Installing the LEMP Stack with Ease! 🚀

In my recent work with Linode servers, I often relied on the one-click feature to deploy a LEMP stack. However, I found that it didn’t always work as expected. Through investigation and conversations with others, I realized I wasn’t alone—many faced similar challenges.

Thankfully, Linode provides solid documentation for setting up LEMP on bare metal, but manual installation can be time-consuming, especially when managing multiple servers. So, I decided to streamline the process.

I created a Bash script that automates the installation of the LEMP stack, performing all the necessary steps and validating them during execution. This script has saved me countless hours, and I hope it can do the same for others in the community!

Are you dealing with similar deployment challenges? Or have you automated other server management tasks? I’d love to hear your thoughts and ideas! Let’s connect and share knowledge! 💬


## Running LEMP Setup
```bash
user@ezetsu-lab /script curl https://github.com/ScripTech/lemp-setup/blob/main/install-lemp.sh
user@ezetsu-lab /script sudo bash install-lemp.sh
```


**Running Script Screenshot**
![alt text](<lemp-script-v1.png>)
