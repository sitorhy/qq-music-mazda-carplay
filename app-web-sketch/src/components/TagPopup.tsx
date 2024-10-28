import {Popup, List, Space, Tag} from "antd-mobile";
import {connect} from "react-redux";
import {useMemo} from "react";

function TagPopup(props: {
    tagPopup?: {
        visible?: boolean;
        groups: CategoryPopupGroup[],
    };
    popupTag?: (visible: boolean) => void;
}) {
    const {tagPopup = {
        visible: true,
        groups: []
    }, popupTag} = props;
    const {
        groups
    } = tagPopup;

    const groupsSplit = useMemo(() => {
        const COLUMNS = 4;
        return groups.map(i => {
            const rowGroup : {
                groupName: string;
                groupId: string;
                rows: Array<Category[]>,
            } = {
                groupName: i.groupName,
                groupId: i.groupId,
                rows: []
            };

            let index = 0;
            while (index < i.categories.length) {
                // null 占位 使布局对其
                const section = i.categories.slice(index, index + COLUMNS);
                rowGroup.rows.push(
                    section
                );
                index += COLUMNS;
            }

            return rowGroup;
        });
    }, [groups]);


    return (
        <Popup
            visible={tagPopup?.visible}
            onMaskClick={() => {
                if (popupTag) {
                    popupTag(false);
                }
            }}
            position='right'
            bodyStyle={{width: '40vw'}}
        >
            <div style={{overflow: 'auto', height: '100%'}}>
                {
                    groupsSplit.map((group) => {
                        return (
                            <List header={group.groupName} key={group.groupId}>
                                <List.Item>
                                    {
                                        group.rows.map((i, index) => {
                                            return (
                                                <Space key={index}>
                                                    {
                                                        i.map(j => {
                                                            return (
                                                                <Tag key={j.categoryCode}>{j.categoryName}</Tag>
                                                            );
                                                        })
                                                    }
                                                </Space>
                                            );
                                        })
                                    }
                                </List.Item>
                            </List>
                        );
                    })
                }
            </div>
        </Popup>
    );
}

export default connect(
    function (state: {
        tagPopup: {
            visible?: boolean;
            groups: CategoryPopupGroup[],
        };
    }, ownProps) {
        return {
            tagPopup: state.tagPopup,
            ...ownProps
        }
    },
    function (dispatch) {
        return {
            popupTag: (visible: boolean) => dispatch({
                type: 'SET_TAG_POPUP_VISIBILITY',
                visible
            })
        }
    }
)(TagPopup);