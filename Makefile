# Create the SSH key pair used to connect to the hosts.
ssh:
	mkdir .ssh && ssh-keygen -t rsa -b 4096 -f .ssh/demo_key
