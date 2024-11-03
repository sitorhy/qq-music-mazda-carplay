/****
 sitorhy player.js unstable beta
 */
let g__ios_webkit_audio_context;

export default function (__options) {
    const {
        source,
        cors = false,
        wxBackground = false,
        wxTitle = null,
        wxCoverImgUrl = "",
        obeyMute = true,
        audioContext
    } = {
        ...(
            {
                audioContext: null,
                source: null, // 音频 URL
                cors: false, // 允许跨域，使用 H5 Audio Context
                wxBackground: false, // 微信，使用北京音频 ， 音频必须是https
                wxTitle: null, // 微信，背景音频开启必填
                wxCoverImgUrl: "" // 微信，背景音频封面
            }
        ),
        ...__options
    };

    let context = null;
    let xhr = null;

    // H5
    let __h5_loadeddata = false; // 加载过数据没有
    let __on_loaded = []; // 音频加载完成
    let acPlaying = false;// 无法得知音频是否在播放, 设立该标记，避免 cannot call stop without calling start first.
    let acBuffer = null;
    let acSource = null;
    let acPositionAccOffset = 0; // 已累计的时间，IOS切换音源并不会重置currentTime为0,需要在create的时候获取之前的累计数值。
    let acPosition = 0; // 当前累计播放时间
    let acPositionAcc = 0; // 上次暂停的累计时间，acPosition - acPositionAcc 为 本次已播放时间，暂停或跳转重置为0
    let startTime = 0; // 本次开次播放的时间, 跳转时 startTime = seekedTime,暂停时当前值加上本次已播放时间
    let frameToken = null;

    // Audio Element专用
    let __duration = 0;
    let __h5__pause, __h5__loadeddata, __h5__created,
        __h5__waiting, __h5__canplay, __h5__timeupdate, __h5__ended, __h5__playing;

    // 常量
    const isWX = typeof wx === "undefined" ? false : (wx && wx.createInnerAudioContext);

    // 公用回调
    let __created = null; // DOM对象绑定完毕，主要针对IOS
    let __update = null; // 播放中
    let __wait = null; // 数据不足，卡住
    let __ready = null; // +1s
    let __end = null;
    let __playing = null;
    let __paused = null;
    let __stop = null;
    let __error = null;


    // 垃圾微信专用
    let __wx_loadeddata = false;
    let __wx_canplay_action = null; // play 先于 canplay 执行, ontimeupdate 将不会执行

    let __wx_onAudioInterruptionBegin = null;
    let __wx_onAudioInterruptionEnd = null;
    let __wx_bgMusicTime = 0; // 记录微信背景音乐播放进度

    let __wx__play, __wx__pause, __wx__error,
        __wx__seeked, __wx__waiting, __wx__canplay, __wx__timeupdate, __wx__ended, __wx_stop;

    function updatePosition() {
        if (context) {
            acPosition = context.currentTime;
            const time = startTime + (acPosition - acPositionAcc);
            if (__update) {
                __update(time - acPositionAccOffset, acBuffer.duration);
            }
            if (time < acBuffer.duration) {
                updatePositionContinuously();
            } else {
                stopPositionUpdate();
                if (acSource && acPlaying)
                    acSource.stop(0);
                acSource = null;
                acPosition = 0;
                acPositionAcc = 0;
                startTime = 0;
                if (__end) {
                    __end();
                }
            }
        }
    }

    function updatePositionContinuously() {
        frameToken = requestAnimationFrame(updatePosition);
    }

    function stopPositionUpdate() {
        if (frameToken) {
            acPosition = context.currentTime;
            cancelAnimationFrame(frameToken);
            frameToken = null;
        }
    }

    function offWxInnerContextCallback() {
        if (context.offPlay && __wx__play)
            context.offPlay(__wx__play);
        if (context.offStop && __wx_stop) {
            context.offStop(__wx_stop);
        }
        if (context.offPause && __wx__pause)
            context.offPause(__wx__pause);
        if (context.offError && __wx__error)
            context.offError(__wx__error);
        if (context.offSeeked && __wx__seeked)
            context.offSeeked(__wx__seeked);
        if (context.offWaiting && __wx__waiting)
            context.offWaiting(__wx__waiting);
        if (context.offCanplay && __wx__canplay)
            context.offCanplay(__wx__canplay);
        if (context.offTimeUpdate && __wx__timeupdate)
            context.offTimeUpdate(__wx__timeupdate);
        if (context.offEnded && __wx__ended)
            context.offEnded(__wx__ended);

        if (__wx_onAudioInterruptionEnd)
            wx.offAudioInterruptionEnd(__wx_onAudioInterruptionEnd);
        if (__wx_onAudioInterruptionBegin)
            wx.offAudioInterruptionBegin(__wx_onAudioInterruptionBegin);
    }

    return {
        destroyContext() {
            if (context) {
                if (!isWX) {
                    if (cors) {
                        context.close();
                    }
                }
            }
        },

        create() {
            if (isWX) {
                try {
                    context = wxBackground && wxTitle ? (audioContext && audioContext.epname !== undefined ? audioContext : wx.getBackgroundAudioManager())
                        : (audioContext && audioContext.src !== undefined ? audioContext : wx.createInnerAudioContext());

                    if (wxBackground && audioContext.offPlay) {
                        this.onError(new Error('make sure pass a background context'));
                    }

                    offWxInnerContextCallback();

                    if (!wxBackground) {
                        context.autoplay = false; // 微信背景音频不支持该参数

                        // 处理静音模式
                        if (!obeyMute) {
                            wx.setInnerAudioOption({
                                fail: function (e) {

                                },
                                mixWithOther: true,  // 混合其他音频
                                obeyMuteSwitch: false, // 静音下可播放
                                speakerOn: true // 使用扬声器，废话，有人会用话筒么
                            })

                        }

                    } else {

                    }
                    if (wxBackground) {
                        if (!wxTitle) {
                            this.onError(new Error("wxTitle audio is required"));
                        }
                    }

                    __wx__play = () => {
                        console.log('__wx__play')
                        if (__playing) {
                            __playing();
                        }
                    };
                    __wx__pause = () => {
                        console.log('__wx__pause')
                        if (__wx_canplay_action) {
                            __wx_canplay_action();
                        }
                        if (__paused) {
                            __paused();
                        }
                    };
                    __wx__error = (e) => {
                        this.onError.apply(this, [e]);
                    };
                    __wx__seeked = () => {
                        console.log('__wx__seeked')
                        if (__wx_canplay_action) {
                            __wx_canplay_action();
                        }
                        if (context.paused) {
                            context.pause();
                        } else {
                            context.play();
                        }
                    };
                    __wx__waiting = () => {
                        console.log('__wx__waiting')
                        this.onWaiting.apply(this, arguments);
                    };
                    __wx__canplay = () => {
                        console.log('__wx__canplay')
                        this.onCanplay.apply(this, arguments);
                    };
                    __wx__timeupdate = () => {
                        this.onTimeUpdate.apply(this, arguments);
                    };
                    __wx__ended = () => {
                        this.onEnded.apply(this, arguments);
                    };
                    __wx_stop = () => {
                        __wx_bgMusicTime = 0;
                        this.onStop.apply(this, arguments);
                    };
                    context.onPlay(__wx__play);
                    context.onPause(__wx__pause);
                    context.onError(__wx__error);
                    context.onSeeked(__wx__seeked);
                    context.onWaiting(__wx__waiting);
                    context.onCanplay(__wx__canplay);
                    context.onTimeUpdate(__wx__timeupdate);
                    context.onEnded(__wx__ended);
                    context.onStop(__wx_stop);

                    __wx_onAudioInterruptionEnd = () => {

                    };

                    __wx_onAudioInterruptionBegin = () => {

                    };

                    wx.offAudioInterruptionEnd(__wx_onAudioInterruptionEnd);
                    wx.offAudioInterruptionBegin(__wx_onAudioInterruptionBegin);

                    if (wxCoverImgUrl) {
                        context.coverImgUrl = wxCoverImgUrl;
                    }
                    if (wxTitle)
                        context.title = wxTitle;
                    if (wxBackground) {
                        // 微信背景音频 设置source 后立即播放，这里不需要
                        // context.source = source;
                        __wx__canplay(); // 通知界面为可点击播放
                    } else {
                        context.src = source;
                    }
                } catch (e) {
                    this.onError(e);
                }
            } else {
                if (!cors) {
                    const isIOSOrMac = navigator.platform.indexOf('iPhone') >= 0;

                    __h5__pause = () => {
                        if (__paused) {
                            __paused();
                        }
                    };
                    __h5__waiting = () => {
                        if (__wait) {
                            __wait();
                        }
                    };
                    __h5__canplay = () => {
                        if (__ready) {
                            __ready();
                        }
                    };
                    __h5__timeupdate = () => {
                        if (__update) {
                            __update(context.currentTime, __duration);
                        }
                    };
                    __h5__ended = () => {
                        if (__end) {
                            __end();
                        }
                    };
                    __h5__playing = () => {
                        if (__playing) {
                            __playing();
                        }
                    };
                    __h5__loadeddata = () => {
                        __h5_loadeddata = true;
                        __duration = context.duration;
                    };

                    __h5__created = () => {
                        if (isIOSOrMac) {
                            if (!__h5_loadeddata) {
                                __h5__canplay();
                            }
                        }
                        if (__created) {
                            __created();
                        }
                    };


                    try {
                        context = audioContext ? audioContext : new Audio();
                        context.addEventListener('loadeddata', __h5__loadeddata);
                        context.addEventListener('timeupdate', __h5__timeupdate);
                        context.addEventListener('canplay', __h5__canplay);
                        context.addEventListener('ended', __h5__ended);
                        context.addEventListener('pause', __h5__pause);
                        context.addEventListener('waiting', __h5__waiting);
                        context.addEventListener('playing', __h5__playing);
                        context.setAttribute('src', source);

                        __h5__created();
                    } catch (e) {
                        this.onError(e);
                    }

                } else {
                    try {
                        const AudioContext = window.AudioContext || window.webkitAudioContext;
                        if (navigator.platform === 'iPhone' || navigator.platform === 'iPad') {
                            if (!g__ios_webkit_audio_context) {
                                // IOS 不支持自动播放，每创建一个新的Context都需要手动触发，因此需要公用
                                g__ios_webkit_audio_context = audioContext || new AudioContext();
                            }
                            context = g__ios_webkit_audio_context;
                        } else {
                            context = audioContext || new AudioContext();
                        }
                        acPositionAccOffset = context.currentTime; // 上一次音源累计的时间，需要减去，本次不累计
                        context.suspend().then(() => {
                            (function (url) {
                                const request = new XMLHttpRequest();
                                xhr = request;
                                request.open('GET', url, true);
                                request.responseType = 'arraybuffer';

                                request.onload = () => {
                                    xhr = null;
                                    if (context) {
                                        context.decodeAudioData(request.response, (buffer) => {
                                            acBuffer = buffer;
                                            acPosition = 0;
                                            // 架构设计应改为异步总线机制
                                            this.h5Ready(true);
                                            __on_loaded.splice(0).forEach(i => i());
                                        }, (e) => {
                                            this.onError(e);
                                        });
                                    } else {
                                        // 加载完成前已被销毁
                                    }
                                }
                                request.send();
                            }.bind(this))(source);
                        }).catch(e => {
                            this.onError(e);
                        });
                    } catch (e) {
                        this.onError(e);
                    }
                }
            }
            return this;
        },
        destroy() {
            if (xhr) {
                __on_loaded.splice(0);
                xhr.abort();
                xhr = null;
            }
            if (context) {
                if (isWX) {
                    if (context.destroy) {
                        if (!audioContext) {
                            context.stop();
                            context.destroy();
                        } else {
                            context.stop();
                        }
                    } else {
                        context.stop();
                    }

                    offWxInnerContextCallback();
                } else {
                    if (cors) {
                        stopPositionUpdate();
                        if (context.state === 'running') {
                            if (acSource && acPlaying) {
                                acSource.stop(0);
                            }
                        }
                    } else {
                        context.pause();

                        context.removeEventListener('loadeddata', __h5__loadeddata);
                        context.removeEventListener('timeupdate', __h5__timeupdate);
                        context.removeEventListener('canplay', __h5__canplay);
                        context.removeEventListener('ended', __h5__ended);
                        context.removeEventListener('pause', __h5__pause);
                        context.removeEventListener('waiting', __h5__waiting);
                        context.removeEventListener('playing', __h5__playing);

                        context = null;
                    }
                }
            }
        },
        stop() {
            if (context) {
                if (isWX) {
                    context.stop();
                } else {
                    if (cors) {
                        stopPositionUpdate();
                        context.suspend().then(() => {
                            if (acSource && acPlaying) {
                                if (context.state === 'running')
                                    acSource.stop(0);
                            }
                            if (context) {
                                acPosition = 0;
                                acPositionAcc = 0;
                            }
                            acSource = null;
                            acPlaying = false;
                        });
                    } else {
                        context.pause();
                        context.currentTime = 0;
                    }
                }
            }
            return this;
        },
        play() {
            if (context) {
                if (isWX) {
                    const bgMusicReady = () => {
                        // 微信背景音乐 停止后需要重新赋值才能播放
                        try {
                            if (!context) {
                                this.create();
                            } else {
                                context.src = source;
                                context.play();
                            }
                        } catch (e) {
                            this.onError(e);
                        }
                    }

                    if (wxBackground)
                        bgMusicReady();
                    else {
                        if (!__wx_loadeddata) {
                            __wx_canplay_action = () => {
                                context.play();
                            }
                        } else {
                            context.play();
                        }
                    }
                } else {
                    if (cors) {
                        const __au_play = () => {
                            if (!acSource) {
                                this.h5RecreateSource();
                            }
                            if (context.state === 'suspended') {
                                // 恢复后立即调用start不会立即播放
                                context.resume().then(() => {
                                    if (context.state === 'suspended') {
                                        // IOS必须手动触发第一次播放，状态还是 suspended
                                        if (__paused) {
                                            __paused(); // 通知界面切换到暂停状态
                                        }
                                    } else {
                                        acSource.start(0, startTime + (acPosition - acPositionAcc)); // 起始位置，偏移量
                                        acPlaying = true;
                                        if (__playing) {
                                            __playing();
                                        }
                                        updatePositionContinuously();
                                    }
                                })
                            } else {
                                acSource.start(0, startTime + (acPosition - acPositionAcc)); // 起始位置，偏移量
                                acPlaying = true;
                                if (__playing) {
                                    __playing();
                                }
                                updatePositionContinuously();
                            }
                        };
                        if (!acBuffer) {
                            __on_loaded.push(__au_play)
                        } else {
                            __au_play();
                        }
                    } else {
                        if (!__h5_loadeddata) {
                            // IOS
                            let t;
                            const once_loadeddata = () => {
                                if (t) {
                                    clearTimeout(t);
                                    t = null;
                                }
                                context.removeEventListener('loadeddata', once_loadeddata);
                                context.play();
                                if (context.paused) {
                                    // 状态还是paused 说明系统实现限制
                                    __h5__pause();
                                } else {
                                    __h5__playing();
                                }
                            };
                            context.addEventListener('loadeddata', once_loadeddata);
                            __h5__waiting();
                            t = setTimeout(() => {
                                context.play();
                            }, 300);
                        } else {
                            context.play();
                        }
                    }
                }
            } else {
                if (!isWX) {
                    // 播放结束 触发 __end(); context 销毁
                    const AudioContext = window.AudioContext || window.webkitAudioContext;
                    context = new AudioContext();
                    return this.play();
                }
            }
            return this;
        },
        pause() {
            if (context) {
                if (isWX) {
                    context.pause();
                } else {
                    if (cors) {
                        stopPositionUpdate();
                        if (acSource) {
                            if (context.state === 'running') {
                                context.suspend().then(() => {
                                    acPlaying = false;
                                    startTime = startTime + (acPosition - acPositionAcc);
                                    acPositionAcc = acPosition;
                                    if (acSource && acPlaying) {
                                        acSource.stop(0);
                                        acSource = null;
                                        if (__paused) {
                                            __paused();
                                        }
                                    }
                                });
                            }
                        }
                    } else {
                        context.pause();
                    }
                }
            }
            return this;
        },
        seek(secs = 0.0) {
            if (context) {
                if (isWX) {
                    __wx_canplay_action = () => {
                        context.play();
                    }
                    context.seek(secs);
                    context.play();
                } else {
                    if (cors) {
                        if (context.state === 'running') {
                            stopPositionUpdate();
                            if (acSource && acPlaying) {
                                acSource.stop(0);
                                acSource = null;
                                acPositionAcc = acPosition; // 刷新上次的累计时间
                                startTime = secs; // 重新指定起始时间，该值务求准确，否则结果不可预测

                                this.play();
                                updatePositionContinuously();
                            }
                        } else {
                            acPosition = secs;
                        }
                    } else {
                        context.currentTime = secs;
                    }
                }
            }
            return this;
        },
        error(callback) {
            __error = callback;
            return this;
        },

        /*
         *
         * 回调
         */

        created(callback) {
            // 专用事件，IOS 不允许自动播放，需要手动出发才会去加载数据，否则 不会出发 loadeddata
            __created = callback;
            return this;
        },

        update(callback) {
            __update = callback;
            return this;
        },

        wait(callback) {
            __wait = callback;
            return this;
        },

        ready(callback) {
            __ready = callback;
            return this;
        },

        end(callback) {
            __end = callback;
            return this;
        },

        cancel(callback) {
            __stop = callback;
            return this;
        },

        playing(callback) {
            __playing = callback;
            return this;
        },

        paused(callback) {
            __paused = callback;
            return this;
        },

        // H5 监听器

        onH5CanPlay() {
            if (__ready) {
                __ready();
            }
        },
        h5RecreateSource() {
            if (context && context.state === 'running') {  // 因为需要重新创建音频源，需要停止当前的
                if (acSource && acPlaying) {  // 暂停 停止 已销毁 不用处理
                    acSource.stop(0);
                }
            }

            if (context) {
                acSource = context.createBufferSource(); // 创建数据源
                acSource.buffer = acBuffer; // 绑定数据源到缓冲区
                acSource.connect(context.destination); // 绑定数据源到扬声器
            }
        },
        h5Ready(isFirst = false) {
            const task = () => {
                this.h5RecreateSource();
                this.onH5CanPlay();
            };
            if (!acBuffer) {
                if (!isFirst)
                    __on_loaded.push(task);
            } else {
                task();
            }
        },


        /*
         *
         * 微信专用监听器
         *
         */
        onEnded() {
            if (__end) {
                __end();
            }
        },

        onStop() {
            if (__stop) {
                __stop();
            }
        },

        onError(e) {
            if (__error) {
                __error(e);
            }
        },
        onTimeUpdate() {
            __wx_bgMusicTime = context.currentTime;
            if (__update) {
                __update(__wx_bgMusicTime, context.duration);
            }
        },
        onWaiting() {
            if (__wait) {
                __wait();
            }
        },
        onCanplay() {
            console.log('onCanplay')
            if (__ready) {
                __ready();
            }
            __wx_loadeddata = true;
            if (__wx_canplay_action) {
                __wx_canplay_action();
                __wx_canplay_action = null;
            }
        }
    }
}
