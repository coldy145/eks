              #!/bin/bash -vxe
              set -o xtrace

              echo "Installing awscli"
              yum -y install awscli
              echo "enable autocomplete function for aws cli"
              echo complete -C "/bin/aws_completer" aws >> /etc/profile.d/bash_completion.sh

              echo "Installation AWS SSM agent"
              yum install -y https://s3.eu-central-1.amazonaws.com/amazon-ssm-eu-central-1/latest/linux_amd64/amazon-ssm-agent.rpm
              
              echo "Installation of qualys-cloud-agent"
              aws s3api get-object --bucket ${var.bucket_name} --key qualys/QualysCloudAgent.rpm /tmp/QualysCloudAgent.rpm
              yum -y localinstall --nogpgcheck /tmp/QualysCloudAgent.rpm
              /usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=8b421e12-5227-4209-af83-dcc4dac168d2 CustomerId=2bde6659-3a5f-d0fb-82ef-8706b7deeebe
              service qualys-cloud-agent restart
              