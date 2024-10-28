import NavButton from './NavButton.tsx';
import {useNavigate} from 'react-router-dom';

export default function NavBar() {
    const navigate = useNavigate();

    return (
        <div>
            <NavButton icon={'home'} title={'首页'} onClick={() => {
                navigate("/");
            }}/>
            <NavButton icon={'directions'} title={'乐馆'} onClick={() => {
                navigate("musicHall");
            }}/>
            <NavButton icon={'queue_music'} title={'收藏'} onClick={() => {
                navigate("collection");
            }}/>
        </div>
    );
}