export function formatInterval(interval: number) {
    return `${String(Number.parseInt(interval/60)).padStart(2, '0')}:${String(interval%60).padStart(2, '0')}`;
}