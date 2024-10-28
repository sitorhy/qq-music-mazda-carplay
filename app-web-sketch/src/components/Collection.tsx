import {connect} from 'react-redux';
import MetaScaffold from "./MetaScaffold.tsx";
import {loadCollectionMetaList} from "../store/reducerCreator.ts";
import {useEffect, useRef} from "react";

function Collection(props: {
    metaList?: MetaList;
    loadCollectionMetaList?: () => void;
}) {
    const init = useRef(false);
    useEffect(() => {
        if (!init.current) {
            if (props.loadCollectionMetaList) {
                props.loadCollectionMetaList();
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
        collection: MetaList;
    }, ownProps) {
        return {
            ...ownProps,
            ...state.collection
        };
    },
    function (dispatch) {
        return {
            loadCollectionMetaList: () => dispatch(loadCollectionMetaList()),
        }
    }
)(Collection);