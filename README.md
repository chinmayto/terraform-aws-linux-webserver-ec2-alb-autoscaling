# Web Tier using AWS EC2 Linux (Multi-AZ with ALB)

Deploying Linux Server EC2 Instances in AWS using Terraform with ALB and Multi AZ

![Alt text](/images/diagram.png)

1. vpc module - to create vpc, public subnets, internet gateway, security groups and route tables
2. web module - to create Linux Web EC2 instances with userdata script to display instance metadata using latest Amazon Linux ami in multiple subnets created in vpc module
3. alb module - to create an application load balancer with target group containing ec2 instances from web module
4. main module - Above modules get called in main config.

Terraform Plan Output:
```
Plan: 25 to add, 0 to change, 0 to destroy.
```

Terraform Apply Output:
```
Apply complete! Resources: 25 added, 0 changed, 0 destroyed.

Outputs:

alb_dns_name = "tf-lb-20231130193349621000000004-1500099737.us-east-1.elb.amazonaws.com"
ec2_instance_ids = [
  "i-05eb93181588e2b83",
  "i-09431707f204e99ad",
  "i-067704933b1bc4b3b",
  "i-07bc08112198ff133",
]
public_subnets = [
  "subnet-0572381b597ce0e3e",
  "subnet-07362455ed02e7430",
  "subnet-012ba7859b4b4544f",
  "subnet-0dd38dcbf0c266cae",
]
security_group_alb = [
  "sg-078f66822ee38a307",
]
security_groups_ec2 = [
  "sg-0e6c84120d02ed1ed",
]
```

Running Website:

![Alt text](/images/vm1.png)

![Alt text](/images/vm2.png)

![Alt text](/images/vm3.png)

![Alt text](/images/vm4.png)

VPC:
![Alt text](/images/vpc.png)

EC2:
![Alt text](/images/ec2.png)

ALB:
![Alt text](/images/alb.png)

Terraform Destroy Output:
```
Plan: 0 to add, 0 to change, 25 to destroy.

Destroy complete! Resources: 25 destroyed.
```