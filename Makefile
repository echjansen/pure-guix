.PHONY: pull build-t15 vm-t15 t15 home-echjansen home-gjansen

# Permanently update local Guix to pinned channels.
# Use only when intentionally bumping the fleet's channel pins.
pull:
	guix pull -C channels.scm

# Build without activating — validates the config safely
build-t15:
	guix time-machine -C channels.scm -- \
		system -L modules build systems/t15.scm

# Interactive VM test before deploying to real hardware
vm-t15:
	guix time-machine -C channels.scm -- \
		system -L modules vm systems/t15.scm

# Reconfigure the T15
t15:
	sudo guix time-machine -C channels.scm -- \
		system -L modules reconfigure systems/t15.scm

# Reconfigure home environments
home-echjansen:
	guix time-machine -C channels.scm -- \
		home -L modules reconfigure homes/echjansen.scm
