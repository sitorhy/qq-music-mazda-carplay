import {Tabs, ErrorBlock, Space, Tag, List, Image, Ellipsis, Button} from 'antd-mobile';
import {useCallback, useEffect, useRef, useState} from 'react';
import {connect} from "react-redux";
import {
    loadNextCategoryDetail,
    loadPopupCategoryDetail,
    loadPlayingSong,
    setTagPopupVisible,
    loadSongLyricText
} from "../store/reducerCreator.ts";

import "../style/MetaScaffold.css";
import {createSearchParams, NavigateFunction, useNavigate} from "react-router-dom";

function renderTabs(
    metaList: MetaList,
    categoryIndex: number,
    onCategoryChange: (tabKey: string, category: Category, categoryIndex: number) => void,
    onMore: (category: Category) => void,
) {
    try {
        return metaList.map((item: Meta, index: number) => {
            return (
                <Tabs.Tab title={item.title} key={index}>
                    {
                        item.categories && item.categories.length > 1 ? (
                            <div className={'tags'}>
                                <Space>
                                    {
                                        item.categories.slice(0, 6).map((j: Category, k: number) => {
                                            return (
                                                <Tag color='primary'
                                                     fill={k === categoryIndex ? undefined : 'outline'}
                                                     key={j.categoryCode}
                                                     onClick={() => {
                                                         onCategoryChange(String(index), j, k);
                                                     }}
                                                >
                                                    {j.categoryName}
                                                </Tag>
                                            );
                                        })
                                    }
                                </Space>
                                <div>
                                    {
                                        item.categories.length > 6 ? (
                                            <div>
                                                <Button size='mini' color='primary' onClick={() => onMore(item.categories[0])}>
                                                    更多
                                                </Button>
                                            </div>
                                        ): null
                                    }
                                </div>
                            </div>
                        ) : null
                    }
                </Tabs.Tab>
            );
        });
    } catch (e) {
        return (
            <ErrorBlock status='default' title={String(e)}/>
        );
    }
}

function renderAlbums(
    metaList: MetaList,
    metaInddex: number,
    categoryIndex: number,
    navigate: NavigateFunction,
    onSongClick: (song: Song) => void,
) {
    try {
        const COLUMNS = 5;
        const meta = metaList[metaInddex];
        if (!meta || !meta.categories || !meta.categories[categoryIndex]) {
            return <ErrorBlock status='default' title={'Loading...'}/>;
        }
        const category = meta.categories[categoryIndex];
        const albums = Array.isArray(category.albums) ? category.albums : [];
        const songs = Array.isArray(category.songs) ? category.songs : [];
        const albumsSplit = [];
        let index = 0;
        while (index < albums.length) {
            // null 占位 使布局对其
            const section = albums.slice(index, index + COLUMNS);
            while (section.length < 5) {
                // eslint-disable-next-line @typescript-eslint/ban-ts-comment
                // @ts-expect-error
                section.push(null);
            }
            albumsSplit.push(
                section
            );
            index += COLUMNS;
        }

        index = 0;
        const songSplit = [];
        while (index < songs.length) {
            const section = songs.slice(index, index + COLUMNS);
            while (section.length < 5) {
                // eslint-disable-next-line @typescript-eslint/ban-ts-comment
                // @ts-expect-error
                section.push(null);
            }
            songSplit.push(
                section
            );
            index += COLUMNS;
        }

        if (albumsSplit.length) {
            return (
                albumsSplit.map((row, index) => {
                    return (
                        <List.Item key={index}>
                            <Space justify='around' align='center'>
                                {
                                    row.map(i => {
                                        return i ? (
                                            <div className={'cover'} key={Math.random()} style={{
                                                width: '15vw',
                                            }} onClick={() => {
                                                navigate({
                                                    pathname: "/songList",
                                                    search: `?${createSearchParams({
                                                        dissId: i.dissId || i.albumMid || ''
                                                    })}`
                                                });
                                            }}>
                                                <div className={'author'}>
                                                    <Ellipsis content={String(i.author)}/>
                                                </div>
                                                <Image src={i.picUrl} width={'15vw'} height={'15vw'}/>
                                                <Ellipsis direction='end' content={String(i.title)}></Ellipsis>
                                            </div>
                                        ) : (
                                            <div style={{
                                                width: '15vw',
                                                height: '15vw'
                                            }} key={Math.random()}></div>
                                        );
                                    })
                                }
                            </Space>
                        </List.Item>
                    );
                })
            );
        } else {
            return (
                songSplit.map((row, index) => {
                    return (
                        <List.Item key={index}>
                            <Space justify='around' align='center'>
                                {
                                    row.map(i => {
                                        return i ? (
                                            <div className={'cover'} key={Math.random()} style={{
                                                width: '15vw',
                                            }} onClick={() => onSongClick(i)}>
                                                {
                                                    Array.isArray(i.singers) ? <div className={'author'}>
                                                        <Ellipsis
                                                            content={String(i.singers.map(i => i.name).join('/ '))}/>
                                                    </div> : null
                                                }
                                                <Image src={i.albumCoverUrl} width={'15vw'} height={'15vw'}/>
                                                <Ellipsis direction='end' content={String(i.songName)}></Ellipsis>
                                            </div>
                                        ) : (
                                            <div style={{
                                                width: '15vw',
                                                height: '15vw'
                                            }} key={Math.random()}></div>
                                        );
                                    })
                                }
                            </Space>
                        </List.Item>
                    );
                })
            );
        }
    } catch (e) {
        console.error(e);
        return <ErrorBlock status='default' title={String(e)}/>;
    }
}

function MetaScaffold(props: {
    metaList: MetaList;
    loadNextCategoryDetail?: (category: Category) => void;
    popupTag?: (category: Category) => void;
    loadPlayingSong?: (song: Song) => Promise<void>;
    loadSongLyricText?: (song: Song) => Promise<void>;
} = {
    metaList: [],
    loadNextCategoryDetail: () => {
    }
}) {
    const navigate = useNavigate();

    const [state, setState] = useState<{
        activeKey: string;
        activeCategoriesMap: Record<string, number>
    }>({
        activeKey: '0',
        activeCategoriesMap: {},
    });

    const init = useRef(false);
    useEffect(() => {
        if (Array.isArray(props.metaList) && props.metaList.length > 0) {
            if (!init.current) {
                const meta = props.metaList[parseInt(state.activeKey)];
                setState({
                    ...state,
                    activeCategoriesMap: props.metaList.reduce((s, _i, index) => {
                        Object.assign(s, {
                            [index]: 0
                        });
                        return s;
                    }, {})
                });
                const category = meta.categories[state.activeCategoriesMap[String(state.activeKey)] || 0];
                // eslint-disable-next-line @typescript-eslint/ban-ts-comment
                // @ts-expect-error
                props.loadNextCategoryDetail(category);
            }
            init.current = true;
        }
    }, [props.metaList]);

    const onMore = useCallback((category: Category) => {
        if (props.popupTag) {
            props.popupTag(category);
        }
    }, [props.popupTag]);

    function onCategoryChange(tabKey: string, category: Category, index: number) {
        setState({
            ...state,
            activeCategoriesMap: {
                ...state.activeCategoriesMap,
                [tabKey]: index,
            }
        });

        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-expect-error
        props.loadNextCategoryDetail(category);
    }

    const renderAlbumsMeme = useCallback(() => {
        return renderAlbums(
            props.metaList,
            parseInt(state.activeKey),
            state.activeCategoriesMap[state.activeKey],
            navigate,
            async function (song) {
                if (props.loadPlayingSong) {
                    await props.loadPlayingSong(song);
                    navigate({
                        pathname: `/playing`,
                    });
                    if (props.loadSongLyricText) {
                        props.loadSongLyricText(song);
                    }
                }
            }
        );
    }, [
        props.metaList,
        state.activeKey,
        state.activeCategoriesMap,
        navigate
    ]);

    const renderTabsMemo = useCallback(() => {
        return renderTabs(
            props.metaList,
            state.activeCategoriesMap[state.activeKey],
            onCategoryChange,
            onMore
        )
    }, [
        props.metaList,
        state.activeCategoriesMap,
        onCategoryChange,
        onMore
    ]);

    return (
        <div className={'MetaScaffold'}>
            <div className={'tabs'}>
                <Tabs
                    defaultActiveKey='0'
                    activeKey={String(state.activeKey)}
                    onChange={key => {
                        setState({
                            ...state,
                            activeKey: key,
                        });
                        const meta = props.metaList[parseInt(key)];
                        const category = meta.categories[state.activeCategoriesMap[key]];

                        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
                        // @ts-expect-error
                        props.loadNextCategoryDetail(category);
                    }}
                >
                    {
                        renderTabsMemo()
                    }
                </Tabs>
            </div>
            <div className={'content'}>
                {
                    renderAlbumsMeme()
                }
            </div>
        </div>
    );
}

export default connect(
    function () {
        return {}
    },
    function (dispatch) {
        return {
            // eslint-disable-next-line @typescript-eslint/ban-ts-comment
            // @ts-expect-error
            loadNextCategoryDetail: (category: Category) => dispatch(loadNextCategoryDetail(category)),
            popupTag: async (category: Category) => {
                await dispatch(
                    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
                    // @ts-expect-error
                    loadPopupCategoryDetail(category)
                );

                dispatch(setTagPopupVisible(true))
            },
            loadPlayingSong: (song: Song) => dispatch(loadPlayingSong(song)),
            loadSongLyricText: (song: Song) => dispatch(loadSongLyricText(song))
        }
    }
)(MetaScaffold);