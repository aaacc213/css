const servers = [
    { id: 1, ip: 'eve.mc6.cn', port: 20090, online: false, players: 0, maxPlayers: 2025 },
    { id: 2, ip: 'eve.mc6.cn', port: 20087, online: false, players: 0, maxPlayers: 2025 },
    { id: 3, ip: 'mew.mc6.cn', port: 14452, online: false, players: 0, maxPlayers: 2025 },
    { id: 4, ip: 'ace.mc6.cn', port: 24024, online: false, players: 0, maxPlayers: 2025 }
];

function updateServerStatus(server) {
    const { id, ip, port } = server;
    
    const indicator = document.getElementById(`indicator-${id}`);
    const lastUpdate = document.getElementById(`last-update-${id}`);
    const image = document.getElementById(`server-image-${id}`);
    
    indicator.className = 'inline-block w-3 h-3 rounded-full bg-yellow-500 mr-2 server-indicator';
    lastUpdate.textContent = '加载中...';
    
    MinecraftAPI.getServerStatus(ip, { port }, function (err, status) {
        if (err) {
            console.error(`获取服务器${id}状态失败:`, err);
            indicator.className = 'inline-block w-3 h-3 rounded-full bg-red-500 mr-2 server-indicator';
            lastUpdate.textContent = '获取状态失败';
            server.online = false;
            server.players = 0;
        } else {
            if (status.online) {
                indicator.className = 'inline-block w-3 h-3 rounded-full bg-green-500 mr-2 server-indicator';
                server.online = true;
                server.players = status.players.now || 0;
                document.getElementById(`players-${id}`).textContent = server.players;
                document.getElementById(`max-players-${id}`).textContent = server.maxPlayers;
            } else {
                indicator.className = 'inline-block w-3 h-3 rounded-full bg-red-500 mr-2 server-indicator';
                server.online = false;
                server.players = 0;
            }
            
            const now = new Date();
            const timeString = now.toLocaleTimeString();
            lastUpdate.textContent = timeString;
            
            const timestamp = new Date().getTime();
            image.src = `https://mcapi.us/server/image?ip=${ip}&port=${port}&theme=light&title=${id}区服务器&t=${timestamp}`;
        }
        
        updateOverviewStats();
    });
}

function updateOverviewStats() {
    const onlineCount = servers.filter(server => server.online).length;
    
    const playerCount = servers.reduce((total, server) => total + server.players, 0);
    
    document.getElementById('online-count').textContent = onlineCount;
    document.getElementById('player-count').textContent = playerCount;
}

function initServerStatus() {
    servers.forEach(server => {
        updateServerStatus(server);
        
        const hoverElement = document.getElementById(`server-hover-${server.id}`);
        if (hoverElement) {
            hoverElement.addEventListener('click', () => {
                updateServerStatus(server);
            });
        }
    });
    
    setInterval(() => {
        servers.forEach(server => {
            updateServerStatus(server);
        });
    }, 5 * 60 * 1000);
}

document.addEventListener('DOMContentLoaded', () => {
    initServerStatus();
});