// 选择 DOM 元素
const inputAmount = document.querySelector("#input-amount");
const outputAmount = document.querySelector("#output-amount");

const tokenA = document.querySelector("#tokenA");
const tokenB = document.querySelector("#tokenB");

const switchBtn = document.querySelector("#switch");
const priceDisplay = document.querySelector("#price");
let price = 3500;
let isEthToUsdt = true;

inputAmount.oninput = () => {
  const value = parseFloat(inputAmount.value) || 0;

  if (isEthToUsdt) {
    outputAmount.value = value * price;
  } else {
    outputAmount.value = value / price;
  }
};


switchBtn.onclick = () => {

  const temp = tokenA.innerText;
  tokenA.innerText = tokenB.innerText;
  tokenB.innerText = temp;


  const tempValue = inputAmount.value;
  inputAmount.value = outputAmount.value;
  outputAmount.value = tempValue;

  isEthToUsdt = !isEthToUsdt;

  updatePriceText();
};

function updatePriceText() {
  if (isEthToUsdt) {
    priceDisplay.innerText = `1 ${tokenA.innerText} = ${price} ${tokenB.innerText}`;
  } else {
    priceDisplay.innerText = `1 ${tokenB.innerText} = ${price} ${tokenA.innerText}`;
  }
}