LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

include frameworks/base/media/libstagefright/codecs/common/Config.mk

ifeq ($(BOARD_USES_MFC_FPS), true)
LOCAL_CFLAGS += -DCONFIG_MFC_FPS
endif

ifeq ($(BOARD_USES_FFMPEG), true)
LOCAL_CFLAGS += -DUSE_FFMPEG
endif

LOCAL_SRC_FILES:=                         \
        ACodec.cpp                        \
        AACExtractor.cpp                  \
        AACWriter.cpp                     \
        AMRExtractor.cpp                  \
        AMRWriter.cpp                     \
        AudioPlayer.cpp                   \
        AudioSource.cpp                   \
        AwesomePlayer.cpp                 \
        CameraSource.cpp                  \
        CameraSourceTimeLapse.cpp         \
        VideoSourceDownSampler.cpp        \
        DataSource.cpp                    \
        DRMExtractor.cpp                  \
        ESDS.cpp                          \
        FileSource.cpp                    \
        FLACExtractor.cpp                 \
        HTTPBase.cpp                      \
        JPEGSource.cpp                    \
        MP3Extractor.cpp                  \
        MPEG2TSWriter.cpp                 \
        MPEG4Extractor.cpp                \
        MPEG4Writer.cpp                   \
        MediaBuffer.cpp                   \
        MediaBufferGroup.cpp              \
        MediaDefs.cpp                     \
        MediaExtractor.cpp                \
        MediaSource.cpp                   \
        MediaSourceSplitter.cpp           \
        MetaData.cpp                      \
        NuCachedSource2.cpp               \
        OMXClient.cpp                     \
        OMXCodec.cpp                      \
        OggExtractor.cpp                  \
        SampleIterator.cpp                \
        SampleTable.cpp                   \
        StagefrightMediaScanner.cpp       \
        StagefrightMetadataRetriever.cpp  \
        SurfaceMediaSource.cpp            \
        ThrottledSource.cpp               \
        TimeSource.cpp                    \
        TimedEventQueue.cpp               \
        Utils.cpp                         \
        VBRISeeker.cpp                    \
        WAVExtractor.cpp                  \
        WVMExtractor.cpp                  \
        XINGSeeker.cpp                    \
        avc_utils.cpp                     

ifeq ($(BOARD_USES_FFMPEG), true)
LOCAL_SRC_FILES += \
        FfmpegExtractor.cpp               \
        codecs/ffmpegcodec/dec/FfmpegAudioDecoder.cpp   \
        codecs/ffmpegcodec/dec/FfmpegVideoDecoder.cpp   
endif	


LOCAL_C_INCLUDES:= \
	$(JNI_H_INCLUDE) \
        $(TOP)/frameworks/base/include/media/stagefright/openmax \
        $(TOP)/external/flac/include \
        $(TOP)/external/tremolo \
        $(TOP)/external/openssl/include

ifeq ($(BOARD_USES_FFMPEG), true)	
LOCAL_C_INCLUDES += \
        $(TOP)/external/ffmpeg
endif

LOCAL_SHARED_LIBRARIES := \
        libbinder         \
        libmedia          \
        libutils          \
        libcutils         \
        libui             \
        libsonivox        \
        libvorbisidec     \
        libstagefright_yuv \
        libcamera_client \
        libdrmframework  \
        libcrypto        \
        libssl           \
        libgui           

ifeq ($(BOARD_USES_FFMPEG), true)	
LOCAL_SHARED_LIBRARIES += \
        libffmpeg
endif	

LOCAL_STATIC_LIBRARIES := \
        libstagefright_color_conversion \
        libstagefright_aacenc \
        libstagefright_amrnbenc \
        libstagefright_amrwbenc \
        libstagefright_avcenc \
        libstagefright_m4vh263enc \
        libstagefright_matroska \
        libstagefright_timedtext \
        libvpx \
        libstagefright_mpeg2ts \
        libstagefright_httplive \
        libstagefright_id3 \
        libFLAC \

################################################################################

# The following was shamelessly copied from external/webkit/Android.mk and
# currently must follow the same logic to determine how webkit was built and
# if it's safe to link against libchromium.net

# V8 also requires an ARMv7 CPU, and since we must use jsc, we cannot
# use the Chrome http stack either.
ifneq ($(strip $(ARCH_ARM_HAVE_ARMV7A)),true)
  USE_ALT_HTTP := true
endif

# See if the user has specified a stack they want to use
HTTP_STACK = $(HTTP)
# We default to the Chrome HTTP stack.
DEFAULT_HTTP = chrome
ALT_HTTP = android

ifneq ($(HTTP_STACK),chrome)
  ifneq ($(HTTP_STACK),android)
    # No HTTP stack is specified, pickup the one we want as default.
    ifeq ($(USE_ALT_HTTP),true)
      HTTP_STACK = $(ALT_HTTP)
    else
      HTTP_STACK = $(DEFAULT_HTTP)
    endif
  endif
endif

ifeq ($(HTTP_STACK),chrome)

LOCAL_SHARED_LIBRARIES += \
        liblog           \
        libicuuc         \
        libicui18n       \
        libz             \
        libdl            \

LOCAL_STATIC_LIBRARIES += \
        libstagefright_chromium_http

LOCAL_SHARED_LIBRARIES += libstlport libchromium_net
include external/stlport/libstlport.mk

LOCAL_CPPFLAGS += -DCHROMIUM_AVAILABLE=1

endif  # ifeq ($(HTTP_STACK),chrome)

################################################################################

LOCAL_SHARED_LIBRARIES += \
        libstagefright_amrnb_common \
        libstagefright_enc_common \
        libstagefright_avc_common \
        libstagefright_foundation \
        libdl

LOCAL_CFLAGS += -Wno-multichar

ifeq ($(BOARD_USES_FFMPEG), true)
LOCAL_CFLAGS += -D__STDC_CONSTANT_MACROS
LOCAL_CFLAGS += -DFFMPEG_USER_NATIVEWINDOW_RENDER
endif

ifeq ($(BOARD_USE_SAMSUNG_COLORFORMAT), true)
LOCAL_CFLAGS += -DUSE_SAMSUNG_COLORFORMAT
endif

ifeq ($(BOARD_USE_V4L2), false)
ifeq ($(BOARD_USE_S3D_SUPPORT), true)
LOCAL_CFLAGS += -DS3D_SUPPORT
endif
endif

ifeq ($(BOARD_USE_V4L2_ION), true)
LOCAL_CFLAGS += -DBOARD_USE_V4L2_ION
endif

ifeq ($(USE_ULP_AUDIO), true)
LOCAL_CFLAGS += -DSLSI_ULP_AUDIO
endif

ifeq ($(BOARD_USE_ALP_AUDIO), true)
LOCAL_CFLAGS += -DUSE_ALP_AUDIO
endif

ifeq ($(TARGET_SOC),exynos4x12)
	LOCAL_CFLAGS += -DSAMSUNG_EXYNOS4x12
endif

ifeq ($(BOARD_USES_HDMI),true)
	LOCAL_CFLAGS += -DBOARD_USES_HDMI
endif

ifeq ($(filter-out exynos4 exynos5,$(TARGET_BOARD_PLATFORM)),)
LOCAL_CFLAGS += -DSAMSUNG_ANDROID_PATCH
endif

LOCAL_MODULE:= libstagefright

include $(BUILD_SHARED_LIBRARY)

include $(call all-makefiles-under,$(LOCAL_PATH))
