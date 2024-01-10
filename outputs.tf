output "vpc_id"{
    value = aws_vpc.vpc.id
}

output "instance_ids" {
  value = aws_instance.ec2_instances.*.id
}

