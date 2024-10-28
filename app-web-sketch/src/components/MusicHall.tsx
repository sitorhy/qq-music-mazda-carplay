import {connect} from 'react-redux';
import MetaScaffold from "./MetaScaffold.tsx";
import {loadMusicHallMetaList} from "../store/reducerCreator.ts";
import {useEffect, useRef} from "react";

function MusicHall(props: {
    metaList?: MetaList;
    loadMusicHallMetaList?: () => void;
}) {
    const init = useRef(false);
    useEffect(() => {
        if (!init.current) {
            if (props.loadMusicHallMetaList) {
                props.loadMusicHallMetaList();
            }
        }
        init.current = true;
    }, []);

    return (
        <MetaScaffold
            metaList={props.metaList || []}
        />
    );
}

export default connect(
    function (state: {
        musicHall: MetaList;
    }, ownProps) {
        return {
            ...ownProps,
            ...state.musicHall
        };
    },
    function (dispatch) {
        return {
            // eslint-disable-next-line @typescript-eslint/ban-ts-comment
            // @ts-expect-error
            loadMusicHallMetaList: () => dispatch(loadMusicHallMetaList()),
        }
    }
)(MusicHall);