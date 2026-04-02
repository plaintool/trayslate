const canvas = document.createElement('canvas');
canvas.id = 'langRain';

// Setup styles for visibility and click-through
Object.assign(canvas.style, {
    position: 'fixed',
    top: '0',
    left: '0',
    width: '100vw',
    height: '100vh',
    zIndex: '0',
    pointerEvents: 'none'
});

document.body.appendChild(canvas);

const ctx = canvas.getContext('2d');

let width, height;
let lastTime = 0;
const symbolsCount = 150; // Reduced slightly for better mobile battery/performance
const symbols = [];

let lastScrollY = window.scrollY;
let worldOffsetY = 0;
let scrollSpeed = 0;

function resize() {
    width = canvas.width = window.innerWidth;
    height = canvas.height = window.innerHeight;
    if (symbols.length === 0) {
        for (let i = 0; i < symbolsCount; i++) symbols.push(createSymbol(true));
    }
}

// Narrowed ranges to ensure better mobile compatibility
function getRandomChar() {
    const ranges = [
        [0x0021, 0x007A], // Basic Latin
        [0x0410, 0x044F], // Common Cyrillic (uppercase/lowercase)
        [0x03B1, 0x03C9], // Common Greek (lowercase)
        [0x30A0, 0x30FF], // Katakana (Japanese - usually well-supported)
        [0x4E00, 0x4E8F]  // Very common CJK (Limited range to avoid "missing" glyphs)
    ];
    const range = ranges[Math.floor(Math.random() * ranges.length)];
    return String.fromCharCode(Math.floor(Math.random() * (range[1] - range[0])) + range[0]);
}

function createSymbol(init = false) {
    return {
        x: (Math.random() - 0.5) * width,
        y: (Math.random() - 0.5) * height,
        z: init ? Math.random() * width : width,
        speed: Math.random() * 2 + 1,
        char: getRandomChar(),
        rotation: Math.random() * Math.PI,
        rotSpeed: (Math.random() - 0.5) * 0.05,
        size: Math.random() * 20 + 15
    };
}

function updateAndDraw(dt) {
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillStyle = '#000000';

    // Added a more comprehensive font fallback stack
    const fontStack = 'Arial, "Helvetica Neue", Helvetica, "Noto Sans JP", "Noto Sans", sans-serif';

    for (let i = 0; i < symbols.length; i++) {
        const s = symbols[i];
        s.z -= s.speed * dt;

        if (s.z <= 1) {
            Object.assign(s, createSymbol());
        }

        s.rotation += s.rotSpeed * dt;

        const scale = (1 - s.z / width);
        const wy = ((s.y - worldOffsetY * 0.5 + height / 2) % height + height) % height - height / 2;
        
        const sx = (s.x / s.z) * width / 2 + width / 2;
        const sy = (wy / s.z) * height / 2 + height / 2;

        const fontSize = Math.max(0.1, s.size * scale * 2);
        const alpha = 0.1 + Math.pow(scale, 2) * 0.6; 

        ctx.globalAlpha = alpha;
        // Floor the font size to prevent sub-pixel rendering blur on mobile
        ctx.font = `${Math.floor(fontSize)}px ${fontStack}`;

        ctx.save();
        ctx.translate(sx, sy);
        ctx.rotate(s.rotation);
        ctx.fillText(s.char, 0, 0);
        ctx.restore();
    }
    ctx.globalAlpha = 1;
}

function animate(time) {
    const dt = (time - lastTime) / 16.66 || 1;
    lastTime = time;

    ctx.clearRect(0, 0, width, height);
    updateAndDraw(dt);

    scrollSpeed *= Math.pow(0.9, dt);
    worldOffsetY += scrollSpeed * dt;

    requestAnimationFrame(animate);
}

window.addEventListener('scroll', () => {
    const dy = window.scrollY - lastScrollY;
    lastScrollY = window.scrollY;
    scrollSpeed += dy * 0.3;
});

window.addEventListener('resize', resize);
resize();
requestAnimationFrame(animate);