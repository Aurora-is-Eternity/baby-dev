// 获取页面元素
const tokenAInput = document.getElementById('tokenA');
const tokenBInput = document.getElementById('tokenB');
const swapBtn = document.getElementById('swapBtn');

// 初始汇率：1 Token A = 100 Token B
let rate = 100;
let isReversed = false; // 标记是否切换了方向

// 计算 Token B 数量
function calculateTokenB() {
  const tokenA = parseFloat(tokenAInput.value) || 0;
  const tokenB = isReversed ? tokenA / rate : tokenA * rate;
  tokenBInput.value = tokenB.toFixed(2);
}

// 切换 Swap 方向
function swapDirection() {
  isReversed = !isReversed;
  // 交换标签文字
  const labels = document.querySelectorAll('.token-input label');
  const tempText = labels[0].textContent;
  labels[0].textContent = labels[1].textContent;
  labels[1].textContent = tempText;
  // 重新计算
  calculateTokenB();
}

// 监听输入变化
tokenAInput.addEventListener('input', calculateTokenB);

// 监听按钮点击
swapBtn.addEventListener('click', swapDirection);
