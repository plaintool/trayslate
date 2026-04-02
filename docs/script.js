const canvas = document.createElement('canvas');
canvas.id = 'langRain';

// Setup styles to ensure visibility while allowing interaction with underlying elements
Object.assign(canvas.style, {
    position: 'fixed',
    top: '0',
    left: '0',
    width: '100vw',
    height: '100vh',
    zIndex: '0',           // Positioned above the background but below interactive UI if needed
    pointerEvents: 'none'  // CRITICAL: allows clicks to pass through the canvas to site buttons/links
});

document.body.appendChild(canvas);

const ctx = canvas.getContext('2d');

let width, height;
let lastTime = 0;
const symbolsCount = 200; // Slightly reduced for maximum performance and smoothness
const symbols = [];

// Scroll tracking state
let lastScrollY = window.scrollY;
let worldOffsetY = 0;
let scrollSpeed = 0;

// Update canvas dimensions and re-initialize symbols if necessary
function resize() {
    width = canvas.width = window.innerWidth;
    height = canvas.height = window.innerHeight;
    if (symbols.length === 0) {
        for (let i = 0; i < symbolsCount; i++) symbols.push(createSymbol(true));
    }
}

// Generate a random character from various Unicode ranges
function getRandomChar() {
    const ranges = [
        [0x0021, 0x007A], // Latin
        [0x0400, 0x04FF], // Cyrillic
        [0x0370, 0x03FF], // Greek
        [0x0600, 0x06FF], // Arabic
        [0x4E00, 0x9FFF]  // CJK
    ];
    const range = ranges[Math.floor(Math.random() * ranges.length)];
    return String.fromCharCode(Math.floor(Math.random() * (range[1] - range[0])) + range[0]);
}

// Create a new symbol object with randomized properties
function createSymbol(init = false) {
    return {
        x: (Math.random() - 0.5) * width,
        y: (Math.random() - 0.5) * height,
        z: init ? Math.random() * width : width, // Start at different depths during initialization
        speed: Math.random() * 2 + 1,
        char: getRandomChar(),
        rotation: Math.random() * Math.PI,
        rotSpeed: (Math.random() - 0.5) * 0.05,
        size: Math.random() * 25 + 15
    };
}

// Handle physics updates and rendering per frame
function updateAndDraw(dt) {
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillStyle = '#000000'; // Pure black color for maximum contrast

    for (let i = 0; i < symbols.length; i++) {
        const s = symbols[i];
        
        // Move symbol forward based on delta time
        s.z -= s.speed * dt;

        // Reset symbol when it moves past the "camera"
        if (s.z <= 1) {
            Object.assign(s, createSymbol());
        }

        s.rotation += s.rotSpeed * dt;

        // Calculate 3D projection
        const scale = (1 - s.z / width);
        // Apply vertical offset based on scroll with wrapping logic
        const wy = ((s.y - worldOffsetY * 0.5 + height / 2) % height + height) % height - height / 2;
        
        const sx = (s.x / s.z) * width / 2 + width / 2;
        const sy = (wy / s.z) * height / 2 + height / 2;

        const fontSize = Math.max(0.1, s.size * scale * 2);
        
        // Transparency logic: distant symbols are fainter
        const alpha = 0.1 + Math.pow(scale, 2) * 0.6; 

        ctx.globalAlpha = alpha;
        ctx.font = `${Math.floor(fontSize)}px Arial`;

        ctx.save();
        ctx.translate(sx, sy);
        ctx.rotate(s.rotation);
        ctx.fillText(s.char, 0, 0);
        ctx.restore();
    }
    ctx.globalAlpha = 1; // Reset alpha for the next frame
}

// Main animation loop using RequestAnimationFrame
function animate(time) {
    // Calculate Delta Time (target 60fps = 16.66ms)
    const dt = (time - lastTime) / 16.66 || 1;
    lastTime = time;

    ctx.clearRect(0, 0, width, height);
    updateAndDraw(dt);

    // Apply scroll inertia with time-scaling
    scrollSpeed *= Math.pow(0.9, dt);
    worldOffsetY += scrollSpeed * dt;

    requestAnimationFrame(animate);
}

// Handle user scroll input
window.addEventListener('scroll', () => {
    const dy = window.scrollY - lastScrollY;
    lastScrollY = window.scrollY;
    scrollSpeed += dy * 0.3;
});

// Update dimensions on window resize
window.addEventListener('resize', resize);

// Initial start
resize();
requestAnimationFrame(animate);