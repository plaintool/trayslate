// create canvas
const canvas = document.createElement('canvas');
canvas.id = 'langRain';
document.body.appendChild(canvas);

const ctx = canvas.getContext('2d');

let width = canvas.width = window.innerWidth;
let height = canvas.height = window.innerHeight;

// settings
const symbolsCount = 300;
const symbols = [];

// scroll
let lastScrollY = window.scrollY;
let worldOffsetY = 0;
let scrollSpeed = 0;

// random unicode char
function getRandomChar() {
  const ranges = [
    [0x0021, 0x007A], // latin
    [0x0400, 0x04FF], // cyrillic
    [0x0370, 0x03FF], // greek
    [0x0600, 0x06FF], // arabic
    [0x4E00, 0x9FFF]  // CJK (chinese/japanese/korean)
  ];

  const range = ranges[Math.floor(Math.random() * ranges.length)];
  const code = Math.floor(Math.random() * (range[1] - range[0])) + range[0];

  return String.fromCharCode(code);
}

// create symbol
function createSymbol() {
  return {
    x: (Math.random() - 0.5) * width,
    y: (Math.random() - 0.5) * height,
    z: Math.random() * width,
    speed: Math.random() * 2 + 1,
    char: getRandomChar(),
    rotation: Math.random() * Math.PI,
    rotSpeed: (Math.random() - 0.5) * 0.05,
    size: Math.random() * 20 + 10
  };
}

// init
function initSymbols() {
  symbols.length = 0;
  for (let i = 0; i < symbolsCount; i++) {
    symbols.push(createSymbol());
  }
}

initSymbols();

// draw
function drawSymbols() {
  symbols.forEach(s => {
    // move forward
    s.z -= s.speed;

    if (s.z <= 1) {
      s.z = width;
      s.x = (Math.random() - 0.5) * width;
      s.y = (Math.random() - 0.5) * height;
      s.char = getRandomChar();
    }

    // scroll effect
    let wy = s.y - worldOffsetY * 0.5;

    const halfH = height / 2;
    wy = ((wy + halfH) % height + height) % height - halfH;

    // projection
    const sx = (s.x / s.z) * width / 2 + width / 2;
    const sy = (wy / s.z) * height / 2 + height / 2;

    const scale = (1 - s.z / width);
    const fontSize = s.size * scale * 2;

    s.rotation += s.rotSpeed;

    ctx.save();
    ctx.translate(sx, sy);
    ctx.rotate(s.rotation);

    // transparency
    const alpha = 0.03 + Math.pow(scale, 2) * 0.8;
    ctx.globalAlpha = alpha;

    ctx.font = `${fontSize}px Arial`;
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(s.char, 0, 0);

    ctx.restore();
  });

  ctx.globalAlpha = 1;
}

// animation
function animate() {
  ctx.clearRect(0, 0, width, height);

  drawSymbols();

  // inertia
  scrollSpeed *= 0.9;
  worldOffsetY += scrollSpeed;

  requestAnimationFrame(animate);
}

animate();

// scroll
window.addEventListener('scroll', () => {
  const dy = window.scrollY - lastScrollY;
  lastScrollY = window.scrollY;

  scrollSpeed += dy * 0.3;
});

// resize
window.addEventListener('resize', () => {
  width = canvas.width = window.innerWidth;
  height = canvas.height = window.innerHeight;
  initSymbols();
});