const inputAmount = document.querySelector("#A")
       const outputAmount = document.querySelector("#B")
       const tokenA = document.querySelector("#tokenA")
       const tokenB = document.querySelector("#tokenB")
       const switchBtn = document.querySelector("#switch")

        let price = 3500
        let t=false;

        inputAmount.oninput = () => {
            calculateOutput()
        }

         outputAmount.oninput = () => {
            calculateInput()
        }

        function calculateOutput() {
            const value = parseFloat(inputAmount.value)
             if (t) {
                outputAmount.value = value / price
            } else {
                outputAmount.value = value * price
            }
        }

        function calculateInput() {

            const value = parseFloat(outputAmount.value)
            if (t) {
                inputAmount.value = value * price
            } else {
                inputAmount.value = value / price
            }
            formatOutput()
        }

        switchBtn.onclick = () => {
            const temp = tokenA.innerText
            tokenA.innerText = tokenB.innerText
            tokenB.innerText = temp

            t = !t

            const tempValue = inputAmount.value
            inputAmount.value = outputAmount.value
            outputAmount.value = tempValue
        }