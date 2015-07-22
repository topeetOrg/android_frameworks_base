/*
 *
 * Copyright 2010 Samsung Electronics S.LSI Co. LTD
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * @file        AudioPlayerBase.h
 * @brief
 * @author      Yunji Kim (yunji.kim@samsung.com)
 * @version     1.0
 * @history
 *   2010.12.17 : Create
 */

#ifndef AUDIO_PLAYER_BASE_H_

#define AUDIO_PLAYER_BASE_H_

namespace android {

class MediaSource;

class AudioPlayerBase : public TimeSource {
public:
             AudioPlayerBase() {}
    virtual ~AudioPlayerBase() {}

    /* Caller retains ownership of "source". */
    virtual void setSource(const sp<MediaSource> &source);

    /* Return time in us. */
    virtual int64_t getRealTimeUs();

    virtual status_t start(bool sourceAlreadyStarted = false);

    virtual void pause(bool playPendingSamples = false);
    virtual void resume();

    /* Returns the timestamp of the last buffer played (in us). */
    virtual int64_t getMediaTimeUs();

    /*
     * Returns true iff a mapping is established, i.e. the AudioPlayer
     * has played at least one frame of audio.
     */
    virtual bool getMediaTimeMapping(int64_t *realtime_us, int64_t *mediatime_us);

    virtual status_t seekTo(int64_t time_us);

    virtual bool isSeeking();
    virtual bool reachedEOS(status_t *finalStatus);

    virtual status_t initCheck() const { return OK; };
};

}  /* namespace android */

#endif  /* AUDIO_PLAYER_BASE_H_ */
