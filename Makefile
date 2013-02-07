PORT_DEVICE = 6000
PORT_LOCAL = 6000
XPCSHELL = ~/bin/xulrunner-sdk/bin/xpcshell
ADB = ~/bin/android-sdk/platform-tools/adb
ID ?= ${shell basename ${FOLDER}}

package:
	@echo "ZIPPING ${FOLDER} into application.zip"
	@cd ${FOLDER} && zip -Xr ./application.zip ./* -x application.zip *.appcache

packaged: package
	@echo "PUSHING *${ID}* as packaged app"
	@${ADB} push ${FOLDER}/application.zip /data/local/tmp/b2g/${ID}/application.zip

hosted:
	@echo "PUSHING *${ID}* as hosted app"
	@${ADB} push ${FOLDER}/manifest.webapp /data/local/tmp/b2g/${ID}/manifest.webapp
	@${ADB} push ${FOLDER}/metadata.json /data/local/tmp/b2g/${ID}/metadata.json

install:
	@echo "FORWARDING device port $(PORT_DEVICE) to $(PORT_LOCAL)"
	@${ADB} forward tcp:$(PORT_LOCAL) tcp:$(PORT_DEVICE)
	@echo "!!! CONFIRM THE PROMPT on the phone !!!"
	${XPCSHELL} install.js ${ID} $(PORT_LOCAL)
