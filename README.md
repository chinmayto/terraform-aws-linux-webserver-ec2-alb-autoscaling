# Web Tier using AWS EC2 Linux - Multi-AZ with ALB with auto-scaling

Deploying Linux Server EC2 Instances in AWS using Terraform with ALB and Multi AZ with auto scaling

![Alt text](/images/diagram.png)

At first we created an AMI using EC2-Auto-Scaling-Lab.yaml with help of cloud formation:

![Alt text](/images/cf1.png)

![Alt text](/images/cf2.png)

![Alt text](/images/cf3.png)

AMI Created from above running instance:

![Alt text](/images/ami.png)


Following modules are involved:
1. vpc module - to create vpc, public subnets, internet gateway, security groups and route tables
2. web module - to create launch template, auto scaling group, and scaling policy
3. main module - Above modules get called in main config.

Terraform Plan Output:
```
Plan: 21 to add, 0 to change, 0 to destroy.
```

Terraform Apply Output:
```
Apply complete! Resources: 21 added, 0 changed, 0 destroyed.

Outputs:

alb_dns_name = "tf-lb-20240115192631610100000006-1207062642.us-east-1.elb.amazonaws.com"
public_subnets = [
  "subnet-0cb5abe2c789f67fd",
  "subnet-090cdd4f928ef6e99",
  "subnet-00ea14a4592171b09",
  "subnet-01a43183a9f0e4f77",
]
security_group_alb = [
  "sg-050b6f98063fe0c31",
]
security_groups_ec2 = [
  "sg-0ba4cd2f63be00161",
]
```
Single running instance, auto scaling policy started only 1 instance (desired capacity):

![Alt text](/images/vm1.png)

![Alt text](/images/vmlist1.png)

After stressing single running EC2, scaling out initiated to start 4 (max capacity) instances:

![Alt text](/images/stress.png)

![Alt text](/images/scaledec2.png)

![Alt text](/images/vm2.png)

![Alt text](/images/vm3.png)

![Alt text](/images/vm4.png)

ASG Scale out Activity log:
![Alt text](/images/scaleoutlog.png)

After rebooting high CPU usage instance, auto scaling in is triggered, to stop 3 instances and keep only 1 running (desired capacity):

![Alt text](/images/stresszero.png)

![Alt text](/images/scaleinec2.png)

Only running instance:

![Alt text](/images/vmscalein.png)

ASG Scale in Activity log:

![Alt text](/images/scaleinlog.png)

Terraform Destroy Output:
```
Plan: 0 to add, 0 to change, 21 to destroy.

Destroy complete! Resources: 21 destroyed.
```