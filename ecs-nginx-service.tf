# Nginx Task Definition
resource "aws_ecs_task_definition" "aws-ecs-task" {
    family = "nginx-app"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    container_definitions = jsonencode([
        {   
            name = "nginxcontainer"
            image  = "nginx:latest"
            portmappings = [{containerPort = 80, protocol = "tcp"}]

        }
    ] )
}

 # Security Group for ECS
resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# ECS Service
resource "aws_ecs_service" "service-app" {
    name = "nginx-ecs service"
    cluster = aws_ecs_cluster.ecs-cluster.id
    task_definition = aws_ecs_task_definition.aws-ecs-task.arn
    desired_count = 1
    launch_type = "FARGATE"

    network_configuration {
      subnets = var.private_subnet_cidr
      security_groups = [aws_security_group.ecs_service_sg.id]

    }


}