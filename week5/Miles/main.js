let rate = 71000;

const inputs = document.querySelectorAll('input');
const btn = document.querySelector('#switch-btn');
const priceText = document.querySelector('#price');

inputs[0].oninput = () => {
    inputs[1].value = (inputs[0].value * rate).toFixed(2);
};

btn.onclick = () => {
    rate = 1 / rate; 
    
    const isBtcToUsdt = rate < 100;
    const tokenA = isBtcToUsdt ? "USDT" : "BTC";
    const tokenB = isBtcToUsdt ? "BTC" : "USDT";
    
    document.querySelector('#TokenA').innerText = tokenA;
    document.querySelector('#TokenB').innerText = tokenB;
    priceText.innerText = `1 ${tokenA} = ${rate.toFixed(isBtcToUsdt ? 6 : 0)} ${tokenB}`;
    
    inputs[0].value = "";
    inputs[1].value = "";
};