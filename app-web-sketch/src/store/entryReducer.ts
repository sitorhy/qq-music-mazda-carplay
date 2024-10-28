export default function entryReducer(state: {
    metaList: MetaList
} = {
    metaList: []
}, action: {
    type: string;
    code: string;
    loading?: boolean;
    albums?: Partial<Album>[];
    songs?: Partial<Song>[];
    metaList?: MetaList;
}) {
    switch (action.type) {
        case 'SET_ENTRY_META_LIST': {
            return {
                ...state,
                metaList: action.metaList
            };
        }
        case 'SET_ENTRY_CATEGORY_LOADING':{
            const metaIndex = state.metaList.findIndex(
                (i) => i.categories.findIndex(
                    (j) => j.categoryCode === action.code) >= 0);
            const meta = state.metaList[metaIndex];
            if (metaIndex >= 0) {
                const category = meta.categories.find((i) => i.categoryCode === action.code);
                if (category) {
                    category.loading = action.loading;
                    return {
                        ...state,
                    };
                }
            }
            return state;
        }
        case 'SET_ENTRY_CATEGORY': {
            const metaIndex = state.metaList.findIndex(
                (i) => i.categoryTypes.includes(action.categoryType)
            );
            const meta = state.metaList[metaIndex];
            if (metaIndex >= 0) {
                const categoryIndex = meta.categories.findIndex((i) => i.categoryCode === action.categoryCode);
                if (categoryIndex >= 0) {
                    return {
                        ...state,
                        metaList: [
                            ...state.metaList.map(i => {
                                return {
                                    ...i,
                                    categories: i.categories.map(j => {
                                        return {
                                            ...j,
                                            albums: j.categoryCode === action.categoryCode && Array.isArray(action.albums) ? [...action.albums] : j.albums,
                                            songs: j.categoryCode === action.categoryCode && Array.isArray(action.songs) ? [...action.songs] : j.songs,
                                        };
                                    })
                                };
                            }),
                        ]
                    };
                }
            }
            return state;
        }
        default:
            return state;
    }
}