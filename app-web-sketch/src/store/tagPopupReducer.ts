export default function tagPopupReducer(state:{
    visible: boolean;
    groups: CategoryPopupGroup[];
} = {
    visible: false,
    groups: []
}, action: Record<string, unknown>) {
    switch(action.type) {
        case 'SET_TAG_POPUP_VISIBILITY':
        {
            return {
                ...state,
                visible: action.visible
            }
        }
        case 'SET_TAG_POPUP_GROUPS':
        {
            return {
                ...state,
                groups: action.groups
            };
        }
    }
    return state;
}