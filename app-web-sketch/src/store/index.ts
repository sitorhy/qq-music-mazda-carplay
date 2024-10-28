import {combineReducers, configureStore} from "@reduxjs/toolkit";
import entryReducer from "./entryReducer.ts";
import collectionReducer from "./collectionReducer.ts";
import musicHallReducer from "./musicHallReducer.ts";
import tagPopupReducer from "./tagPopupReducer.ts";
import QQMusicAPI from "../api";

const store = configureStore(
    {
        reducer: combineReducers({
            collection: collectionReducer,
            musicHall: musicHallReducer,
            entry: entryReducer,
            tagPopup: tagPopupReducer
        }),
        middleware: getDefaultMiddleware => {
            return getDefaultMiddleware({
                thunk: {
                    extraArgument: {
                        api: new QQMusicAPI(),
                    }
                }
            });
        }
    }
);

export default store;

