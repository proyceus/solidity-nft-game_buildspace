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

    txn = await gameContract.mintCharacterNFT(0);
    await txn.wait();
    console.log("Minted NFT #1");

    txn = await gameContract.mintCharacterNFT(1);
    await txn.wait();
    console.log("Minted NFT #2");

    txn = await gameContract.mintCharacterNFT(2);
    await txn.wait();
    console.log("Minted NFT #3");

    txn = await gameContract.mintCharacterNFT(1);
    await txn.wait();
    console.log("Minted NFT #4");

    console.log("Done deploying and minting!");
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