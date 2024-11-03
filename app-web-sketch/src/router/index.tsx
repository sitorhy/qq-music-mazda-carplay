import { createBrowserRouter } from 'react-router-dom';
import App from '../App.tsx';
import Entry from '../components/Entry.tsx';
import MusicHall from "../components/MusicHall.tsx";
import Collection from "../components/Collection.tsx";
import SongList from "../components/SongList.tsx";
import PlayingScreen from "../components/PlayingScreen.tsx";

const router = createBrowserRouter([
    {
        path: "/",
        element: <App/>,
        children: [
            {
                index: true,
                element: <Entry/>
            },
            {
                path: 'musicHall',
                element: <MusicHall/>
            },
            {
                path: 'collection',
                element: <Collection/>
            },
        ]
    },
    {
        path: '/songList',
        element: <SongList/>
    },
    {
        path: '/playing',
        element: <PlayingScreen/>
    }
]);

export default router;