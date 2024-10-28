import {connect} from 'react-redux';
import MetaScaffold from "./MetaScaffold.tsx";
import {loadEntryMetaList} from "../store/reducerCreator.ts";
import {useEffect, useRef} from "react";

function Entry(props: {
    metaList?: MetaList;
    loadEntryMetaList?: () => void;
}) {
    const init = useRef(false);
    useEffect(() => {
        if (!init.current) {
            if (props.loadEntryMetaList) {
                props.loadEntryMetaList();
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
        entry: MetaList;
    }, ownProps) {
        return {
            ...ownProps,
            ...state.entry
        };
    },
    function (dispatch) {
        return {
            // eslint-disable-next-line @typescript-eslint/ban-ts-comment
            // @ts-expect-error
            loadEntryMetaList: () => dispatch(loadEntryMetaList()),
        }
    }
)(Entry);