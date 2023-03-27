//imports
const { ethers, run, network } = require("hardhat");
//async main function
async function main() {
  const myTokenFactory = await ethers.getContractFactory("MyToken");
  console.log("deploying contract .....");
  const myToken = await myTokenFactory.deploy();
  await myToken.deployed();
  const contractAddress = await myToken.address;
  const itemPrice = await myToken.price();
  console.log(itemPrice.toString());
  console.log(contractAddress);
  console.log(network.config);

  if (network.config.chainId == 5 && process.env.ETHERSCAN_API_KEY) {
    console.log("waiting for block confirmation");
    await myToken.deployTransaction.wait(6);
    await verify(contractAddress, []);
  }
}
//verify function

async function verify(contractAddress, args) {
  console.log("Verifying Contract...");
  try {
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: args,
    });
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already verified");
    } else {
      console.log(e);
    }
  }
}

//main

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
