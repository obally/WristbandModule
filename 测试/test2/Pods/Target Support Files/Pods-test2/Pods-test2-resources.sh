#!/bin/sh
set -e

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

case "${TARGETED_DEVICE_FAMILY}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}"
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\""
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\""
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH"
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "IQKeyboardManager/IQKeyboardManager/Resources/IQKeyboardManager.bundle"
  install_resource "MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/back.imageset/返回@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/back.imageset/返回@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_0.imageset/ic_battery_0.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_0.imageset/ic_battery_0@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_0.imageset/ic_battery_0@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_1.imageset/ic_battery_1.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_1.imageset/ic_battery_1@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_1.imageset/ic_battery_1@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_2.imageset/ic_battery_2.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_2.imageset/ic_battery_2@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_2.imageset/ic_battery_2@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_3.imageset/ic_battery_3.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_3.imageset/ic_battery_3@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_3.imageset/ic_battery_3@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_4.imageset/ic_battery_4.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_4.imageset/ic_battery_4@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_4.imageset/ic_battery_4@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip1.imageset/ic_choosetip1.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip1.imageset/ic_choosetip1@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip1.imageset/ic_choosetip1@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip2.imageset/ic_choosetip2.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip2.imageset/ic_choosetip2@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip2.imageset/ic_choosetip2@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_clock_unchoosetip.imageset/ic_clock_unchoosetip.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_clock_unchoosetip.imageset/ic_clock_unchoosetip@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_clock_unchoosetip.imageset/ic_clock_unchoosetip@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_close.imageset/ic_close@1x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_close.imageset/ic_close@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_close.imageset/ic_close@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_deepsleep.imageset/ic_deepsleep.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_deepsleep.imageset/ic_deepsleep@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_deepsleep.imageset/ic_deepsleep@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_edit.imageset/ic_edit.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_edit.imageset/ic_edit@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_edit.imageset/ic_edit@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_goon.imageset/ic_goon.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_goon.imageset/ic_goon@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_goon.imageset/ic_goon@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_kal.imageset/ic_kal.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_kal.imageset/ic_kal@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_kal.imageset/ic_kal@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_km.imageset/ic_km.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_km.imageset/ic_km@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_km.imageset/ic_km@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_poorsleep.imageset/ic_poorsleep.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_poorsleep.imageset/ic_poorsleep@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_poorsleep.imageset/ic_poorsleep@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_step.imageset/ic_step.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_step.imageset/ic_step@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_step.imageset/ic_step@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/info.imageset/info.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/info.imageset/info@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/info.imageset/info@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s1.imageset/sbgl_s1.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s1.imageset/sbgl_s1@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s1.imageset/sbgl_s1@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s2.imageset/sbgl_s2.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s2.imageset/sbgl_s2@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s2.imageset/sbgl_s2@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan-small.imageset/shouhuan.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan-small.imageset/shouhuan@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan-small.imageset/shouhuan@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan.imageset/shouhuan.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan.imageset/shouhuan@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan.imageset/shouhuan@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_bell.imageset/tab3_ic_bell.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_bell.imageset/tab3_ic_bell@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_bell.imageset/tab3_ic_bell@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_clock.imageset/tab3_ic_clock.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_clock.imageset/tab3_ic_clock@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_clock.imageset/tab3_ic_clock@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_phone.imageset/tab3_ic_phone.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_phone.imageset/tab3_ic_phone@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_phone.imageset/tab3_ic_phone@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_shouh.imageset/tab3_ic_shouh.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_shouh.imageset/tab3_ic_shouh@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_shouh.imageset/tab3_ic_shouh@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_update.imageset/tab3_ic_update.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_update.imageset/tab3_ic_update@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_update.imageset/tab3_ic_update@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips.imageset/tips.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips.imageset/tips@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips.imageset/tips@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips_shouhuan.imageset/tips_shouhuan.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips_shouhuan.imageset/tips_shouhuan@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips_shouhuan.imageset/tips_shouhuan@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/Model.xcdatamodeld"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "IQKeyboardManager/IQKeyboardManager/Resources/IQKeyboardManager.bundle"
  install_resource "MJRefresh/MJRefresh/MJRefresh.bundle"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/back.imageset/返回@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/back.imageset/返回@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_0.imageset/ic_battery_0.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_0.imageset/ic_battery_0@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_0.imageset/ic_battery_0@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_1.imageset/ic_battery_1.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_1.imageset/ic_battery_1@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_1.imageset/ic_battery_1@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_2.imageset/ic_battery_2.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_2.imageset/ic_battery_2@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_2.imageset/ic_battery_2@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_3.imageset/ic_battery_3.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_3.imageset/ic_battery_3@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_3.imageset/ic_battery_3@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_4.imageset/ic_battery_4.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_4.imageset/ic_battery_4@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_battery_4.imageset/ic_battery_4@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip1.imageset/ic_choosetip1.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip1.imageset/ic_choosetip1@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip1.imageset/ic_choosetip1@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip2.imageset/ic_choosetip2.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip2.imageset/ic_choosetip2@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_choosetip2.imageset/ic_choosetip2@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_clock_unchoosetip.imageset/ic_clock_unchoosetip.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_clock_unchoosetip.imageset/ic_clock_unchoosetip@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_clock_unchoosetip.imageset/ic_clock_unchoosetip@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_close.imageset/ic_close@1x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_close.imageset/ic_close@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_close.imageset/ic_close@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_deepsleep.imageset/ic_deepsleep.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_deepsleep.imageset/ic_deepsleep@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_deepsleep.imageset/ic_deepsleep@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_edit.imageset/ic_edit.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_edit.imageset/ic_edit@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_edit.imageset/ic_edit@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_goon.imageset/ic_goon.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_goon.imageset/ic_goon@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_goon.imageset/ic_goon@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_kal.imageset/ic_kal.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_kal.imageset/ic_kal@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_kal.imageset/ic_kal@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_km.imageset/ic_km.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_km.imageset/ic_km@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_km.imageset/ic_km@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_poorsleep.imageset/ic_poorsleep.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_poorsleep.imageset/ic_poorsleep@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_poorsleep.imageset/ic_poorsleep@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_step.imageset/ic_step.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_step.imageset/ic_step@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/ic_step.imageset/ic_step@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/info.imageset/info.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/info.imageset/info@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/info.imageset/info@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s1.imageset/sbgl_s1.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s1.imageset/sbgl_s1@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s1.imageset/sbgl_s1@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s2.imageset/sbgl_s2.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s2.imageset/sbgl_s2@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/sbgl_s2.imageset/sbgl_s2@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan-small.imageset/shouhuan.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan-small.imageset/shouhuan@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan-small.imageset/shouhuan@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan.imageset/shouhuan.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan.imageset/shouhuan@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/shouhuan.imageset/shouhuan@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_bell.imageset/tab3_ic_bell.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_bell.imageset/tab3_ic_bell@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_bell.imageset/tab3_ic_bell@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_clock.imageset/tab3_ic_clock.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_clock.imageset/tab3_ic_clock@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_clock.imageset/tab3_ic_clock@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_phone.imageset/tab3_ic_phone.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_phone.imageset/tab3_ic_phone@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_phone.imageset/tab3_ic_phone@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_shouh.imageset/tab3_ic_shouh.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_shouh.imageset/tab3_ic_shouh@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_shouh.imageset/tab3_ic_shouh@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_update.imageset/tab3_ic_update.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_update.imageset/tab3_ic_update@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tab3_ic_update.imageset/tab3_ic_update@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips.imageset/tips.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips.imageset/tips@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips.imageset/tips@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips_shouhuan.imageset/tips_shouhuan.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips_shouhuan.imageset/tips_shouhuan@2x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/wristBandImage.xcassets/tips_shouhuan.imageset/tips_shouhuan@3x.png"
  install_resource "WristBand/WristBand/SYWristband/WristbandComponent/Source/Model.xcdatamodeld"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "$XCASSET_FILES" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
