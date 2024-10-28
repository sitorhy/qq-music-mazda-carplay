import styles from '../style/NavButton.module.css';

export default function NavButton (
    props: {
        icon: string;
        title: string;
        onClick?: () => void;
    }
) {
    return (
        <div className={styles.button} onClick={props.onClick}>
            <div className={styles.icon}>
                <span className="material-icons">{props.icon}</span>
            </div>
            <div className={styles.title}>
                <span>{props.title}</span>
            </div>
        </div>
    );
}