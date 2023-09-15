
import { ethers } from "hardhat";

async function main() {

  const cryptoBackedETF = await ethers.deployContract("CryptoBackedETF");

  await cryptoBackedETF.waitForDeployment();

  console.log("CryptoBackedETF deployed to : ",await cryptoBackedETF.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
