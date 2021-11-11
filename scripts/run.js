const main = async () => {
    const gameContractFactory = await hre.ethers.getContractFactory('MyEpicGame');
    const gameContract = await gameContractFactory.deploy(
        ["Rock", "Paper", "Scissor"], //Names
        ["https://i.imgur.com/vxlMoGz.png", "https://i.imgur.com/5rE9zeh.png", "https://i.imgur.com/zZSMKK6.png"], //images
        [200, 300, 75], //hp values
        [50, 25, 150] //atk values
    );
    await gameContract.deployed();
    console.log("Contract deployed to:", gameContract.address);

    let txn;

    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();

    //get value of NFTs URI
    let returnedTokenUri = await gameContract.tokenURI(1);
    console.log("Token URI:", returnedTokenUri);
};



const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (err) {
        console.log(err);
        process.exit(1);
    }
};

runMain();