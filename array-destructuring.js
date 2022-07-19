let f = ["apples", "bananas", "oranges", "pears"]

// let a = f[0];
// let b = f[1];
// let c = f[2];
// let d = f[3];

// vs

function getFruits(){
    return ["apples", "bananas", "oranges", "pears"]
}

// let [a,b,c] = getFruits();

// if i only want the first fruits then
let [a] = getFruits();

