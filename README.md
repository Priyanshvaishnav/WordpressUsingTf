Deploying WordPress on AWS with RDS using Terraform and Docker
This project demonstrates how to deploy a WordPress site on AWS using Amazon RDS for MySQL with Terraform and Docker. The setup involves creating a VPC, subnets, security groups, an EC2 instance for WordPress, and an RDS instance for the MySQL database.

Prerequisites
Terraform, Docker, AWS Account
Step 1 : Terraform setup 
   - Setup AWS Credentials
   - create terraform files
   - Initialize and Apply Terraform
Step 2 : Docker Setup
   - create Dockerfile for wordpress , apache-php
   - create docker-compose.yml file
   - build and push image
