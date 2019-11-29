ANDROID_MANIFEST_FILE=${APPCENTER_SOURCE_DIRECTORY}/HockeyAppXamrinAndroid/HockeyAppXamrinAndroid/Properties/AndroidManifest.xml

ANDROID_MAINACTIVITY_FILE=${APPCENTER_SOURCE_DIRECTORY}/HockeyAppXamrinAndroid/HockeyAppXamrinAndroid/MainActivity.cs


SCRIPT_ERROR=0

echo "##[warning][Pre-Build Action] - Checking if all files and environment variables are available..."

if [ -z "${APP_DISPLAY_NAME}" ]

then

echo "##[error][Pre-Build Action] - APP_DISPLAY_NAME variable needs to be defined in App Center!!!"

let "SCRIPT_ERROR += 1"

else

echo "##[warning][Pre-Build Action] - APP_DISPLAY_NAME (${APP_DISPLAY_NAME}) variable - oK!"

fi


if [ -z "${APP_PACKAGE_NAME}" ]

then

echo "##[error][Pre-Build Action] - APP_PACKAGE_NAME variable needs to be defined in App Center!!!"

let "SCRIPT_ERROR += 1"

else

echo "##[warning][Pre-Build Action] - APP_PACKAGE_NAME (${APP_PACKAGE_NAME}) variable - oK!"

fi


if [ -e "${ANDROID_MAINACTIVITY_FILE}" ]

then

echo "##[warning][Pre-Build Action] - MainActivity file found - oK!"

else

echo "##[error][Pre-Build Action] - MainActivity file not found!"

let "SCRIPT_ERROR += 1"

fi

if [ -e "${ANDROID_MANIFEST_FILE}" ]

then

echo "##[warning][Pre-Build Action] - AndroidManifest file found - oK!"

else

echo "##[error][Pre-Build Action] - AndroidManifest file not found!"

let "SCRIPT_ERROR += 1"

fi



if [ ${SCRIPT_ERROR} -gt 0 ]

then

echo "##[error][Pre-Build Action] - There are ${SCRIPT_ERROR} errors."

echo "##[error][Pre-Build Action] - Fix them and try again..."

exit 1 # this will kill the build

# exit # this will exit this script, but continues building

fi


if [ -e "${ANDROID_MAINACTIVITY_FILE}" ]

then

echo "##[command][Pre-Build Action] - Changing the App display name to ${APP_DISPLAY_NAME} And Icon to ${APP_ICON} on Android"

#Icon = "@mipmap/ic_launcher"

#sed -i '' "s/ic_launcher/${APP_ICON}/" ${ANDROID_MAINACTIVITY_FILE}

sed -i '' "s/Label = \"[-a-zA-Z0-9_ ]*\"/Label = \"${APP_DISPLAY_NAME}\"/" ${ANDROID_MAINACTIVITY_FILE}

echo "##[section][Pre-Build Action] - MainActivity.cs File content:"

cat ${ANDROID_MAINACTIVITY_FILE}

echo "##[section][Pre-Build Action] - MainActivity.cs EOF"

fi

if [ -e "${ANDROID_MANIFEST_FILE}" ]

then

echo "##[command][Pre-Build Action] - Updating package name to ${APP_PACKAGE_NAME} in AndroidManifest.xml"

#sed -i '' "s/com.evry.laptu/${APP_PACKAGE_NAME}/" ${ANDROID_MANIFEST_FILE}

sed -i '' 's/package="[^"]*"/package="'$APP_PACKAGE_NAME'"/' $ANDROID_MANIFEST_FILE

echo "##[section][Pre-Build Action] - AndroidMainfest.xml File content:"

cat ${ANDROID_MANIFEST_FILE}

echo "##[section][Pre-Build Action] - AndroidMainfest.xml EOF"

fi