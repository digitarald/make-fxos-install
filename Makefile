PORT_DEVICE = 6000
PORT_LOCAL = 6000
XPCSHELL = ~/bin/xulrunner-sdk/bin/xpcshell
ADB = ~/bin/android-sdk/platform-tools/adb
APP_NAME = my_app

package:
	cd ${FOLDER} && zip -Xr ./application.zip ./* -x application.zip

packaged: package
	${ADB} push ${FOLDER}/application.zip /data/local/tmp/b2g/${APP_NAME}/application.zip

hosted:
	${ADB} push ${FOLDER}/manifest.webapp /data/local/tmp/b2g/${APP_NAME}/manifest.webapp
	${ADB} push ${FOLDER}/metadata.json /data/local/tmp/b2g/${APP_NAME}/metadata.json

install:
	${ADB} forward tcp:$(PORT_LOCAL) tcp:$(PORT_DEVICE)
	@echo "!!! CONFIRM THE PROMPT on the phone !!!"
	${XPCSHELL} install.js ${APP_NAME} $(PORT_LOCAL)
