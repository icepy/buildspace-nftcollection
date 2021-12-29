const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log('Contract deployed to: ', nftContract.address);


  // 第一次领取

  let txn = await nftContract.makeAnEpicNFT();
  await txn.wait();

  
  // 第二次领取
  txn = await nftContract.makeAnEpicNFT();
  await txn.wait();
}

async function run(){
  try{
    await main();
  } catch(e){
    console.log(e);
    process.exit(1);
  }
}

run();