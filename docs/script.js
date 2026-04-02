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

// Detect if device is mobile based on width or touch capabilities
const isMobile = window.innerWidth < 768 || ('ontouchstart' in window) || (navigator.maxTouchPoints > 0);

let width, height;
let lastTime = 0;
// Use 100 symbols for mobile to save battery/GPU, 200 for desktop
const symbolsCount = isMobile ? 100 : 200; 
const symbols = [];

// Scroll and physics state
let lastScrollY = window.scrollY;
let worldOffsetY = 0;
let scrollSpeed = 0;

function resize() {
    // Handle High DPI (Retina) displays for sharpness
    const dpr = window.devicePixelRatio || 1;
    width = window.innerWidth;
    height = window.innerHeight;
    
    // Set actual canvas size based on pixel density
    canvas.width = width * dpr;
    canvas.height = height * dpr;
    
    // Scale the context so drawing coordinates remain consistent
    ctx.scale(dpr, dpr);

    // Initial population of symbols
    if (symbols.length === 0) {
        for (let i = 0; i < symbolsCount; i++) {
            symbols.push(createSymbol(true));
        }
    }
}

// Safer Unicode ranges to avoid "empty squares" on mobile
function getRandomChar() {
    const ranges = [
        [0x0021, 0x007A], // Latin
        [0x0410, 0x044F], // Cyrillic
        [0x03B1, 0x03C9], // Greek
        [0x30A0, 0x30FF], // Katakana
        [0x4E00, 0x4E8F]  // Common CJK
    ];
    const range = ranges[Math.floor(Math.random() * ranges.length)];
    return String.fromCharCode(Math.floor(Math.random() * (range[1] - range[0])) + range[0]);
}

// Initialize a symbol with randomized 3D coordinates and rotation
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

// Logic and Rendering loop
function updateAndDraw(dt) {
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillStyle = '#000000'; // Black characters for white background

    const fontStack = 'Arial, "Helvetica Neue", Helvetica, "Noto Sans JP", sans-serif';

    for (let i = 0; i < symbols.length; i++) {
        const s = symbols[i];
        
        // Move symbol towards the camera using Delta Time
        s.z -= s.speed * dt;

        // Reset if symbol passed the camera
        if (s.z <= 1) {
            Object.assign(s, createSymbol());
        }

        s.rotation += s.rotSpeed * dt;

        // 3D Projection math
        const scale = (1 - s.z / width);
        // Calculate vertical wrap-around for scroll effect
        const wy = ((s.y - worldOffsetY * 0.5 + height / 2) % height + height) % height - height / 2;
        
        const sx = (s.x / s.z) * width / 2 + width / 2;
        const sy = (wy / s.z) * height / 2 + height / 2;

        const fontSize = Math.max(0.1, s.size * scale * 2);
        const alpha = 0.1 + Math.pow(scale, 2) * 0.6; 

        ctx.globalAlpha = alpha;
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
    // Calculate Delta Time to normalize speed across different refresh rates
    const dt = (time - lastTime) / 16.66 || 1;
    lastTime = time;

    ctx.clearRect(0, 0, width, height);
    updateAndDraw(dt);

    // Friction/Inertia for scroll speed
    scrollSpeed *= Math.pow(0.9, dt);
    worldOffsetY += scrollSpeed * dt;

    requestAnimationFrame(animate);
}

// Track vertical scroll velocity
window.addEventListener('scroll', () => {
    const dy = window.scrollY - lastScrollY;
    lastScrollY = window.scrollY;
    scrollSpeed += dy * 0.3;
});

// Update dimensions on resize (handling orientation changes on mobile)
window.addEventListener('resize', resize);

// Initial execution
resize();
requestAnimationFrame(animate);