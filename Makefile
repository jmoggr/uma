all: build

build:
	mkdir -p build
	# create rules for IDing MTP devices on device removal, see script for details
	./bin/create-mtp-removal-rules > build/70-mtp-remove.rules

clean:
	rm -rf build

install:
	mkdir -p /etc/opt/uma
	cp uma.conf /etc/opt/uma
	
	mkdir -p /opt/uma
	cp -r hooks /opt/uma
	
	mkdir -p /opt/uma/bin
	cp bin/uma-cleanup /opt/uma/bin
	cp bin/uma-hookrunner /opt/uma/bin
	cp bin/uma-mount /opt/uma/bin
	cp bin/uma-common.sh /opt/uma/bin
	
	cp systemd/uma-mount@.service /etc/systemd/system/
	cp systemd/uma-cleanup.service /etc/systemd/system/
	systemctl daemon-reload
	systemctl enable uma-cleanup.service
	
	# the service is effectively started when the udev rule is added to udev
	cp build/70-mtp-remove.rules /etc/udev/rules.d/
	cp udev/80-uma.rules /etc/udev/rules.d/

uninstall:
	# stop newly added devices from being mounted
	rm -f /etc/udev/rules.d/80-uma.rules
	rm -f /etc/udev/rules.d/70-mtp-remove.rules
	
	# unmount all existing devices
	systemctl stop 'uma-mount@*'
	systemctl disable uma-cleanup.service
	
	# remove remaining files
	rm -rf /opt/uma/
	rm -rf /etc/opt/uma
	rm -f /etc/systemd/system/uma-mount@.service
	rm -f /etc/systemd/system/uma-cleanup.service
	systemctl daemon-reload
