
PORT_DEVICE = 6000
PORT_LOCAL = 6000
XPCSHELL = ~/bin/xulrunner-sdk/bin/xpcshell
ADB = ~/bin/android-sdk/platform-tools/adb

package:
	cd ./${FOLDER} && zip -Xr ./application.zip ./* -x application.zip

packaged: package
	${ADB} push ./${FOLDER}/application.zip /data/local/tmp/b2g/${FOLDER}/application.zip

hosted:
	${ADB} push ./${FOLDER}/manifest.webapp /data/local/tmp/b2g/${FOLDER}/manifest.webapp
	${ADB} push ./${FOLDER}/metadata.json /data/local/tmp/b2g/${FOLDER}/metadata.json

install:
	${ADB} forward tcp:$(PORT_LOCAL) tcp:$(PORT_DEVICE)
	@echo "!!! CONFIRM THE PROMPT on the phone !!!"
	${XPCSHELL} install.js ${FOLDER} $(PORT_LOCAL)
