# Create the Python virtual environment.
venv:
	python -m venv .venv

# List the inventory with the variables.
inventory:
	ansible-inventory --graph --vars

# Run the uptime command on the inventory hosts.
uptime:
	ansible all -m raw -a uptime
